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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.URL = context as! NSURL
    }

    override func willActivate() {
        self.loadingIndicator = EMTLoadingIndicator(
            interfaceController: self,
            interfaceImage: self.loaderImage,
            width: 40, height: 40,
            style: EMTLoadingIndicatorWaitStyle.Line)
        self.loadingIndicator.prepareImagesForProgress()
        self.loadingIndicator.showProgress(startPercentage: 0)
        
        super.willActivate()
        
        self.upload(self.URL)
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func upload(URL: NSURL) {
        self.statusLabel.setText("Transcribing")
        DictamedAPI.sharedInstance.transcribeAudio(URL, language: AudioLanguage.Romana) { (finished, progress, text) in
            if !finished {
                self.loadingIndicator.updateProgress(percentage: progress * 50)
            } else {
                self.statusLabel.setText("Uploading")
                self.loadingIndicator.updateProgress(percentage: 50)
                DictamedAPI.sharedInstance.submitAudio(URL, translation: text, device: DictamedDeviceType.Watch) { (finished2, progress2) in
                    if !finished2 {
                        self.loadingIndicator.updateProgress(percentage: 50 + progress2 * 50)
                    } else {
                        self.dismissController()
                    }
                }
            }
        }
    }

}
