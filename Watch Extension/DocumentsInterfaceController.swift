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
    
    func setNumberOfDocuments(count: Int) {
        var types = Array<String>(count: count, repeatedValue: "document")
        types.insert("record", atIndex: 0)
        
        self.tableView.setRowTypes(types)
        
        let cell = self.tableView.rowControllerAtIndex(0) as! RecordTableViewCell
        cell.recordCallback = record
        cell.refreshCallback = refresh
    }
    
    var items: [TranscriptAPIModel] = [] {
        didSet {
            setNumberOfDocuments(self.items.count)
            
            for i in 0..<self.items.count {
                let cell = self.tableView.rowControllerAtIndex(i + 1) as! DocumentTableViewCell
                let item = self.items[i]
                
                cell.titleLabel.setText(item.title)
                cell.contentLabel.setText(item.translation)
                
                if item.validated {
                    cell.lineView.setBackgroundColor(UIColor(red:0.42, green:0.73, blue:0.27, alpha:1.00))
                } else {
                    cell.lineView.setBackgroundColor(UIColor(red:0.98, green:0.75, blue:0.02, alpha:1.00))
                }
            }
        }
    }
    
    func record() {
        let fileManager = NSFileManager.defaultManager()
        let container = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.dictamed.Dictamed")
        let URL = container?.URLByAppendingPathComponent("audio.wav")
        
        let duration = NSTimeInterval(60)
        let recordOptions = [WKAudioRecorderControllerOptionsMaximumDurationKey : duration]
        
        presentAudioRecorderControllerWithOutputURL(URL!, preset: .WideBandSpeech, options: recordOptions, completion: { saved, error in
            if let err = error {
                print(err.description)
            }
            
            if saved {
                self.presentControllerWithName("Upload", context: URL!)
            }
        })
    }

    func refresh() {
        API.sharedInstance.getTranscripts { (obj, _) in
            if let items = obj.result {
                dispatch_async(dispatch_get_main_queue()) {
                    self.items = items.sort {
                        $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970
                    }
                }
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        setNumberOfDocuments(0)
    }
    
    override func willActivate() {
        super.willActivate()
        self.refresh()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
