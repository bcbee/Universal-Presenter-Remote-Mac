//
//  DBZ_ServerCommunication.m
//  Universal Presenter Remote
//
//  Created by Brendan Boyle on 4/11/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

#import "DBZ_ServerCommunication.h"
#import "DBZ_SlideControl.h"

@implementation DBZ_ServerCommunication

static NSString *serverAddress = @"http://universalpresenterremote.com";
static int uid = 10;
static int temptoken = 10;
static int controlmode = 0;
static NSInteger token = 0;
static bool serverAvailable = NO;
static bool enabled = NO;
static NSTimer *timer;
static NSTimer *activeTimer;
static int errorCount = 0;

static NSString *apns = @"";

+(NSString*)serverAddress { return  serverAddress; }
+(int)uid { return  uid; }
+(int)temptoken { return  temptoken; }
+(int)controlmode { return  controlmode; }
+(NSInteger)token { return  token; }
+(bool)serverAvailable { return  serverAvailable; }
+(bool)enabled { return  enabled; }
+(NSString*)apns { return  apns; }

+(void)setEnabled:(bool)changeto {
    if (enabled != changeto && changeto) {
        [DBZ_ServerCommunication getResponse:@"ActiveSession" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
    }
    enabled = changeto;
    [self updateInterface];
}

+(void)setTemptoken:(NSString*)changeto {
    temptoken = [changeto integerValue];
}

+(void)getResponse:(NSString*)page withToken:(NSInteger)requestToken withHoldfor:(bool)holdfor {
    __block NSString *result;
    NSString *strURL= [NSString stringWithFormat:@"%@/%@", serverAddress, page];
    if (requestToken > 99999) {
        strURL = [NSString stringWithFormat:@"%@?token=%ld", strURL, (long)requestToken];
    }
    
    if (holdfor) {
        strURL = [NSString stringWithFormat:@"%@&holdfor=%d", strURL, uid];
    }
    
    NSLog(@"%@", strURL);
    
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         //When Json request complite then call this block
         result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         
         NSMutableArray *notify = [NSMutableArray arrayWithObjects:page, result,response, nil];
         NSNotification* notification = [NSNotification notificationWithName:@"ServerResponse" object:notify];
         [[NSNotificationCenter defaultCenter] postNotification:notification];
         
         
     }];
}

+(void)processResponse:(NSMutableArray*)webResponse {
    // The one we want to switch on
    NSArray *items = @[@"Alive", @"NewSession", @"TempSession", @"JoinSession", @"ActiveSession"];
    NSInteger item = [items indexOfObject:[webResponse objectAtIndex:0]];
    switch (item) {
        case 0:
            // Alive
            [self checkStatusCallback:[webResponse objectAtIndex:1]];
            break;
        case 1:
            // NewSession
            [self newTokenCallback:[webResponse objectAtIndex:1]];
            break;
        case 2:
            // TempSession
            [self checkTokenCallback:[webResponse objectAtIndex:1]];
            break;
        case 3:
            // JoinSession
            [self joinSessionCallback:[webResponse objectAtIndex:1]];
            break;
        case 4:
            // ActiveSession
            [self activeSessionCallback:[webResponse objectAtIndex:1]];
            break;
        default:
            break;
    }
}

+(void)setupUid {
    NSUInteger r = arc4random_uniform(999999);
    uid = (int)r;
}

+(void)checkStatus {
    [self getResponse:@"Alive" withToken:0 withHoldfor:NO];
}

+(void)checkStatusCallback:(NSString *)response {
    if ([response isEqualToString:@"Ready"]) {
        NSLog(@"Alive!");
        serverAvailable = YES;
        [self checkToken:nil];
        
    } else {
        NSLog(@"Dead :(");
        serverAvailable = NO;
        controlmode = 0;
    }
}

+(void)checkToken:(NSTimer *)timer {
    int sendtoken = temptoken;
    [self getResponse:@"TempSession" withToken:sendtoken withHoldfor:YES];
}

+(void)checkTokenCallback:(NSString*)response {
    int r = [response intValue];
    controlmode = r;
    switch (controlmode) {
        case 0:
            [timer invalidate];
            timer = nil;
            temptoken = 0;
            break;
        case 1:
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkToken:) userInfo:nil repeats:NO];
            break;
        case 2:
            //[self checkToken];
            break;
            
        default:
            break;
    }
    if (temptoken == 0) {
        [self getResponse:@"NewSession" withToken:0 withHoldfor:NO];
    }
    [self updateInterface];
}

+(void)newTokenCallback:(NSString*)response {
    int r = [response intValue];
    temptoken = r;
    [self checkToken:nil];
}

+(void)updateInterface {
    NSNotification* notification = [NSNotification notificationWithName:@"UpdateInterface" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

+(void)joinSession:(NSInteger)sendtoken {
    token = sendtoken;
    [self getResponse:@"JoinSession" withToken:sendtoken withHoldfor:NO];
}

+(void)joinSessionCallback:(NSString *)response {
    if ([response integerValue] > 0) {
        uid = [response intValue];
        [self setEnabled:YES];
        NSNotification* notification = [NSNotification notificationWithName:@"JoinSession" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else {
        NSMutableArray *notify = [NSMutableArray arrayWithObjects:@"Whoops...", @"We couldn't find the token you entered. Please try again or refresh your token.", nil];
        NSNotification* notification = [NSNotification notificationWithName:@"Alert" object:notify];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

+(void)activeSessionCallback:(NSString *)response {
    if ([response integerValue] > 0) {
        errorCount = 0;
        NSNotification* notification = [NSNotification notificationWithName:@"ChangeSlide" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [DBZ_SlideControl setSlide:[response intValue]];
        if (enabled) {
            activeTimer = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(checkSlide:) userInfo:nil repeats:NO];
        } else {
            [activeTimer invalidate];
        }
    } else {
        errorCount++;
        if (errorCount > 3) {
            NSMutableArray *notify = [NSMutableArray arrayWithObjects:@"Whoops...", @"There was an issue talking to UPR Cloud. Please restart the application and check your internet connection.", nil];
            NSNotification* notification = [NSNotification notificationWithName:@"Alert" object:notify];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else {
            activeTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(checkSlide:) userInfo:nil repeats:NO];
        }
        
        
    }
}

+(void)checkSlide:(NSTimer *)timer {
    [DBZ_ServerCommunication getResponse:@"ActiveSession" withToken:[DBZ_ServerCommunication token] withHoldfor:YES];
}

+(void)connectSetup {
    token = temptoken;
}

+(void)setupApns:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    apns = token;
    NSNotification* notification = [NSNotification notificationWithName:@"APNSReady" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

+(void)setupAppNap {
    
}

@end
