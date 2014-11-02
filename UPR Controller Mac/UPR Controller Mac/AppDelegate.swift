//
//  AppDelegate.swift
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 8/26/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        NSApplication.sharedApplication().registerForRemoteNotificationTypes(.Alert)
        
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    // implemented in your application delegate
    func application(application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        println("Got token data! \(deviceToken)")
        DBZ_ServerCommunication.setupApns(deviceToken);
    }
    
    func application(application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        println("Couldn't register: \(error)")
    }
    
    func application(application: NSApplication, didReceiveRemoteNotification userInfo:NSDictionary!) {
        //Recieved Notification
        var apns:NSDictionary = userInfo as NSDictionary
        
        var tokens:NSArray = apns.objectForKey("token") as NSArray;
        
        NSLog(tokens.objectAtIndex(0) as NSString);
        
    }

}

