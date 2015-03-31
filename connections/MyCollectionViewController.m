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
//static NSString * const InterstitialAdId = @"ca-app-pub-8484316959485082/8955584856";

@implementation MyCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.model = [[Model alloc]init];
    [self loadGame];
     
    _headerSections = 1;
    _footerSections = 2;
    
    self.playerCards = [[NSMutableArray alloc] initWithCapacity:6];
    self.tiles = [[NSMutableArray alloc] initWithCapacity:9];
    for( int i = 0; i < 9; i++ ){
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:8];
        [self.tiles addObject:items];
    }
    
//    [self loadInterstitial];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = _game;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loadGame
{
    //TODO: load the game from google play
    [self.model loadNewGame];
    self.owner = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)highlightedTileClicked:(NSInteger)value
                               row:(NSInteger)row
                            column:(NSInteger)column
{
    // remove all highlighting before setting the owner
    for( int i = 0; i < _playerCards.count; i++ ){
        MyCollectionViewCell *card = [_playerCards objectAtIndex:i];
        if(card.isHighlighted){
            NSInteger value = [_model newPlayerOption:i owner:self.owner];
            [card updateValue:value];
            
            // update model
            if( value == -2 ){
                // just removing the previous owner
                [_model setOwnerAt:0 row:row column:column];
            }
            else{
                [_model setOwnerAt:self.owner row:row column:column];
            }
            Boolean winner = [_model checkForWinner:self.owner row:row column:column];
            
            if( winner ){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                                message:@"Would you like to challenge your opponent to a rematch?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:@"Rematch", nil];
                [alert show];
            }
        }
    }
    
    NSInteger currentOwner = self.owner;
    [self submitMove];
    
    //returns the owner int
    return currentOwner;
}

- (void)submitMove
{
    //TODO: submit the updated model to google play and set it to the other player's turn
    if( self.owner == 1 ){
        self.owner = 2;
    }
    else if( self.owner == 2 ){
        self.owner = 1;
    }
    
    [self.collectionView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ){
        // go back to home screen
    }
    if( buttonIndex == 1 ){
        // start a rematch
    }
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
            
            if( value >= 0 && cell.value == value && cell.owner == 0 ){
                [cell highlightTile:highlight];
            }
            else if( value == -2 && cell.owner != 0 && cell.owner != self.owner ){
                // can remove other players card
                [cell highlightTile:highlight];
            }
            else if( value == -1 && cell.owner == 0 ){
                // can be played in any open space
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
    
    [myCell setLabel:value row:row column:column owner:owner players:NO parent:self];
    
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
            
            NSInteger value = [self.model getPlayerOption:item owner:self.owner];
            
            [myCell setLabel:value row:-1 column:item owner:self.owner players:YES parent:self];
            cell = myCell;
            
            [_playerCards insertObject:myCell atIndex:item];
        }
    }
    
    return cell;
}

@end