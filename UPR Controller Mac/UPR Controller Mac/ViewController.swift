//
//  ViewController.swift
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 8/26/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSTextFieldDelegate  {
                            
    @IBOutlet weak var tabController: NSTabView!
    @IBOutlet weak var token1: NSTextField!
    @IBOutlet weak var token2: NSTextField!
    @IBOutlet weak var token3: NSTextField!
    @IBOutlet weak var token4: NSTextField!
    @IBOutlet weak var token5: NSTextField!
    @IBOutlet weak var token6: NSTextField!
    @IBOutlet weak var connectButton: NSButton!
    
    
    @IBOutlet weak var QRView: WKWebView!
    
    var tokenFields: [String] = ["","","","","",""]
    var tokenFieldObjects: [NSTextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "serverResponse:", name:"ServerResponse", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alert:", name:"Alert", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateInterface:", name:"UpdateInterface", object: nil)
        
        tokenFieldObjects = [token1, token2, token3, token4, token5, token6]
        
        DBZ_ServerCommunication.setupUid()
        
        token1.becomeFirstResponder()
        

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
        
        
    }
    
    @IBAction func connectButton(sender: AnyObject) {
        if DBZ_ServerCommunication.enabled() {
            DBZ_ServerCommunication.setEnabled(false)
            reset()
        } else {
            var presentToken = token1.stringValue+token2.stringValue+token3.stringValue+token4.stringValue+token5.stringValue+token6.stringValue
            let pt = presentToken.toInt()
            DBZ_ServerCommunication.joinSession(pt!)
            connectButton.title = "Connecting..."
            connectButton.enabled = false
        }
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        
        for (index, value) in enumerate(tokenFieldObjects) {
            if value.stringValue != tokenFields[index] {
                if index < 5 {
                    tokenFieldObjects[index + 1].becomeFirstResponder()
                } else {
                    token1.becomeFirstResponder()
                }
                
            }
            
            tokenFields[index] = value.stringValue
        }
        
        validateToken()
        
    }
    
    func validateToken() {
        var fieldsReady = 0;
        for (index, value) in enumerate(tokenFieldObjects) {
            if (String(value.integerValue) == value.stringValue) {
                fieldsReady++
            }
        }
        if fieldsReady == 6 {
            connectButton.enabled = true
        }
    }
    
    func serverResponse(notification: NSNotification) {
        var incoming: NSMutableArray! = notification.object as NSMutableArray
        DBZ_ServerCommunication.processResponse(incoming)
    }
    
    func alert(notification: NSNotification) {
        var incoming: NSMutableArray! = notification.object as NSMutableArray
        let alert:NSAlert = NSAlert()
        alert.messageText = incoming.objectAtIndex(0) as NSString
        alert.informativeText = incoming.objectAtIndex(1) as NSString
        alert.runModal()
        DBZ_ServerCommunication.updateInterface()
        reset()
        
    }
    
    func updateInterface(notification: NSNotification) {
        if DBZ_ServerCommunication.enabled() {
            connectButton.title = "Disconnect"
            token1.enabled = false
            token2.enabled = false
            token3.enabled = false
            token4.enabled = false
            token5.enabled = false
            token6.enabled = false
        } else {
            connectButton.title = "Connect"
            token1.enabled = true
            token2.enabled = true
            token3.enabled = true
            token4.enabled = true
            token5.enabled = true
            token6.enabled = true
            
        }
        connectButton.enabled = true
    }
    
    func reset() {
        token1.stringValue = ""
        token2.stringValue = ""
        token3.stringValue = ""
        token4.stringValue = ""
        token5.stringValue = ""
        token6.stringValue = ""
        tokenFields = ["","","","","",""]
        token1.becomeFirstResponder()
    }

}

