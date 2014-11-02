//
//  QRViewController.m
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 10/30/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "QRViewController.h"
#import "DBZ_ServerCommunication.h"

@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupWebView:) name:@"APNSReady" object:nil];
    
    
    
}

-(void)setupWebView:(NSNotification *)notification {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/NewQRSession?token=%@", [DBZ_ServerCommunication serverAddress], [DBZ_ServerCommunication apns]]]];
    [self.webView.mainFrame loadRequest:request];
}

@end
