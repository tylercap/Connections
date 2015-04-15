//
//  MyButtonCell.h
//  connections
//
//  Created by Tyler Cap on 2/6/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButtonCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (strong, atomic) UIColor *backColor;

-(void) setLabel:(NSString *) value;

-(void) setLabel:(NSString *) value
   disabledLabel:(NSString *) disabled
       backColor:(UIColor *) back
       textColor:(UIColor *) text
         rounded:(Boolean) round;

- (void)setEnabled:(Boolean)enabled;

@end
