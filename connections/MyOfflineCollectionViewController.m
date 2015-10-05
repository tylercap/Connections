//
//  MyOfflineCollectionViewController.m
//  connections
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyOfflineCollectionViewController.h"

static NSString * const CellIdentifier = @"TileCell";
static NSString * const ButtonIdentifier = @"ButtonCell";
static NSString * const LabelIdentifier = @"LabelCell";
static NSString * const BannerIdentifier = @"BannerCell";

static NSString * const intAdName = @"CONNECT_IOS_INTERSTITIAL";

static NSString * const youLost = @"You Lost";
static NSString * const youWon = @"You Win!";

@implementation MyOfflineCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [[OfflineModel alloc]init];
    [self loadGame];
    
    _headerSections = 1;
    _footerSections = 2;
    
    self.playerCards = [[NSMutableArray alloc] initWithCapacity:6];
    self.tiles = [[NSMutableArray alloc] initWithCapacity:9];
    for( int i = 0; i < 9; i++ ){
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:8];
        [self.tiles addObject:items];
    }
    
    [self loadInterstitial];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // display the opponent
    self.navigationItem.title = @"Connections";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_bannerAdCell loadAd:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInterstitial
{
    _adInterstitial = [[FlurryAdInterstitial alloc] initWithSpace:intAdName];
    _adInterstitial.adDelegate = self;
    
    [_adInterstitial fetchAd];
}

// Invoked when an ad is received for the specified interstitialAd object.
- (void) adInterstitialDidFetchAd:(FlurryAdInterstitial*)interstitialAd
{
    // you can choose to present the ad as soon as it is received
    [interstitialAd presentWithViewController:self];
}

// Invoked when the interstitial ad is rendered.
- (void) adInterstitialDidRender:(FlurryAdInterstitial *)interstitialAd
{
}

// Informs the app that a video associated with this ad has finished playing.
// Only present for rewarded & client-side rewarded ad spaces
- (void) adInterstitialVideoDidFinish:(FlurryAdInterstitial *)interstitialAd
{
}

// Informational callback invoked when there is an ad error
- (void) adInterstitial:(FlurryAdInterstitial*)interstitialAd
                adError:(FlurryAdError) adError
       errorDescription:(NSError*) errorDescription
{
    // @param interstitialAd The interstitial ad object associated with the error
    // @param adError an enum that gives the reason for the error.
    // @param errorDescription An error object that gives additional information on the cause of the ad error.
}

- (void) showInterstitial
{
    int random = arc4random_uniform(9);
    if ( random < 2 && [_adInterstitial ready] ){
        [_adInterstitial presentWithViewController:self];
    } else {
        [_adInterstitial fetchAd];
    }
}

- (void)loadGame
{
    //TODO: use data stored on disk
    [self.model loadNewGame];
    self.gameOver = NO;
    
    self.owner = self.model.ownersTurn;
}

-(NSInteger)highlightedTileClicked:(NSInteger)value
                               row:(NSInteger)row
                            column:(NSInteger)column
{
    // remove all highlighting before setting the owner
    Boolean winner = NO;
    for( int i = 0; i < _playerCards.count; i++ ){
        MyCollectionViewCell *card = [_playerCards objectAtIndex:i];
        if(card.isHighlighted){
            NSInteger newValue = [_model newPlayerOption:i owner:self.owner];
            [card updateValue:newValue];
            
            // update model
            if( _removeClicked ){
                // just removing the previous owner
                [_model setOwnerAt:0 row:row column:column];
            }
            else{
                [_model setOwnerAt:self.owner row:row column:column];
            }
            winner = [_model checkForWinner:self.owner row:row column:column];
            
            if( winner ){
                self.gameOver = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:youWon
                                                                message:@"Congratulations, You've Won!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    
    NSInteger currentOwner = self.owner;
    
    if( self.owner == 1 ){
        self.owner = 2;
        self.model.ownersTurn = 2;
    }
    else{
        self.owner = 1;
        self.model.ownersTurn = 1;
    }
    [self.collectionView reloadData];
    [self.model storeToData];
    
    //returns the owner int
    return currentOwner;
}

-(void)highlightOptions:(Boolean)highlight
               forValue:(NSInteger)value
{
    if( highlight ){
        for( int col = 0; col < _playerCards.count; col++ ){
            MyCollectionViewCell *cell = [_playerCards objectAtIndex:col];
            [cell highlightPlayerCard:NO];
        }
    }
    
    for( int row = 0; row < _tiles.count; row++ ){
        NSMutableArray *rowArr = [_tiles objectAtIndex:row];
        for( int col = 0; col < rowArr.count; col++ ){
            MyCollectionViewCell *cell = [rowArr objectAtIndex:col];
            
            if( value >= 0 && cell.value == value && cell.cardOwner == 0 ){
                _removeClicked = NO;
                [cell highlightTile:highlight];
            }
            else if( value == -2 && cell.cardOwner != 0 && cell.cardOwner != self.owner ){
                // can remove other players card
                _removeClicked = YES;
                [cell highlightTile:highlight];
            }
            else if( value == -1 && cell.cardOwner == 0 ){
                // can be played in any open space
                _removeClicked = NO;
                [cell highlightTile:highlight];
            }
        }
    }
}

//- (void)loadInterstitial
//{
//    self.interstitial = [[GADInterstitial alloc] init];
//    self.interstitial.adUnitID = InterstitialAdId;
//
//    GADRequest *request = [GADRequest request];
//    self.interstitial.delegate = self;
//    [self.interstitial loadRequest:request];
//}

//- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
//    [self loadInterstitial];
//}

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
        // 6 "cards"
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
    
    [myCell setLabel:value row:row column:column cardOwner:owner deviceOwner:self.owner players:NO parent:self myTurn:!self.gameOver];
    
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
        
        //            [bannerCell loadAd:self];
        //            bannerCell.bannerAd.adUnitID = BannerAdId;
        //            bannerCell.bannerAd.rootViewController = self;
        //            [bannerCell.bannerAd loadRequest:[GADRequest request]];
        
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
        if(item == 6){
            MyButtonCell *buttonCell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:ButtonIdentifier
                                        forIndexPath:indexPath];
            
            UIColor *backColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.01 alpha:1.0];
            UIColor *textColor = [UIColor colorWithWhite:0.0 alpha:1.0];
            [buttonCell setLabel:@"Offline"
                   disabledLabel:@"Offline"
                       backColor:backColor
                       textColor:textColor
                         rounded:YES];
            
            cell = buttonCell;
            [buttonCell setEnabled:NO];
            return cell;
        }
        MyCollectionViewCell *myCell = [collectionView
                                        dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                        forIndexPath:indexPath];
        
        NSInteger value = [self.model getPlayerOption:item owner:self.owner];
        
        [myCell setLabel:value row:-1 column:item cardOwner:self.owner deviceOwner:self.owner players:YES parent:self myTurn:!self.gameOver];
        cell = myCell;
        
        [_playerCards insertObject:myCell atIndex:item];
    }
    
    return cell;
}

@end