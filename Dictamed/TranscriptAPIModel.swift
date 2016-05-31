//
//  TranscriptAPIModel.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation

class TranscriptAPIModel {
    
    var id: String = ""
    
    var title: String = ""
    
    var translation: String = ""
    
    var validated: Bool = false
    
    var createdAt: NSDate = NSDate()
    
    var audio: String?
    
    convenience init(title: String, translation: String) {
        self.init()
        
        self.title       = title
        self.translation = translation
    }
    
    convenience init(result: AnyObject) {
        self.init()
        
        id          = result.valueForKey("_id") as! String
        title       = result.valueForKey("title") as! String
        translation = result.valueForKey("translation") as! String
        validated   = result.valueForKey("validated") as? Bool ?? false
        audio       = result.valueForKey("audio") as? String
        
        if let date = (result.valueForKey("createdAt") as! String).toDate() {
            createdAt = date
        }
    }
    
    var dictionary: [String: AnyObject] {
        return [
            "title"       : title,
            "translation" : translation
        ]
    }
    
}
