//
//  DocumentItemTableViewCell.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
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
