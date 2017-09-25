//
//  ControlController.swift
//  UPR
//
//  Created by Brendan Boyle on 11/7/16.
//
//

import Cocoa

class ControlController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func mediaButton(_ sender: Any) {
        DBZ_ServerCommunication.getResponse("PlayMedia", withToken: DBZ_ServerCommunication.token(), withHoldfor: true, withDeviceToken: false)
    }
    
    @IBAction func previousButton(_ sender: Any) {
        DBZ_ServerCommunication.getResponse("SlideDown", withToken: DBZ_ServerCommunication.token(), withHoldfor: true, withDeviceToken: false)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        DBZ_ServerCommunication.getResponse("SlideUp", withToken: DBZ_ServerCommunication.token(), withHoldfor: true, withDeviceToken: false)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(nil);
        
    }
    
    @IBAction func nextTB(_ sender: Any) {
        nextButton(sender)
    }
    
    @IBAction func previousTB(_ sender: Any) {
        previousButton(sender)
    }
    
    @IBAction func mediaTB(_ sender: Any) {
        mediaButton(sender)
    }
}
