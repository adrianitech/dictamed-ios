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
    
    var lastLevel: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)
        self.level.transform = CGAffineTransformMakeScale(0, 0)
        
        self.recorder = AudioRecorder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.recorder.delegate = nil
        self.recorder.stopRecording()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.recorder.delegate = self
        self.recorder.record()
    }
    
    @IBAction func stop(sender: AnyObject) {
        self.recorder.stopRecording()
    }
    
}

extension RecordViewController: AudioRecorderDelegate {
    
    func transcribeAudio() {
        API.sharedInstance.transcribeAudio(recorder.fileURL,
                                           progress: { (p) in
                                            SVProgressHUD.showProgress(Float(p) * 0.5, status: "Transcribing")
            },
                                           callback: { (obj, _) in
                                            SVProgressHUD.showProgress(0.5, status: "Uploading")
                                            if let translation = obj.result {
                                                self.submitTranscript(translation)
                                            }
        })
    }
    
    func submitTranscript(translation: String) {
        API.sharedInstance.postTranscript("Sent from iPhone", translation: translation) { (obj, _) in
            if let id = obj.result?.id {
                API.sharedInstance.postAudio(id, file: self.recorder.fileURL,
                                             progress: { (p) in
                                                SVProgressHUD.showProgress(0.5 + Float(p) * 0.5, status: "Uploading")
                    },
                                             callback: { (_, _) in
                                                SVProgressHUD.dismiss()
                                                self.tabBarController?.selectedIndex = 1
                })
            }
        }
    }
    
    func didStartRecording(recorder: AudioRecorder) {
        //
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.show()
        transcribeAudio()
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        lastLevel = lastLevel + (level - lastLevel) / 10
        self.level.transform = CGAffineTransformMakeScale(lastLevel, lastLevel)
    }
    
    func didUpdateTime(recorder: AudioRecorder, time: Double) {
        let date = NSDate(timeIntervalSince1970: time)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss.SS"
        
        self.timeLabel.text = dateFormatter.stringFromDate(date)
    }
    
}
