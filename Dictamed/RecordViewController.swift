//
//  RecordViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 29.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import JGProgressHUD

class DocumentHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

class DocumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        self.pageView.layer.borderWidth = 1
        self.pageView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
    }
    
    override var selected: Bool {
        didSet {
            if self.selected {
                self.backgroundColor = UIColor(red:0.59,green:0.83,blue:0.42,alpha:1.00)
                self.pageView.layer.borderWidth = 0
            } else {
                self.backgroundColor = UIColor.clearColor()
                self.pageView.layer.borderWidth = 1
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if self.highlighted {
                self.backgroundColor = UIColor(red:0.59,green:0.83,blue:0.42,alpha:1.00)
                self.pageView.layer.borderWidth = 0
            } else {
                self.backgroundColor = UIColor.clearColor()
                self.pageView.layer.borderWidth = 1
            }
        }
    }
    
}

class RecordViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var recorder: AudioRecorder!
    
    var refresh: UIRefreshControl!
    
    var validItems: [TranscriptModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var pendingItems: [TranscriptModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var isRecording: Bool = false {
        didSet {
            if self.isRecording {
                self.recordButton.setImage(UIImage(named: "ic_stop"), forState: UIControlState.Normal)
            } else {
                self.recordButton.setImage(UIImage(named: "ic_record"), forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(RecordViewController.refreshItems), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.insertSubview(refresh, atIndex: 0)
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.refreshItems()
        
        self.recorder = AudioRecorder()
        self.recorder.delegate = self
    }
    
    func refreshItems() {
        DictamedAPI.sharedInstance.getAllPosts { (items) in
            self.validItems = items.filter { $0.validated }
            self.pendingItems = items.filter { !$0.validated }
            self.refresh.endRefreshing()
        }
    }
    
    @IBAction func record(sender: AnyObject) {
        if self.recorder.recording {
            self.recorder.stopRecording()
        } else {
            self.recorder.record()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return self.validItems.count }
        return self.pendingItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DocumentCollectionViewCell
        
        var item: TranscriptModel
        
        if indexPath.section == 0 { item = self.validItems[indexPath.row] }
        else { item = self.pendingItems[indexPath.row] }
        
        cell.titleLabel.text = item.title
        cell.contentLabel.text = item.translation
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! DocumentHeaderCollectionReusableView
            
            if indexPath.section == 0 { header.titleLabel.text = "VALIDATED" }
            else { header.titleLabel.text = "PENDING" }
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 4) / 2, height: 1.3 * collectionView.frame.width / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }

}

extension RecordViewController: AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder) {
        self.isRecording = true
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        self.isRecording = false
        
        let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.showInView(self.view, animated: true)
        hud.setProgress(0, animated: true)
        hud.textLabel.text = "Transcribing"
        
        DictamedAPI.sharedInstance.transcribeAudio(recorder.fileURL, language: AudioLanguage.Romana) { (finished, progress, text) in
            if !finished {
                hud.setProgress(progress * 0.5, animated: true)
            } else {
                hud.textLabel.text = "Uploading"
                DictamedAPI.sharedInstance.submitAudio(recorder.fileURL, translation: text, device: DictamedDeviceType.Phone) { (finished2, progress2) in
                    if !finished2 {
                        hud.setProgress(0.5 + progress * 0.5, animated: true)
                    } else {
                        self.refreshItems()
                    }
                }
            }
        }
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
//        self.setTime()
//        UIView.animateWithDuration(0.2) {
//            self.volumeView.transform = CGAffineTransformMakeScale(level, level)
//        }
    }
    
}
