//
//  AppDelegate.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 24.04.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        return true
    }

}

extension AppDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        DictamedAPI.sharedInstance.transcribeAudio(file.fileURL, language: AudioLanguage.Romana) { (text) in
            DictamedAPI.sharedInstance.submitAudio(file.fileURL, translation: text, device: DictamedDeviceType.Watch)
        }
    }
    
}
