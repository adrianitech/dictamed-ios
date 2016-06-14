//
//  DeleteTranscriptsAPISenderObject.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import Alamofire

class DeleteTranscriptsAPISenderObject: BaseAPISenderObject<Bool> {
    
    var id: String!
    
    init(id: String) {
        self.id = id
    }
    
    override var path: String {
        return super.path + "/api/transcripts/" + id
    }
    
    override var method: Alamofire.Method {
        return .DELETE
    }
    
}
