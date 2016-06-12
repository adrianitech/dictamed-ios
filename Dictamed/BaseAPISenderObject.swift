//
//  BaseAPISenderObject.swift
//  CMP10C
//
//  Created by Adrian Mateoaea on 29.05.2016.
//  Copyright © 2016 CMP10C. All rights reserved.
//

import Foundation
import Alamofire

class BaseAPISenderObject<T>: APISenderObjectProtocol {
    
    var path: String {
    #if DEBUG
        return "http://localhost:3000"
    #else
        return "http://dictamed-web-develop.herokuapp.com"
    #endif
    }
    
    var method: Alamofire.Method {
        return .GET
    }
    
    var body: [String : AnyObject] {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var file: NSURL?
    
    var result: T?
    
    func handleResult(result: AnyObject) { }
    
    func fetchFromRealm() -> Bool { return false }
    
}
