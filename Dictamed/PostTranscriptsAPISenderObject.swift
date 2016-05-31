//
//  PostTranscriptsAPISenderObject.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import Alamofire

class PostTranscriptsAPISenderObject: BaseAPISenderObject<TranscriptAPIModel> {
    
    var transcript: TranscriptAPIModel!
    
    init(transcript: TranscriptAPIModel) {
        self.transcript = transcript
    }
    
    override var path: String {
        return super.path + "/api/transcripts"
    }
    
    override var method: Alamofire.Method {
        return .POST
    }
    
    override var body: [String : AnyObject] {
        return transcript.dictionary
    }
    
    override func handleResult(result: AnyObject) {
        self.result = TranscriptAPIModel(result: result)
    }
    
}
