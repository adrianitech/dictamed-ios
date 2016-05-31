//
//  NSDate+Format.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation

extension NSDate {
    
    func formatDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d MMM YYYY, HH:mm"
        return formatter.stringFromDate(self)
    }
    
}
