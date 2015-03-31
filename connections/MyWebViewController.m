//
//  MyWebViewController.m
//  jumpsum
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyWebViewController.h"

@implementation MyWebViewController

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:@"com.gmail.tylercap4.connections:/oauth2callback"]) {
        [GPPURLHandler handleURL:[request URL] sourceApplication:@"com.google.chrome.ios" annotation:nil];
        
        // Looks like we did log in (onhand of the url), we are logged in, the Google APi handles the rest
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)loadRequest:(NSURL*)url
{
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:request];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
