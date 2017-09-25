//
//  AppDelegate.swift
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 8/26/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.registerForRemoteNotifications(matching: NSApplication.RemoteNotificationType.alert)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // implemented in your application delegate
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Got token data! \(deviceToken)")
        DBZ_ServerCommunication.setupApns(deviceToken);
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        //Recieved Notification
        let apns:NSDictionary = userInfo as NSDictionary
        
        let tokens:NSArray = apns.object(forKey: "token") as! NSArray;
        
        NSLog(tokens.object(at: 0) as! NSString as String);
        
        let incomingToken: AnyObject = tokens.object(at: 0) as AnyObject
        
        if !DBZ_ServerCommunication.enabled() {
            DBZ_ServerCommunication.setTemptoken(String(incomingToken as! NSString))
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "QRActivate"), object: nil)
        }
    }

}

