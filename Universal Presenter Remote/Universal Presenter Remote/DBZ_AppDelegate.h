//
//  DBZ_AppDelegate.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DBZ_AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) id activity;

@property (weak) IBOutlet NSTextField *token1;
@property (weak) IBOutlet NSTextField *token2;
@property (weak) IBOutlet NSTextField *token3;
@property (weak) IBOutlet NSTextField *token4;
@property (weak) IBOutlet NSTextField *token5;
@property (weak) IBOutlet NSTextField *token6;
@property (weak) IBOutlet NSTextField *tokenLabel;
@property (weak) IBOutlet NSButton *presentButton;
@property (weak) IBOutlet NSButton *connectButton;

- (IBAction)connectButton:(id)sender;
- (IBAction)instructionButton:(id)sender;
- (IBAction)refresh:(id)sender;

- (void)textViewDidChange:(NSNotification*)notification;
- (void)validate;
- (void)incomingNotification:(NSNotification *)notification;
- (void)updateInterface:(NSNotification*)notification;
- (void)joinSession:(NSNotification*)notification;
- (void)reset:(NSNotification *)notification;
- (void)refreshInterface:(NSNotification*)notification;




@end
