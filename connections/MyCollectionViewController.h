//
//  MyCollectionViewController.h
//  connections
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlayGames/GooglePlayGames.h>
#import "MyTableViewController.h"
#import "MyCollectionViewCell.h"
#import "MyCollectionViewLayout.h"
#import "MyButtonCell.h"
#import "MyLabelCell.h"
#import "MyBannerCell.h"
#import "Model.h"

@interface MyCollectionViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong, nonatomic) MyTableViewController *lobby;

@property (strong, nonatomic) NSMutableArray *tiles;
@property (strong, nonatomic) NSMutableArray *playerCards;
@property (strong, nonatomic) Model *model;
@property (nonatomic) NSInteger owner;
@property (nonatomic) Boolean myTurn;
@property (nonatomic) Boolean removeClicked;

@property (strong, nonatomic) GPGTurnBasedMatch *match;

@property (nonatomic) NSInteger headerSections;
@property (nonatomic) NSInteger footerSections;
@property (strong, nonatomic) MyBannerCell *bannerAdCell;
@property (strong, nonatomic) MyButtonCell *resignButton;

-(void)highlightOptions:(Boolean)highlight
               forValue:(NSInteger)value;
-(NSInteger)highlightedTileClicked:(NSInteger)value
                               row:(NSInteger)row
                            column:(NSInteger)column;

@end

