//
//  AppDelegate.swift
//  DictaMed
//
//  Created by Adrian Mateoaea on 10.10.2015.
//  Copyright © 2015 Adrian Mateoaea. All rights reserved.
//

import UIKit
import CoreData
import SwiftDDP
import WKAwesomeMenu

class a: MeteorCoreDataTableViewController {
    
    var collection = MeteorAPI.sharedInstance.subscriptions.posts
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Post")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.collection.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .None
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        try! fetchedResultsController.performFetch()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.layer.borderWidth = 1
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Post
        label.text = item.createdAt!.dateStringWithFormat("MMMM dd, YYY") + "\n" + item.title! + "\n\n" + item.translation!
        
        
        cell.addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(cell).inset(UIEdgeInsets(top: 10, left: 11, bottom: 0, right: 10))
        }
        
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).inset(8)
            make.leading.equalTo(view).inset(8)
            make.trailing.equalTo(view).inset(8)
            make.bottom.lessThanOrEqualTo(view).inset(8)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
}

extension NSDate {
    
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let _ = MeteorAPI.sharedInstance
    
    var options = WKAwesomeMenuOptions.defaultOptions()
    options.shadowOffset = CGPoint(x: -1, y: 0)
    options.shadowColor = UIColor.lightGrayColor()
    options.menuParallax = 0
    options.cornerRadius = 0
    options.shadowScale = 1
    options.rootScale = 1
    options.menuWidth = 150
    
    let vc = WKAwesomeMenu(
        rootViewController: MainViewController(),
        menuViewController: a(),
        options: options)
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = vc
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}
