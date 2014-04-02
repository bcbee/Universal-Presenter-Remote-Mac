//
//  DBZ_PresentWindowController.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 3/31/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DBZ_PresentWindowController : NSWindowController
@property (weak) IBOutlet NSButton *connectButton;

- (IBAction)connectButton:(id)sender;
@end
