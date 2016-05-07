//
//  RecordViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 29.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import SVProgressHUD

class DocumentHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

class DocumentFooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var pageView: UIView!
    
    override func awakeFromNib() {
        self.pageView.layer.borderWidth = 1
        self.pageView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).CGColor
    }
    
}

class DocumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    
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
    
    @IBOutlet weak var levelView: UIView!
    
    @IBOutlet var disabledConstraints: [NSLayoutConstraint]!
    
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
                self.timeLabel.text = "Press record to start"
            }
            
            self.disabledConstraints
                .forEach { $0.active = self.isRecording }
            
            UIView.animateWithDuration(0.5) { 
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        refresh = UIRefreshControl()
        refresh.tintColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        refresh.addTarget(self, action: #selector(RecordViewController.refreshItems), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.insertSubview(refresh, atIndex: 0)
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
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
        
        if indexPath.section == 0 { cell.iconView.image = UIImage(named: "ic_check") }
        else { cell.iconView.image = UIImage(named: "ic_pending") }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! DocumentHeaderCollectionReusableView
            
            if indexPath.section == 0 { header.titleLabel.text = "VALIDATED" }
            else { header.titleLabel.text = "PENDING" }
            
            return header
        }
        else if kind == UICollectionElementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath)
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 4) / 2, height: 1.3 * collectionView.frame.width / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 35)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 && self.validItems.count != 0 || section == 1 && self.pendingItems.count != 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        var item: TranscriptModel
        
        if indexPath.section == 0 { item = self.validItems[indexPath.row] }
        else { item = self.pendingItems[indexPath.row] }
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let option1 = UIAlertAction(title: "Print", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let option2 = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            DictamedAPI.sharedInstance.deletePost(item.id, callback: {
                self.collectionView.performBatchUpdates({ 
                    let index1 = self.validItems.indexOf { $0.id == item.id }
                    let index2 = self.pendingItems.indexOf { $0.id == item.id }
                    
                    if let index1 = index1 { self.validItems.removeAtIndex(index1) }
                    if let index2 = index2 { self.pendingItems.removeAtIndex(index2) }
                    
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                }, completion: nil)
            })
        })
        let option3 = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(option1)
        optionMenu.addAction(option2)
        optionMenu.addAction(option3)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

}

extension RecordViewController: AudioRecorderDelegate {
    
    func didStartRecording(recorder: AudioRecorder) {
        self.isRecording = true
    }
    
    func didStopRecording(recorder: AudioRecorder) {
        self.isRecording = false
        
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
                        self.refreshItems()
                    }
                }
            }
        }
    }
    
    func didReceiveAudioLevel(recorder: AudioRecorder, level: CGFloat) {
        UIView.animateWithDuration(0.1) {
            self.levelView.transform = CGAffineTransformMakeScale(level, 1)
        }
    }
    
    func didUpdateTime(recorder: AudioRecorder, time: Double) {
        let date = NSDate(timeIntervalSince1970: time)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        self.timeLabel.text = "You have " + dateFormatter.stringFromDate(date) + " left of this recording"
    }
    
}
