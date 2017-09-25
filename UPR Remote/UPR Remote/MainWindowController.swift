//
//  MainWindowController.swift
//  UPR
//
//  Created by Brendan Boyle on 11/7/16.
//
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var connectTB: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface), name: NSNotification.Name(rawValue: "UpdateInterface"), object: nil)
    }
    
    func updateInterface(notification:NSNotification) {
        switch DBZ_ServerCommunication.controlmode() {
        case 1:
            connectTB.title = "Waiting..."
            connectTB.isEnabled = false
            break
        case 2:
            connectTB.title = "Connect"
            connectTB.isEnabled = true
            break
        default:
            connectTB.title = "Connecting..."
            connectTB.isEnabled = false
        }
    }
    
    @IBAction func refreshTokenTB(_ sender: Any) {
        DBZ_ServerCommunication.setupUid()
        DBZ_ServerCommunication.checkToken()
    }

    @IBAction func connectTB(_ sender: Any) {
        let controller:LoginController = window?.contentViewController as! LoginController
        controller.connectButton(sender)
    }
}
