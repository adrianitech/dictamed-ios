//
//  MainViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 24.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var volumeView: UIView!
    
    var time: Double = 0 {
        didSet {
            let date = NSDate(timeIntervalSince1970: self.time)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "mm:ss"
            self.timeLabel.text = dateFormatter.stringFromDate(date)
        }
    }
    
    var isRecording = false {
        didSet {
            if isRecording {
                self.recordButton.setTitle("STOP", forState: UIControlState.Normal)
                self.timeLabel.text = "00:00"
                
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(MainViewController.vu), userInfo: nil, repeats: true)
                
            } else {
                self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
                self.timeLabel.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func vu() {
        self.time = self.time + 1
        
        let scale = CGFloat(arc4random_uniform(100)) / 100
        UIView.animateWithDuration(0.5) { 
            self.volumeView.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }

    @IBAction func record(sender: AnyObject) {
        self.isRecording = !self.isRecording
    }
    
}
