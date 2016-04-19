//
//  MeteorAPI.swift
//  H2Blue
//
//  Created by Adrian Mateoaea on 21.02.2016.
//  Copyright © 2016 WonderKiln. All rights reserved.
//

import SwiftDDP
import CoreData

protocol MeteorAPIError {
    
    func meteorAPIError(error: DDPError)
    
}

protocol MeteorAPIDelegate: MeteorAPIError {
    
}

protocol MeteorAPILoginDelegate: MeteorAPIDelegate {
    
    func meteorLoginWasSuccessful()
    
}

class MeteorAPI: NSObject {
    
    // dictamed-web.heorkuapp.com
    let baseSocket = "ws://localhost:3000/websocket"
    
    static let sharedInstance = MeteorAPI()
    
    let subscriptions = Subscriptions()
    
    struct Subscriptions: MeteorCoreDataCollectionDelegate {
        let posts = MeteorCoreDataCollection(collectionName: "posts", entityName: "Post")
        
        init() {
            posts.delegate = self
        }
        
        // MARK: - MeteorCoreDataCollectionDelegate
        
        func document(willBeCreatedWith fields: NSDictionary?, forObject object: NSManagedObject) -> NSManagedObject {
            if let data = fields {
                for (key, value) in data {
                    if key.isEqual("_id") { continue }
                    
                    if key.isEqual("createdAt") || key.isEqual("updatedAt") {
                        let interval = NSTimeInterval(value["$date"] as! Int) / 1000
                        object.setValue(NSDate(timeIntervalSince1970: interval), forKey: key as! String)
                    } else {
                        object.setValue(value, forKey: key as! String)
                    }
                }
            }
            
            return object
        }
        
        func document(willBeUpdatedWith fields: NSDictionary?, cleared: [String]?, forObject object: NSManagedObject) -> NSManagedObject {
            if let _ = fields {
                for (key, value) in fields! {
                    if key.isEqual("createdAt") || key.isEqual("updatedAt") {
                        let interval = NSTimeInterval(value["$date"] as! Int) / 1000
                        object.setValue(NSDate(timeIntervalSince1970: interval), forKey: key as! String)
                    } else {
                        object.setValue(value, forKey: key as! String)
                    }
                }
            }
            
            if let _ = cleared {
                for field in cleared! {
                    object.setNilValueForKey(field)
                }
            }
            
            return object
        }
    }
    
    override init() {
        super.init()
        Meteor.connect(baseSocket) { () -> () in
            self.subscribe()
        }
    }
    
    func subscribe() {
        Meteor.subscribe("validPosts")
    }
    
}
