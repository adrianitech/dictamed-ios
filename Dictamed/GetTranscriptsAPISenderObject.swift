//
//  GetTranscriptsAPISenderObject.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import Alamofire

class GetTranscriptsAPISenderObject: BaseAPISenderObject<Array<TranscriptAPIModel>> {
    
    override var path: String {
        return super.path + "/api/transcripts"
    }
    
    override var method: Alamofire.Method {
        return .GET
    }
    
    override func handleResult(result: AnyObject) {
        self.result = (result as? Array)?.map({ (e: AnyObject) -> TranscriptAPIModel in
            let model = TranscriptAPIModel(result: e)
            if let audio = model.audio {
                model.audio = super.path + audio
            }
            return model
        })

        let oldResults: [TranscriptAPIModel] = TranscriptAPIModel.getAll()
        let deletedResults = oldResults.filter { (e) -> Bool in
            return !self.result!.contains { $0.id == e.id }
        }
        
        self.result!.addAll(update: true)
        deletedResults.delete()
    }
    
    override func fetchFromRealm() -> Bool {
        self.result = TranscriptAPIModel.getAll()
        return true
    }
    
}
