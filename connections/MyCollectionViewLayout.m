//
//  MyCollectionViewLayout.m
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyCollectionViewLayout.h"

static NSString * const CellIdentifier = @"TileCell";
static NSString * const ButtonIdentifier = @"ButtonCell";
static NSString * const LabelIdentifier = @"LabelCell";
static NSString * const BannerIdentifier = @"BannerCell";

@implementation MyCollectionViewLayout

- (void)setup
{
    float spacing = 2.0f;
    self.itemInsets = UIEdgeInsetsMake(0, spacing, spacing, spacing);
    
    self.numberOfRows = [self.collectionView numberOfSections];
    self.numberOfColumns = [self.collectionView numberOfItemsInSection:2];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat availableWidth  = size.width - (spacing * (self.numberOfColumns + 1));
    CGFloat availableHeight = size.height - (spacing * (self.numberOfRows + 2));
    
    CGFloat navHeight = 64.0f;
    availableHeight -= (50 + navHeight);
    CGFloat width = availableWidth / self.numberOfColumns;
    CGFloat height = availableHeight / (self.numberOfRows - 0.5); // bottom row height is 1.2 and second to last row is 1.3
    self.itemSize = CGSizeMake(width, height);
    
    self.headerButtonWidth = (size.width - (spacing * 4)) * 0.275;
    self.headerLabelWidth = (size.width - (spacing * 4)) * 0.45;
    
    self.interItemSpacingY = spacing;
    self.interItemSpacingX = spacing;
}

#pragma mark - Layout

- (void)prepareLayout
{
    [self setup];
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForItemAtIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[CellIdentifier] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark - Private

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section;
    NSInteger column = indexPath.item;
    
    CGFloat originX;
    CGFloat originY;
    CGFloat height;
    CGFloat width;
    
    if( row == 0 ){
        // banner ad
        originX = floorf(self.itemInsets.left);
        originY = floorf(self.itemInsets.top);
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        width = size.width - (self.itemInsets.left + self.itemInsets.right);
        height = 50;
    }
    else if( row == ([self.collectionView numberOfSections] - 2) ){
        originX = floorf(self.itemInsets.left);
        originY = floorf(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * (row - 1));
        
        originY += 50;// + self.interItemSpacingY;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        width = size.width - (self.itemInsets.left + self.itemInsets.right);
        height = self.itemSize.height * 1.3;
    }
    else if( row == ([self.collectionView numberOfSections] - 1) ){
        height = self.itemSize.height * 1.2;
        width = self.itemSize.width * 1.13;
        
        originY = floorf(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * (row - 0.7));
        
        originY += 50 + self.interItemSpacingY;
        
        if( column == ([self.collectionView numberOfItemsInSection:row] - 1) ){
            CGSize size = [UIScreen mainScreen].bounds.size;
            originX = size.width - (self.interItemSpacingX + width);
        }
        else{
            originX = floorf(self.itemInsets.left + (width + self.interItemSpacingX) * column);
            originX += self.interItemSpacingX;
        }
    }
    else{
        originX = floorf(self.itemInsets.left + (self.itemSize.width + self.interItemSpacingX) * column);
        
        originY = floorf(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * (row - 1));
        
        originY += 50;// + self.interItemSpacingY;
        
        height = self.itemSize.height;
        width = self.itemSize.width;
    }
    
    return CGRectMake(originX, originY, width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[CellIdentifier][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections];
    CGFloat height = self.itemInsets.top + self.itemInsets.bottom +
                    (rowCount - 1) * (self.itemSize.height + self.interItemSpacingY);
    height += 50 + self.interItemSpacingY;
    
    NSInteger colCount = [self.collectionView numberOfItemsInSection:3];
    CGFloat width = self.itemInsets.left + self.itemInsets.right +
                    colCount * self.itemSize.width + (colCount - 1) * self.interItemSpacingX;
    
    return CGSizeMake(width, height);
}

@end
