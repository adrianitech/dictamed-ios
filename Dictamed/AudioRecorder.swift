//
//  AudioRecorder.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 25.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder)
    
    func didStopRecording(recorder: AudioRecorder)
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat)
    
    func didUpdateTime(recorder: AudioRecorder, time: Double)
    
}

class AudioRecorder: NSObject {
    
    var delegate: AudioRecorderDelegate?
    
    var recorder: AVAudioRecorder!
    
    var meterTimer: NSTimer!
    
    var fileURL: NSURL!
    
    var startTime: Double = 0
    
    var recording: Bool {
        get {
            return self.recorder?.recording ?? false
        }
    }
    
    override init() {
        super.init()
        self.setSessionRecord()
    }
    
    func setSessionRecord() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
        } catch let error as NSError {
            print("Could not set session: \(error.localizedDescription)")
        }
    }
    
    func setupRecorder() {
        let fileName = "audio.wav"
        
        let fileManager = NSFileManager.defaultManager()
        let container = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.dictamed.Dictamed")
        self.fileURL = container?.URLByAppendingPathComponent(fileName)
        
        let recordSettings: [String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 128000,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 16000
        ]
        
        do {
            self.recorder = try AVAudioRecorder(URL: self.fileURL, settings: recordSettings)
            self.recorder.meteringEnabled = true
            self.recorder.prepareToRecord()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            self.recorder = nil
        }
        
    }
    
    func record() {
        self.startTime = NSDate().timeIntervalSince1970
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) -> Void in
            if granted {
                if self.recorder == nil {
                    self.setupRecorder()
                }
                self.recorder.record()
                self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,
                    selector: #selector(AudioRecorder.updateAudioMeter), userInfo: nil, repeats: true)
                
                self.delegate?.didStartRecording(self)
            } else {
                print("Permission to record not granted")
            }
        })
    }
    
    func stopRecording() {
        self.recorder?.stop()
        self.meterTimer?.invalidate()
        self.delegate?.didStopRecording(self)
        self.delegate?.didReceiveAudioLevel(self, level: 0)
    }
    
    func updateAudioMeter() {
        if self.recorder.recording {
            self.recorder.updateMeters()
            let decibels = self.recorder.averagePowerForChannel(0)
            let linear = min(1, CGFloat(pow(10, decibels / 20)) * 3)
            self.delegate?.didReceiveAudioLevel(self, level: linear)
            
            let diff = 60 - (NSDate().timeIntervalSince1970 - self.startTime)
            self.delegate?.didUpdateTime(self, time: diff)
        }
    }
    
}
