//
//  ViewController.swift
//  DictaMed
//
//  Created by Adrian Mateoaea on 10.10.2015.
//  Copyright © 2015 Adrian Mateoaea. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var sphereView: UIView!
    
    var button: UIButton!

    var recorder: AudioRecorder!
    
    var speech: AudioToSpeech!
    
    var recording: Bool = false {
        didSet {
            UIView.transitionWithView(self.button, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight,
                animations: { () -> Void in
                    self.button.setImage(UIImage(named: self.recording ? "ic_stop" : "ic_record"), forState: UIControlState.Normal)
                }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppTheme.LIGHT_GREEN
        
        let logo1 = UIImageView()
        logo1.image = UIImage(named: "ic_wave")
        logo1.tintColor = AppTheme.DARK_GREEN
        self.view.addSubview(logo1)
        logo1.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
        }
        
        self.sphereView = UIView()
        self.sphereView.backgroundColor = AppTheme.DARK_GREEN
        self.view.addSubview(self.sphereView)
        self.sphereView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 300, height: 300))
            make.center.equalTo(self.view)
        }
        
        let mask = CAShapeLayer()
        mask.path = CGPathCreateWithEllipseInRect(CGRect(x: -150, y: -150, width: 300, height: 300), nil)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: 150, y: 150)
        self.sphereView.layer.mask = mask
        self.sphereView.layer.mask?.transform = CATransform3DMakeScale(0, 0, 1)
        
        let logo2 = UIImageView()
        logo2.image = UIImage(named: "ic_wave")
        logo2.tintColor = UIColor(red:0, green:1, blue:0.79, alpha:1)
        self.sphereView.addSubview(logo2)
        logo2.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.sphereView)
        }
        
        self.button = UIButton()
        self.button.setImage(UIImage(named: "ic_record"), forState: UIControlState.Normal)
        self.button.contentEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        self.button.tintColor = AppTheme.DARK_GREEN
        self.button.addTarget(self, action: "startStop", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.button)
        self.button.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        let languageButton = UIButton()
        languageButton.setTitle(String(AudioToSpeechLanguage.Romană), forState: UIControlState.Normal)
        languageButton.setTitleColor(AppTheme.DARK_GREEN, forState: UIControlState.Normal)
        languageButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        languageButton.contentEdgeInsets = UIEdgeInsets(top: 35, left: 20, bottom: 35, right: 20)
        languageButton.tintColor = AppTheme.DARK_GREEN
        languageButton.addTarget(self, action: "changeLanguage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(languageButton)
        languageButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        self.recorder = AudioRecorder()
        self.recorder.delegate = self
        
        self.speech = AudioToSpeech()
        self.speech.delegate = self
    }
    
    func startStop() {
        if self.recorder.recording {
            self.recorder.stopRecording()
        } else {
            self.recorder.record()
        }
    }
    
    func changeLanguage(button: UIButton) {
        if self.speech.language == AudioToSpeechLanguage.Romană {
            self.speech.language = AudioToSpeechLanguage.English
        } else {
            self.speech.language = AudioToSpeechLanguage.Romană
        }
        button.setTitle(String(self.speech.language), forState: UIControlState.Normal)
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event?.subtype == UIEventSubtype.RemoteControlTogglePlayPause {
            self.startStop()
        }
    }
    
}

extension MainViewController: AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder) {
        self.recording = true
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        self.recording = false
        self.button.enabled = false
        self.speech.sendAudio(recorder.fileURL)
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            let scale = min(level * 4, 1)
            self.sphereView.layer.mask?.transform = CATransform3DMakeScale(scale, scale, 1)
        })
    }
    
}

extension MainViewController: AudioToSpeechDelegate {
    
    func didReceiveAudioTranscript(transcript: String?) {
        let alert = UIAlertController(title: nil, message: transcript, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cool, it works!", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
