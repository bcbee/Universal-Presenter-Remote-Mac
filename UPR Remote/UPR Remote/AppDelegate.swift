//
//  AppDelegate.swift
//  UPR Remote
//
//  Created by Brendan Boyle on 10/29/16.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var storyboard:NSStoryboard?
    var controller:NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        if storyboard != nil {
            controller = storyboard?.instantiateInitialController() as? NSWindowController
        }
        
        NSApplication.shared().registerForRemoteNotifications(matching: [.alert, .sound, .badge])
        
        NotificationCenter.default.addObserver(self, selector: #selector(serverResponse), name: NSNotification.Name(rawValue: "ServerResponse"), object: nil)
        
        DBZ_ServerCommunication.setupUid()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Acquired APNS token: \(token)")
        DBZ_ServerCommunication.setupApns(token)
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS error: \(error)")
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        DBZ_ServerCommunication.checkToken()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            DBZ_ServerCommunication.setupUid()
            DBZ_ServerCommunication.checkToken()
            controller?.window?.makeKeyAndOrderFront(sender)
        }
        return true
    }
    
    func serverResponse(notification:NSNotification) {
        DBZ_ServerCommunication.processResponse(notification.object as! NSMutableArray)
    }
    
    
    @IBAction func refreshToken(_ sender: Any) {
        DBZ_ServerCommunication.setupUid()
        DBZ_ServerCommunication.checkToken()
    }


}

