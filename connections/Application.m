//
//  Application.m
//  jumpsum
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "Application.h"

@implementation Application

- (BOOL)openURL:(NSURL*)url
{
    NSURL *googlePlusURL = [[NSURL alloc] initWithString:@"gplus://plus.google.com/"];
    
    BOOL hasGPPlusAppInstalled = [[UIApplication sharedApplication] canOpenURL:googlePlusURL];
    
    
    if(!hasGPPlusAppInstalled)
    {
        if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
            
            return NO;
            
        } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AppOpenGoogleNotification object:url];
            return NO;
            
        }
    }
    
    return [super openURL:url];
}

@end
