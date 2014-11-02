//
//  DBZ_ServerCommunication.h
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBZ_ServerCommunication : NSObject


+(NSString*)serverAddress;
+(int)uid;
+(int)temptoken;
+(int)controlmode;
+(NSInteger)token;
+(bool)serverAvailable;
+(bool)enabled;
+(NSString*)apns;
+(void)setEnabled:(bool)changeto;

+(void)getResponse:(NSString*)page withToken:(NSInteger)requestToken withHoldfor:(bool)holdfor;
+(void)processResponse:(NSMutableArray*)webResponse;
+(void)setupUid;
+(void)checkStatus;
+(void)checkStatusCallback:(NSString*)response;
+(void)checkToken:(NSTimer *)timer;
+(void)checkTokenCallback:(NSString*)response;
+(void)newTokenCallback:(NSString*)response;
+(void)updateInterface;
+(void)joinSession:(NSInteger)sendtoken;
+(void)joinSessionCallback:(NSString*)response;
+(void)activeSessionCallback:(NSString*)response;
+(void)checkSlide:(NSTimer *)timer;
+(void)connectSetup;
+(void)setupApns:(NSData*)deviceToken;

@end
