//
//  LoginController.swift
//  UPR Remote
//
//  Created by Brendan Boyle on 10/29/16.
//
//

import Cocoa

class LoginController: NSViewController {

    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var tokenLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInterface), name: NSNotification.Name(rawValue: "UpdateInterface"), object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func refreshToken(_ sender: Any) {
        tokenLabel.stringValue = "..."
        DBZ_ServerCommunication.setupUid()
        DBZ_ServerCommunication.checkToken()
    }
    
    @IBAction func downloadController(_ sender: Any) {
        NSWorkspace.shared().open(URL(string: "https://universalpresenterremote.com")!)
    }

    @IBAction func connectButton(_ sender: Any) {
        performSegue(withIdentifier: "ControlSegue", sender: self)
    }
    
    func updateInterface(notification:NSNotification) {
        let token = DBZ_ServerCommunication.temptoken()
        switch DBZ_ServerCommunication.controlmode() {
        case 1:
            connectButton.title = "Waiting..."
            connectButton.isEnabled = false
    
            tokenLabel.stringValue = String(token)
            break
        case 2:
            connectButton.title = "Connect"
            connectButton.isEnabled = true
            break
        default:
            tokenLabel.stringValue = "..."
            connectButton.title = "Connecting..."
            connectButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        DBZ_ServerCommunication.joinSession();
    }
}

