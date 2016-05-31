//
//  TranscribeAudioAPISenderObject.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 31.05.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranscribeAudioAPISenderObject: BaseAPISenderObject<String> {
    
    private let speechAPIKey = "AIzaSyA3QauQzWiq8sNp-13WZVkv5MLHoehjkrM"
    
    private let speechAPIURL = "https://www.google.com/speech-api/v2/recognize?output=json&lang=ro-ro&key=%@"
    
    init(file: NSURL) {
        super.init()
        self.file = file
    }
    
    override var path: String {
        return String(format: speechAPIURL, speechAPIKey)
    }
    
    override var method: Alamofire.Method {
        return .POST
    }
    
    override var headers: [String : String] {
        return [
            "Content-Type": "audio/l16; rate=16000;"
        ]
    }
    
    override func handleResult(result: AnyObject) {
        guard var text = result as? String else { return }
        if let index = text.characters.indexOf("\n") {
            text = text.substringFromIndex(index)
        }
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            let json = JSON(data: data)
            self.result = json["result", 0, "alternative", 0, "transcript"].string
            if self.result == nil { self.result = "..." }
        }
    }
    
}
