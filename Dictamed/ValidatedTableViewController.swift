//
//  ValidatedTableViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 08.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import MCSwipeTableViewCell
import AVKit
import AVFoundation

class ValidatedTableViewController: UITableViewController {

    var validated = true
    
    var items: [TranscriptAPIModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "DocumentTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "cell")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        
        self.tableView.dg_setPullToRefreshFillColor(UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00))
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
        self.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.refreshItems()
        }, loadingView: loadingView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshItems()
    }
    
    func refreshItems() {
        API.sharedInstance.getTranscripts { (obj, _) in
            if let items = obj.result {
                self.items = items
                    .sort { $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970 }
                    .filter { $0.validated == self.validated }
            }
            self.tableView.dg_stopLoading()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            let imageView = UIImageView()
            imageView.contentMode = .Center
            imageView.image = UIImage(named: "ic_placeholder")
            tableView.backgroundView = imageView
        } else {
            tableView.backgroundView = nil
        }
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DocumentItemTableViewCell

        let item = self.items[indexPath.row]
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.createdAt.formatDate()
        cell.contentLabel.text = item.translation
        
        if item.title == "Sent from iPhone" { cell.setDevicePhone() }
        else { cell.setDeviceWatch() }
        
        let image0 = UIImageView()
        image0.tintColor = UIColor.whiteColor()
        image0.image = UIImage(named: "ic_play")
        image0.contentMode = .Center
        
        let image1 = UIImageView()
        image1.tintColor = UIColor.whiteColor()
        image1.image = UIImage(named: "ic_printer")
        image1.contentMode = .Center
        
        let image2 = UIImageView()
        image2.tintColor = UIColor.whiteColor()
        image2.image = UIImage(named: "ic_garbage")
        image2.contentMode = .Center
        
        cell.setSwipeGestureWithView(image0, color: UIColor(red:0.13, green:0.82, blue:0.38, alpha:1.00), mode: MCSwipeTableViewCellMode.Switch, state: MCSwipeTableViewCellState.State1) { (_, _, _) in
            guard let audio = item.audio else { return }
            
            let URL = NSURL(string: audio)!
            let player = AVPlayer(URL: URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.presentViewController(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        
        cell.setSwipeGestureWithView(image1, color: UIColor(red:0.11, green:0.47, blue:1.00, alpha:1.00), mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State2) { (_, _, _) in
            
            guard let path = NSBundle.mainBundle().pathForResource("Template", ofType: "html", inDirectory: "html") else { return }
            
            let content = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let text = String(format: content, item.title, item.createdAt.formatDate(), item.translation)
            
            let formatter = UIMarkupTextPrintFormatter(markupText: text)
            formatter.contentInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
            
            let printController = UIPrintInteractionController.sharedPrintController()
            printController.printFormatter = formatter
            printController.presentAnimated(true, completionHandler: nil)
            
            cell.swipeToOriginWithCompletion({ 
                //
            })
        }
        
        cell.setSwipeGestureWithView(image2, color: UIColor(red:0.98, green:0.00, blue:0.03, alpha:1.00), mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3) { (_, _, _) in
            API.sharedInstance.deleteTranscript(item.id, callback: { (_, _) in
                self.tableView.beginUpdates()
                self.items.removeAtIndex((self.items.indexOf { $0.id == item.id })!)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
            })
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
