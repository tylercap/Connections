//
//  MyCollectionViewController.m
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

@import GoogleMobileAds;

#import "MyCollectionViewController.h"

static NSString * const CellIdentifier = @"TileCell";
static NSString * const ButtonIdentifier = @"ButtonCell";
static NSString * const LabelIdentifier = @"LabelCell";
static NSString * const BannerIdentifier = @"BannerCell";

static NSString * const BannerAdId = @"ca-app-pub-8484316959485082/7478851650";
static NSString * const InterstitialAdId = @"ca-app-pub-8484316959485082/8955584856";
static NSString * const GoogleClientId = @"320198239668-quml3u6s5mch28jvq0vpdeutg8relg25.apps.googleusercontent.com";

@implementation MyCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.model = [[Model alloc]init];
    [self.model loadNewGame];
     
    _headerSections = 1;
    _footerSections = 2;
    _signedIn = NO;
    
    
    self.tiles = [[NSMutableArray alloc] initWithCapacity:10];
    for( int i = 0; i < 10; i++ ){
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:9];
        [self.tiles addObject:items];
    }
    
    [self loadInterstitial];
}

- (void)loadInterstitial
{
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = InterstitialAdId;
    
    GADRequest *request = [GADRequest request];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:request];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self loadInterstitial];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)signInOrOut
{
    if( _signedIn ){
        [[GPGManager sharedInstance] signOut];
    }
    else{
        [[GPGManager sharedInstance] signInWithClientID:GoogleClientId silently:NO];
    }
}
 
- (void)refreshInterfaceBasedOnSignIn {
    if( _silentlySigningIn ){
        [self.signInOut setHidden:YES];
    }
    else{
        [self.signInOut setHidden:NO];
    }
    
    _signedIn = [GPGManager sharedInstance].isSignedIn;
    [self.leaderboard.button setHidden:!_signedIn];
    
    if( _signedIn ){
        [self.signInOut setLabel:SignOut];
    }
    else{
        [self.signInOut setLabel:SignIn];
    }
}

- (void)didFinishGamesSignInWithError:(NSError *)error {
    if (error) {
        //NSLog(@"Received an error while signing in %@", [error localizedDescription]);
    } else {
        //NSLog(@"Signed in!");
    }
    
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
    if (error) {
        //NSLog(@"Received an error while signing out %@", [error localizedDescription]);
    } else {
        //NSLog(@"Signed out!");
    }
    
    _silentlySigningIn = NO;
    [self refreshInterfaceBasedOnSignIn];
}
 */

#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.model getSections] + _headerSections + _footerSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        // banner ad
        return 1;
    }
    else if(section == (_headerSections + [self.model getSections])){
        // game description
        return 1;
    }
    else if(section == (_headerSections + [self.model getSections] + 1)){
        // 6 "cards" and submit/resign button
        return 7;
    }
    
    return [self.model getItems];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *specialtyCell = [self getSpecialCell:collectionView
                                        cellForItemAtIndexPath:indexPath];
    if( specialtyCell != nil ){
        return specialtyCell;
    }
    
    MyCollectionViewCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    
    NSInteger row = [indexPath section] - _headerSections;
    NSInteger column = [indexPath item];
    
    NSMutableArray *rowArray = [self.tiles objectAtIndex:row];
    [rowArray insertObject:myCell atIndex:column];
    
    NSInteger value = [self.model getValueAt:row column:column];
    NSInteger owner = [self.model getOwnerAt:row column:column];
    
    [myCell setLabel:value owner:owner parent:self];
    
    return myCell;
}

-(UICollectionViewCell *)getSpecialCell:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger item = [indexPath item];
    
    UICollectionViewCell *cell = nil;
    if( section == 0 ){
        /*if( _bannerAdCell != nil ){
            cell = _bannerAdCell;
        }
        else{*/
            MyBannerCell *bannerCell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:BannerIdentifier
                                        forIndexPath:indexPath];
            
            
            bannerCell.bannerAd.adUnitID = BannerAdId;
            bannerCell.bannerAd.rootViewController = self;
            [bannerCell.bannerAd loadRequest:[GADRequest request]];
            
            _bannerAdCell = bannerCell;
            cell = bannerCell;
        //}
    }
    else if(section == (_headerSections + [self.model getSections])){
        MyLabelCell *labelCell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:LabelIdentifier
                                  forIndexPath:indexPath];
        
        [labelCell showHowTo];
        
        cell = labelCell;
    }
    else if(section == (_headerSections + [self.model getSections] + 1)){
        if( item == 6 ){
            MyButtonCell *buttonCell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:ButtonIdentifier
                                        forIndexPath:indexPath];
            
            UIColor *backColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.01 alpha:1.0];
            UIColor *textColor = [UIColor colorWithWhite:0.0 alpha:1.0];
            [buttonCell setLabel:@"Resign"
                       backColor:backColor
                       textColor:textColor
                         rounded:YES];
            cell = buttonCell;
        }
        else{
            MyCollectionViewCell *myCell = [collectionView
                                            dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                            forIndexPath:indexPath];
            
            NSInteger value = [self.model getPlayerOption:item];
            
            [myCell setLabel:value owner:1 parent:self];
            cell = myCell;
        }
    }
    
    return cell;
}

@end