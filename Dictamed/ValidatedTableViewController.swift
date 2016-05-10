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
import IBAnimatable

class CustomTabBarController: UITabBarController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tabBar.translucent = false
        self.tabBar.barTintColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        self.tabBar.tintColor = UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.35)],
            forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)],
            forState: UIControlState.Selected)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let index = tabBar.items?.indexOf(item)!
        if index == 2 {
            item.setTitleTextAttributes(
                [NSForegroundColorAttributeName: UIColor.whiteColor()],
                forState: UIControlState.Selected)
            tabBar.translucent = true
            tabBar.barTintColor = UIColor.clearColor()
        } else {
            tabBar.translucent = false
            tabBar.barTintColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            if self.selectedIndex == 2 {
                self.tabBar.items?[self.selectedIndex].setTitleTextAttributes(
                    [NSForegroundColorAttributeName: UIColor.whiteColor()],
                    forState: UIControlState.Selected)
                self.tabBar.translucent = true
                self.tabBar.barTintColor = UIColor.clearColor()
            } else {
                self.tabBar.translucent = false
                self.tabBar.barTintColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            }
        }
    }
    
}

class CustomNavigationController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = UIColor(red:0.48,green:0.75,blue:0.30,alpha:1.00)
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
    }
    
}

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
        DictamedAPI.sharedInstance.getAllPosts { (items) in
            self.items = items
                .sort { $0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970 }
                .filter { $0.validated == self.validated }
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
        cell.dateLabel.text = item.createdAt.formatDate()
        cell.contentLabel.text = item.translation
        
        if item.title == "Sent from iPhone" { cell.setDevicePhone() }
        else { cell.setDeviceWatch() }
        
        let image1 = UIImageView()
        image1.tintColor = UIColor.whiteColor()
        image1.image = UIImage(named: "ic_printer")
        image1.contentMode = .Center
        
        let image2 = UIImageView()
        image2.tintColor = UIColor.whiteColor()
        image2.image = UIImage(named: "ic_garbage")
        image2.contentMode = .Center
        
        cell.setSwipeGestureWithView(image1, color: UIColor(red:0.11,green:0.47,blue:1.00,alpha:1.00), mode: MCSwipeTableViewCellMode.Switch, state: MCSwipeTableViewCellState.State1) { (_, _, _) in
            //
        }
        
        cell.setSwipeGestureWithView(image2, color: UIColor(red:0.98,green:0.00,blue:0.03,alpha:1.00), mode: MCSwipeTableViewCellMode.Exit, state: MCSwipeTableViewCellState.State3) { (_, _, _) in
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
