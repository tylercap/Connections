//
//  MyBannerCell.h
//  connections
//
//  Created by Tyler Cap on 2/11/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FlurryAdBanner.h"
#import "FlurryAdBannerDelegate.h"

@interface MyBannerCell : UICollectionViewCell <FlurryAdBannerDelegate>

@property (weak, nonatomic) IBOutlet UIView *childView;
@property (nonatomic, strong) FlurryAdBanner *adBanner;
@property (nonatomic, strong) UIViewController *parent;

- (void)loadAd:(UIViewController*)parent;

@end
