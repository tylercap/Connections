//
//  MyButtonCell.m
//  jumpsum
//
//  Created by Tyler Cap on 2/6/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyButtonCell.h"

@implementation MyButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setLabel:(NSString *)value
       backColor:(UIColor *) back
       textColor:(UIColor *) text
         rounded:(Boolean)round
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    }
    
    [self.button setTitle:value forState:UIControlStateNormal];
    
    [self.button setTitleColor:text forState:UIControlStateNormal];
    
    self.button.backgroundColor = back;
    self.button.titleLabel.textColor = text;
    self.button.layer.borderColor = text.CGColor;
    self.button.layer.borderWidth = 1.0;
    
    if( round )
        self.button.layer.cornerRadius = 6.0f;
    
    self.button.layer.masksToBounds = YES;
}

- (void)setLabel:(NSString *)value
{
    [self.button setTitle:value forState:UIControlStateNormal];
}

@end
