//
//  UploadInterfaceController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 28.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import WatchKit
import Foundation
import EMTLoadingIndicator

class UploadInterfaceController: WKInterfaceController {

    @IBOutlet var loaderImage: WKInterfaceImage!
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    private var loadingIndicator: EMTLoadingIndicator!
    
    private var URL: NSURL!
    
    private var uploading: Bool = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.URL = context as! NSURL
    }

    override func willActivate() {
        self.loadingIndicator = EMTLoadingIndicator(
            interfaceController: self,
            interfaceImage: self.loaderImage,
            width: 60, height: 60,
            style: EMTLoadingIndicatorWaitStyle.Line)
        self.loadingIndicator.prepareImagesForProgress()
        self.loadingIndicator.showProgress(startPercentage: 0)
        
        super.willActivate()
        
        if !self.uploading {
            self.uploading = true
            self.upload(self.URL)
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func transcribeAudio(URL: NSURL) {
        API.sharedInstance.transcribeAudio(URL,
                                           progress: { (p) in
                                            self.loadingIndicator.updateProgress(percentage: Float(p) * 50)
            },
                                           callback: { (obj, _) in
                                            self.statusLabel.setText("Uploading")
                                            self.loadingIndicator.updateProgress(percentage: 50)
                                            if let translation = obj.result {
                                                self.submitTranscript(translation, URL: URL)
                                            }
        })
    }
    
    func submitTranscript(translation: String, URL: NSURL) {
        API.sharedInstance.postTranscript("Sent from Watch", translation: translation) { (obj, _) in
            if let id = obj.result?.id {
                API.sharedInstance.postAudio(id, file: URL,
                                             progress: { (p) in
                                                self.loadingIndicator.updateProgress(percentage: 50 + Float(p) * 50)
                    },
                                             callback: { (_, _) in
                                                self.dismissController()
                })
            }
        }
    }
    
    func upload(URL: NSURL) {
        self.statusLabel.setText("Transcribing")
        transcribeAudio(URL)
    }

}
