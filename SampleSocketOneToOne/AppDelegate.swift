//
//  AppDelegate.swift
//  SampleSocketOneToOne
//
//  Created by apple on 06/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import SocketIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceID  = UIDevice.current.identifierForVendor!.uuidString
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       // SocketIOMangerForOneToOneChat.sharedInstance.closeConnection()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    //  SocketIOMangerForOneToOneChat.sharedInstance.establishConnection()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
}

