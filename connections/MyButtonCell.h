//
//  MyButtonCell.h
//  jumpsum
//
//  Created by Tyler Cap on 2/6/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButtonCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIButton *button;

-(void) setLabel:(NSString *) value;

-(void) setLabel:(NSString *) value
       backColor:(UIColor *) back
       textColor:(UIColor *) text
         rounded:(Boolean) round;
@end
