//
//  MyTableViewController.h
//  connections
//
//  Created by Tyler Cap on 2/23/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import "MyTableViewCell.h"
#import "MyWebViewController.h"
#import "Application.h"
#import "OfflineModel.h"

@interface MyTableViewController : UITableViewController <GPGStatusDelegate, GPGTurnBasedMatchDelegate, GPGTurnBasedMatchListLauncherDelegate, GPGPlayerPickerLauncherDelegate>

@property (nonatomic, strong) UIBarButtonItem *signInItem;
@property (nonatomic, strong) NSMutableArray *openGames;
@property (nonatomic, strong) NSMutableArray *matchesToTrack;
@property (nonatomic) Boolean shouldDeclineMatch;

@property (nonatomic) Boolean signedIn;
@property (nonatomic) Boolean silentlySigningIn;

- (void)submitRematch:(GPGTurnBasedMatch*)match;

@end
