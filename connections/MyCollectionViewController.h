//
//  MyCollectionViewController.h
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewCell.h"
#import "MyCollectionViewLayout.h"
#import "MyButtonCell.h"
#import "MyLabelCell.h"
#import "MyBannerCell.h"
#import "Model.h"

@interface MyCollectionViewController : UICollectionViewController
<UICollectionViewDataSource, GADInterstitialDelegate>

@property (nonatomic, weak) IBOutlet MyCollectionViewLayout *layout;
@property (strong, nonatomic) NSMutableArray *tiles;
@property (strong, nonatomic) NSMutableArray *playerCards;
@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) GADInterstitial *interstitial;
@property (nonatomic) Boolean signedIn;
@property (nonatomic) Boolean silentlySigningIn;

@property (nonatomic) NSInteger headerSections;
@property (nonatomic) NSInteger footerSections;
@property (weak, nonatomic) MyBannerCell *bannerAdCell;

-(void)highlightOptions:(Boolean)highlight
               forValue:(NSInteger)value;

@end

