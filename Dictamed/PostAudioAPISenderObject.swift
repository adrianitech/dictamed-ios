//
//  PostAudioAPISenderObject.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import Alamofire

class PostAudioAPISenderObject: BaseAPISenderObject<TranscriptAPIModel> {
    
    var id: String!
    
    init(id: String, file: NSURL) {
        super.init()
        
        self.id = id
        self.file = file
    }
    
    override var path: String {
        return super.path + "/api/transcripts/upload/" + id
    }
    
    override var headers: [String : String] {
        return [
            "type": "audio/wav"
        ]
    }
    
    override var method: Alamofire.Method {
        return .POST
    }
    
}
