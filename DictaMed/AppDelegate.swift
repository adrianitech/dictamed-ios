//
//  AppDelegate.swift
//  DictaMed
//
//  Created by Adrian Mateoaea on 10.10.2015.
//  Copyright © 2015 Adrian Mateoaea. All rights reserved.
//

import UIKit
import SwiftDDP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = MainViewController()
    self.window?.makeKeyAndVisible()
    
    // dictamed-web.heorkuapp.com
    Meteor.connect("ws://localhost:3000/websocket")
    
    return true
  }
  
}
