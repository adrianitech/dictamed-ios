//
//  DocumentsTableViewController.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 24.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
}

class DocumentsTableViewController: UITableViewController {

    var validItems: [TranscriptModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var pendingItems: [TranscriptModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        DictamedAPI.sharedInstance.getAllPosts { (items) in
            self.validItems = items.filter { $0.validated }
            self.pendingItems = items.filter { !$0.validated }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.validItems.count == 0 && self.pendingItems.count == 0 {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor(red:0.48,green:0.49,blue:0.51,alpha:1.00)
            label.text = "Start recording\nto see your document here"
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return self.validItems.count }
        return self.pendingItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DocumentsTableViewCell
        
        var item: TranscriptModel
        
        if indexPath.section == 0 { item = self.validItems[indexPath.row] }
        else { item = self.pendingItems[indexPath.row] }
        
        cell.titleLabel.text = item.title
        cell.contentLabel.text = item.translation
        cell.contentLabel.preferredMaxLayoutWidth = tableView.frame.width

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && self.validItems.count > 0 { return "Validated" }
        if section == 1 && self.pendingItems.count > 0 { return "Pending" }
        return ""
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var item: TranscriptModel
            
            if indexPath.section == 0 { item = self.validItems[indexPath.row] }
            else { item = self.pendingItems[indexPath.row] }
            
            DictamedAPI.sharedInstance.deletePost(item.id, callback: {
                let index1 = self.validItems.indexOf { $0.id == item.id }
                let index2 = self.pendingItems.indexOf { $0.id == item.id }
                
                tableView.beginUpdates()
                
                if let index1 = index1 {
                    self.validItems.removeAtIndex(index1)
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index1, inSection: 0)],
                        withRowAnimation: UITableViewRowAnimation.None)
                }
                if let index2 = index2 {
                    self.pendingItems.removeAtIndex(index2)
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index2, inSection: 1)],
                        withRowAnimation: UITableViewRowAnimation.None)
                }
                
                tableView.endUpdates()
            })
        }
    }

}
