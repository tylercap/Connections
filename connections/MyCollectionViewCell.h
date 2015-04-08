//
//  MyCollectionViewCell.h
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewController.h"

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@property (nonatomic, weak) UIViewController *parentController;
@property (atomic) NSInteger owner;
@property (atomic) Boolean myTurn;
@property (atomic) Boolean playerCard;
@property (atomic) Boolean isHighlighted;

-(void)setLabel:(NSInteger)value
            row:(NSInteger)row
         column:(NSInteger)column
          owner:(NSInteger)owner
        players:(Boolean)playerCard
         parent:(UIViewController *)parent
         myTurn:(Boolean)myTurn;
-(void)updateValue:(NSInteger)value;

- (void)highlightTile:(Boolean)highlight;
- (void)highlightPlayerCard:(Boolean)highlight;

@end
