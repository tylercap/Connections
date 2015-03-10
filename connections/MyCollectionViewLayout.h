//
//  MyCollectionViewLayout.h
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) CGFloat interItemSpacingX;
@property (nonatomic) CGFloat headerButtonWidth;
@property (nonatomic) CGFloat headerLabelWidth;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) NSInteger numberOfRows;

@property (nonatomic, strong) NSDictionary *layoutInfo;

@end
