//
//  ViewController.swift
//  DictaMed
//
//  Created by Adrian Mateoaea on 10.10.2015.
//  Copyright © 2015 Adrian Mateoaea. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    
    var sphereView: UIView!
    
    var label: UILabel!

    var recorder: AudioRecorder!
    
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
        
        self.label = UILabel()
        self.label.font = UIFont.boldSystemFontOfSize(16)
        self.label.textColor = AppTheme.DARK_GREEN
        self.label.textAlignment = NSTextAlignment.Center
        self.label.numberOfLines = 0
        self.view.addSubview(self.label)
        self.label.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.view).offset(35)
            make.trailing.equalTo(self.view).offset(-35)
            make.bottom.equalTo(self.view).offset(-35)
        }
        
        self.recorder = AudioRecorder()
        self.recorder.delegate = self
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        let tap = UITapGestureRecognizer(target: self, action: "startStop")
        self.view.addGestureRecognizer(tap)
    }
    
    func startStop() {
        if self.recorder.recording {
            self.recorder.stopRecording()
        } else {
            self.recorder.record()
        }
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event?.subtype == UIEventSubtype.RemoteControlTogglePlayPause {
            self.startStop()
        }
    }
    
}

extension MainViewController: AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder) {
        self.label.text = "Recording..."
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        self.label.text = "Processing..."
        Alamofire.upload(.POST, "https://www.google.com/speech-api/v2/recognize?output=json&lang=ro-ro&key=AIzaSyA3QauQzWiq8sNp-13WZVkv5MLHoehjkrM",
            headers: ["Content-Type": "audio/l16; rate=16000;"], file: recorder.fileURL).responseString { (r) -> Void in
                let index = r.result.value?.characters.indexOf("\n")
                let x = r.result.value!.substringFromIndex(index!)
                if let j = x.dataUsingEncoding(NSUTF8StringEncoding) {
                    let json = JSON(data: j)
                    let text = json["result", 0, "alternative", 0, "transcript"].stringValue
                    self.label.text = text
                }
            }
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            var x = level * 3
            if x > 1 { x = 1 }
            self.sphereView.layer.mask?.transform = CATransform3DMakeScale(x, x, 1)
        })
    }
    
}
