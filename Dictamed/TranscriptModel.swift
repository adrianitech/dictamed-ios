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
    
    init(dict: NSDictionary) {
        self.id = dict.valueForKey("_id") as! String
        self.title = dict.valueForKey("title") as! String
        self.translation = dict.valueForKey("translation") as! String
        self.validated = dict.valueForKey("validated") as? Bool ?? false
    }
    
}
