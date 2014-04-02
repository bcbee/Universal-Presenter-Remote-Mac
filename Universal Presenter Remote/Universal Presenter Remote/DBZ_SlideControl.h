//
//  DBZ_SlideControl.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/1/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZ_SlideControl : NSObject

+ (void)slideControl:(int)action;
+ (void)slideLeft;
+ (void)slideRight;
+ (void)playMedia;

@end