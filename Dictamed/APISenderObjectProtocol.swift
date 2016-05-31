//
//  APISenderObjectProtocol.swift
//  CMP10C
//
//  Created by Adrian Mateoaea on 29.05.2016.
//  Copyright © 2016 CMP10C. All rights reserved.
//

import Foundation
import Alamofire

protocol APISenderObjectProtocol {
    
    var path: String { get }
    
    var method: Alamofire.Method { get }
    
    var body: [String : AnyObject] { get }
    
    var headers: [String : String] { get }

    var file: NSURL? { get set }
    
    func handleResult(result: AnyObject)
    
    func fetchFromRealm() -> Bool
    
}
