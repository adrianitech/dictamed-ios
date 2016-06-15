//
//  DocumentsInterfaceController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 29.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import WatchKit
import Foundation

class DocumentsInterfaceController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    
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

    override func willActivate() {
        super.willActivate()
        
        API.sharedInstance.getTranscripts { (obj, _) in
            if let items = obj.result {
                self.items = items.sort {
                    $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970
                }
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
