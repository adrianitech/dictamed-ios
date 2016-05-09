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

class DocumentItemTableViewCell: MCSwipeTableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var deviceImageView: UIImageView!
    
    func setDeviceWatch() {
        self.deviceImageView.image = UIImage(named: "ic_watch")
    }
    
    func setDevicePhone() {
        self.deviceImageView.image = UIImage(named: "ic_phone")
    }
    
}

class ValidatedTableViewController: UITableViewController {

    var validated = true
    
    var items: [TranscriptModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
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
        DictamedAPI.sharedInstance.getAllPosts { (items) in
            self.items = items
                .sort { $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970 }
                .filter { $0.validated == self.validated }
            self.tableView.dg_stopLoading()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DocumentItemTableViewCell

        let item = self.items[indexPath.row]
        cell.dateLabel.text = item.createdAt.formatDate()
        cell.contentLabel.text = item.translation
        
        if item.title == "Sent from iPhone" { cell.setDevicePhone() }
        else { cell.setDeviceWatch() }
        
        let printView = UIView()
        printView.backgroundColor = UIColor(red:0.11,green:0.47,blue:1.00,alpha:1.00)
        
        let deleteView = UIView()
        deleteView.backgroundColor = UIColor(red:0.90,green:0.27,blue:0.33,alpha:1.00)
        
        cell.setSwipeGestureWithView(printView, color: printView.backgroundColor!, mode: MCSwipeTableViewCellMode.Switch, state: MCSwipeTableViewCellState.State1) { (_, _, _) in
            //
        }
        
        cell.setSwipeGestureWithView(deleteView, color: deleteView.backgroundColor!, mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3) { (_, _, _) in
            DictamedAPI.sharedInstance.deletePost(item.id, callback: { 
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
