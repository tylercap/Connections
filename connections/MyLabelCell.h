//
//  MyLabelCell.h
//  jumpsum
//
//  Created by Tyler Cap on 2/6/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLabelCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *label;

-(void) setLabel:(NSString *) value
       textColor:(UIColor *) text;
@end
