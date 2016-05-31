//
//  DocumentsInterfaceController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 29.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import WatchKit
import Foundation
import EMTLoadingIndicator

class DocumentsInterfaceController: WKInterfaceController {

    @IBOutlet var loadingImage: WKInterfaceImage!
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    private var loadingIndicator: EMTLoadingIndicator!
    
    var items: [TranscriptAPIModel] = [] {
        didSet {
            self.tableView.setNumberOfRows(self.items.count, withRowType: "cell")
            
            for i in 0..<self.items.count {
                let cell = self.tableView.rowControllerAtIndex(i) as! DocumentTableViewCell
                let item = self.items[i]
                
                cell.titleLabel.setText(item.title)
                cell.contentLabel.setText(item.translation)
                
                if item.validated {
                    cell.imageView.setImage(UIImage(named: "ic_check"))
                } else {
                    cell.imageView.setImage(UIImage(named: "ic_pending"))
                }
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.loadingIndicator = EMTLoadingIndicator(
            interfaceController: self,
            interfaceImage: self.loadingImage,
            width: 24, height: 24,
            style: EMTLoadingIndicatorWaitStyle.Line)
        self.loadingIndicator.prepareImagesForWait()
    }

    override func willActivate() {
        super.willActivate()
        
        self.loadingImage.setHidden(false)
        self.loadingIndicator.showWait()
        
        API.sharedInstance.getTranscripts { (obj, _) in
            if let items = obj.result {
                self.loadingImage.setHidden(true)
                self.loadingIndicator.hide()

                self.items = items.sort { $0.validated && !$1.validated }
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
