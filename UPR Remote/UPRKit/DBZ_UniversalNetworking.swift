//
//  DBZ_UniversalNetworking.swift
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/25/16.
//  Copyright © 2016 DBZ Technology. All rights reserved.
//

@objc public class DBZ_UniversalNetworking: NSObject {
    static func makeRequest(_ url:String, page:String, callback: @escaping (NSMutableArray) -> Void) -> Void {
        httpGet(url, callback: callback, page: page)
    }
    
    static func httpCallback(_ result: String, error: String?, page:String, response:URLResponse) -> Void {
        print("Response: \(result)")
        let notify: [AnyObject] = [page as AnyObject, result as AnyObject, response]
        let notification:Notification = Notification(name: Notification.Name(rawValue: "ServerResponse"), object: notify)
        NotificationCenter.default.post(notification)
    }
    
    static func httpGet(_ url: String, callback: @escaping (NSMutableArray) -> Void, page:String) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        httpRequest(request, session: session, callback: callback, page: page)
    }
    
    static func httpRequest(_ request: NSMutableURLRequest, session: URLSession, callback: @escaping (NSMutableArray) -> Void, page:String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NetworkIndicatorOn"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadingDataStart"), object: nil)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NetworkIndicatorOff"), object: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadingDataStop"), object: nil)
            if error != nil {
                print(error!.localizedDescription)
                //callback("", error!.localizedDescription, page: page, response: response!)
            } else {
                let result = NSString(data: data!, encoding:
                    String.Encoding.ascii.rawValue)!
                callback([page, result as String, response!] as NSMutableArray)
            }
        })
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
}