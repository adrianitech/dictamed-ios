//
//  TranscriptModel.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 26.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation

extension String {
    
    func toDate() -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        return formatter.dateFromString(self)
    }
    
}

extension NSDate {
    
    func formatDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d MMM YYYY, HH:mm"
        return formatter.stringFromDate(self)
    }
    
}

class TranscriptModel {
    
    var id: String!
    
    var title: String!
    
    var translation: String!
    
    var validated: Bool = false
    
    var audio: String?
    
    var createdAt: NSDate!
    
    var audioURL: NSURL? {
        guard let audio = self.audio else { return nil }
        return NSURL(string: DictamedAPI.sharedInstance.websiteAPIURL + audio)
    }
    
    init(dict: NSDictionary) {
        self.id = dict.valueForKey("_id") as! String
        self.title = dict.valueForKey("title") as! String
        self.translation = dict.valueForKey("translation") as! String
        self.validated = dict.valueForKey("validated") as? Bool ?? false
        self.audio = dict.valueForKey("audio") as? String
        
        if let date = (dict.valueForKey("createdAt") as! String).toDate() {
            self.createdAt = date
        }
    }
    
}
