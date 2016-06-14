//
//  APICommunicationLayer.swift
//  CMP10C
//
//  Created by Adrian Mateoaea on 29.05.2016.
//  Copyright © 2016 CMP10C. All rights reserved.
//

import Foundation
import Alamofire

class APICommunicationLayer: NSObject {
    
    typealias APIResultCallback = (APISenderObjectProtocol, APICommunicationLayerError?) -> ()

    typealias APIProgressCallback = (APISenderObjectProtocol, Double) -> ()
    
    static func request(sender: APISenderObjectProtocol, callback: APIResultCallback) {
        
        if sender.fetchFromRealm() {
            callback(sender, nil)
        }
        
        Alamofire.request(sender.method, sender.path, parameters: sender.body, headers: sender.headers)
            .responseJSON { (res) in
                switch res.result {
                case .Failure(let error):
                    print(error)
                    let err = APICommunicationLayerError(code: 100, message: error.localizedDescription)
                    callback(sender, err)
                case .Success(let value):
//                    print(value)
                    sender.handleResult(value)
                    callback(sender, nil)
                }
        }
    }

    static func upload(sender: APISenderObjectProtocol, progress: APIProgressCallback, callback: APIResultCallback) {
        guard let file = sender.file else { return }
        Alamofire.upload(sender.method, sender.path, headers: sender.headers, file: file)
            .progress({ (_, i, n) in progress(sender, Double(i) / Double(n)) })
            .responseJSON { (res) in
                switch res.result {
                case .Failure(let error):
                    print(error)
                    let err = APICommunicationLayerError(code: 100, message: error.localizedDescription)
                    callback(sender, err)
                case .Success(let value):
                    print(value)
                    sender.handleResult(value)
                    callback(sender, nil)
                }
        }
    }
    
    static func uploadAndParseAsString(sender: APISenderObjectProtocol, progress: APIProgressCallback, callback: APIResultCallback) {
        guard let file = sender.file else { return }
        Alamofire.upload(sender.method, sender.path, headers: sender.headers, file: file)
            .progress({ (_, i, n) in progress(sender, Double(i) / Double(n)) })
            .responseString { (res) in
                switch res.result {
                case .Failure(let error):
                    print(error)
                    let err = APICommunicationLayerError(code: 100, message: error.localizedDescription)
                    callback(sender, err)
                case .Success(let value):
                    print(value)
                    sender.handleResult(value)
                    callback(sender, nil)
                }
        }
    }
    
}
