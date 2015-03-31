//
//  MyTableViewController.h
//  jumpsumfree
//
//  Created by Tyler Cap on 2/23/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import "MyTableViewCell.h"
#import "MyCollectionViewController.h"
#import "MyWebViewController.h"
#import "Application.h"

@interface MyTableViewController : UITableViewController <GPGStatusDelegate>

@property (nonatomic, strong) UIBarButtonItem *signInItem;
@property (nonatomic, strong) NSArray *openGames;

@property (nonatomic) Boolean signedIn;
@property (nonatomic) Boolean silentlySigningIn;

@end
