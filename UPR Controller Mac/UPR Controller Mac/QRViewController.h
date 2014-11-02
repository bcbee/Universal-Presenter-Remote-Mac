//
//  QRViewController.h
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 10/30/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface QRViewController : NSViewController
@property (strong) IBOutlet WebView *webView;

@end
