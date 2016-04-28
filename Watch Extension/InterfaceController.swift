//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Adrian Mateoaea on 24.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func record() {
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
                self.presentControllerWithName("Page2", context: URL!)
            }
        })
    }
}
