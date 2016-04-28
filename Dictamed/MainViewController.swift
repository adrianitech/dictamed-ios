//
//  MainViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 24.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var recorder: AudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var volumeView: UIView!
    
    var startTime: NSTimeInterval = 0
    
    var isRecording = false {
        didSet {
            if isRecording {
                self.recordButton.setTitle("STOP", forState: UIControlState.Normal)
                self.recorder.record()
            } else {
                self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
                self.timeLabel.text = ""
                self.recorder.stopRecording()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.volumeView.transform = CGAffineTransformMakeScale(0, 0)
        
        self.recorder = AudioRecorder()
        self.recorder.delegate = self
    }

    @IBAction func record(sender: AnyObject) {
        self.isRecording = !self.isRecording
    }
    
}

extension MainViewController: AudioRecorderDelegate {
    
    func setTime() {
        if !self.recorder.recording { return }
        
        let diff = NSDate().timeIntervalSince1970 - self.startTime
        let date = NSDate(timeIntervalSince1970: diff)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        self.timeLabel.text = dateFormatter.stringFromDate(date)
    }
    
    func didStartRecording(recorder: AudioRecorder) {
        self.startTime = NSDate().timeIntervalSince1970
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        self.timeLabel.text = "Transcribing..."
        DictamedAPI.sharedInstance.transcribeAudio(recorder.fileURL, language: AudioLanguage.Romana) { (_, _, text) in
            self.timeLabel.text = "Uploading..."
            DictamedAPI.sharedInstance.submitAudio(recorder.fileURL, translation: text, device: DictamedDeviceType.Phone) { (_, _) in
                self.timeLabel.text = ""
            }
        }
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        self.setTime()
        UIView.animateWithDuration(0.2) {
            self.volumeView.transform = CGAffineTransformMakeScale(level, level)
        }
    }
    
}
