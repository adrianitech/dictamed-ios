//
//  TranscriptModel.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 26.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation

class TranscriptModel {
    
    var id: String!
    
    var title: String!
    
    var translation: String!
    
    var validated: Bool = false
    
    var audio: String?
    
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
    }
    
}
