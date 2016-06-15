//
//  RecordTableViewCell.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 15.06.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import WatchKit

class RecordTableViewCell: NSObject {
    
    var recordCallback: (() -> ())?
    
    var refreshCallback: (() -> ())?
    
    
    @IBAction func record() {
        recordCallback?()
    }
    
    @IBAction func refresh() {
        refreshCallback?()
    }
    
}
