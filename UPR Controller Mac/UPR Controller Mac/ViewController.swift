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
    
    @IBOutlet var tabView: NSTabView!
    
    @IBOutlet weak var QRView: WKWebView!
    
    var tokenFields: [String] = ["","","","","",""]
    var tokenFieldObjects: [NSTextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.serverResponse(_:)), name:NSNotification.Name(rawValue: "ServerResponse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.alert(_:)), name:NSNotification.Name(rawValue: "Alert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateInterface(_:)), name:NSNotification.Name(rawValue: "UpdateInterface"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.qrActivate(_:)), name:NSNotification.Name(rawValue: "QRActivate"), object: nil)
        
        tokenFieldObjects = [token1, token2, token3, token4, token5, token6]
        
        DBZ_ServerCommunication.setupUid()
        
        token1.becomeFirstResponder()
        
    }
    
    @IBAction func connectButtonClicked(_ sender: AnyObject) {
        if DBZ_ServerCommunication.enabled() {
            DBZ_ServerCommunication.setEnabled(false)
            reset()
        } else {
            let presentToken = token1.stringValue+token2.stringValue+token3.stringValue+token4.stringValue+token5.stringValue+token6.stringValue
            let pt = Int(presentToken)
            DBZ_ServerCommunication.joinSession(pt!)
            connectButton.title = "Connecting..."
            connectButton.isEnabled = false
        }
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        
        for (index, value) in tokenFieldObjects.enumerated() {
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
        
        for (index, value) in tokenFieldObjects.enumerated() {
            if (String(value.integerValue) == value.stringValue) {
                fieldsReady += 1
            }
        }
        
        if fieldsReady == 6 {
            connectButton.isEnabled = true
        }
    }
    
    @objc func serverResponse(_ notification: Notification) {
        let incoming: NSMutableArray! = notification.object as! NSMutableArray
        DBZ_ServerCommunication.processResponse(incoming)
    }
    
    @objc func alert(_ notification: Notification) {
        let incoming: NSMutableArray! = notification.object as! NSMutableArray
        let alert:NSAlert = NSAlert()
        alert.messageText = incoming.object(at: 0) as! NSString as String
        alert.informativeText = incoming.object(at: 1) as! NSString as String
        alert.runModal()
        DBZ_ServerCommunication.updateInterface()
        reset()
        
    }
    
    @objc func updateInterface(_ notification: Notification) {
        if DBZ_ServerCommunication.enabled() {
            connectButton.title = "Disconnect"
            token1.isEnabled = false
            token2.isEnabled = false
            token3.isEnabled = false
            token4.isEnabled = false
            token5.isEnabled = false
            token6.isEnabled = false
        } else {
            connectButton.title = "Connect"
            token1.isEnabled = true
            token2.isEnabled = true
            token3.isEnabled = true
            token4.isEnabled = true
            token5.isEnabled = true
            token6.isEnabled = true
            
        }
        connectButton.isEnabled = true
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
    
    @objc func qrActivate(_ notification: Notification) {
        
        let token = Array(arrayLiteral: String(DBZ_ServerCommunication.temptoken()))
        
        tabView.selectFirstTabViewItem(nil)
        
        token1.stringValue = String(token[0])
        token2.stringValue = String(token[1])
        token3.stringValue = String(token[2])
        token4.stringValue = String(token[3])
        token5.stringValue = String(token[4])
        token6.stringValue = String(token[5])
        //tokenFields = [String(token[0]),String(token[1]),String(token[2]),String(token[3]),String(token[4]),String(token[5])]
        validateToken()
        connectButtonClicked(NSObject.self);
        connectButton.title = "Joining session..."
    }

}

