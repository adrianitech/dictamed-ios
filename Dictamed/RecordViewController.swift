//
//  RecordViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 29.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import SVProgressHUD

class RecordViewController: UIViewController {
    
    @IBOutlet weak var level: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var recorder: AudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)
        
        self.recorder = AudioRecorder()
        self.recorder.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.recorder.record()
    }
    
    @IBAction func stop(sender: AnyObject) {
        self.recorder.stopRecording()
    }
    
    @IBAction func record(sender: AnyObject) {
        if self.recorder.recording {
            self.recorder.stopRecording()
        } else {
            self.recorder.record()
        }
    }
    
}

extension RecordViewController: AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder) {
        //
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.show()
        
        DictamedAPI.sharedInstance.transcribeAudio(recorder.fileURL, language: AudioLanguage.Romana) { (finished, progress, text) in
            if !finished {
                SVProgressHUD.showProgress(progress * 0.5, status: "Transcribing")
            } else {
                SVProgressHUD.showProgress(0.5, status: "Uploading")
                DictamedAPI.sharedInstance.submitAudio(recorder.fileURL, translation: text, device: DictamedDeviceType.Phone) { (finished2, progress2) in
                    if !finished2 {
                        SVProgressHUD.showProgress(0.5 + progress * 0.5, status: "Uploading")
                    } else {
                        SVProgressHUD.showSuccessWithStatus("Done")
                        self.tabBarController?.selectedIndex = 1
                    }
                }
            }
        }
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        UIView.animateWithDuration(0.1) {
            self.level.transform = CGAffineTransformMakeScale(level, level)
        }
    }
    
    func didUpdateTime(recorder: AudioRecorder, time: Double) {
        let date = NSDate(timeIntervalSince1970: time)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        self.timeLabel.text = dateFormatter.stringFromDate(date)
    }
    
}
