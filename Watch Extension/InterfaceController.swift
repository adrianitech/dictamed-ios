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

    @IBOutlet var statusLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func record() {
        
        self.statusLabel.setText("")
        
        let fileManager = NSFileManager.defaultManager()
        let container = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.dictamed.Dictamed")
        let URL = container?.URLByAppendingPathComponent("audio.wav")
        
        let duration = NSTimeInterval(60)
        let recordOptions = [WKAudioRecorderControllerOptionsMaximumDurationKey : duration]
        
        presentAudioRecorderControllerWithOutputURL(URL!, preset: .WideBandSpeech, options: recordOptions, completion: { saved, error in
            if let err = error {
                self.statusLabel.setText("Error")
                print(err.description)
            }

            if saved {
                self.statusLabel.setText("Uploading...")
                DictamedAPI.sharedInstance.transcribeAudio(URL!, language: AudioLanguage.Romana, callback: { (text) in
                    DictamedAPI.sharedInstance.submitAudio(URL!, translation: text, device: DictamedDeviceType.Watch) {
                        self.statusLabel.setText("")
                    }
                })
            }
        })
    }
}
