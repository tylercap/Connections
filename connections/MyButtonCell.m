//
//  MyButtonCell.m
//  connections
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
   disabledLabel:(NSString *)disabled
       backColor:(UIColor *) back
       textColor:(UIColor *) text
         rounded:(Boolean)round
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    }
    
    [self.button setTitle:value forState:UIControlStateNormal];
    //[self.button setTitle:disabled forState:UIControlStateDisabled];
    [self.button setTitleColor:text forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithWhite:0.35 alpha:1.0] forState:UIControlStateDisabled];
    
    self.backColor = back;
    self.button.backgroundColor = back;
    self.button.titleLabel.textColor = text;
    self.button.layer.borderColor = text.CGColor;
    self.button.layer.borderWidth = 1.4;
    
    if( round )
        self.button.layer.cornerRadius = 6.0f;
    
    self.button.layer.masksToBounds = YES;
}

- (void)setEnabled:(Boolean)enabled
{
    [self.button setEnabled:enabled];
    
    if( enabled ){
        self.button.backgroundColor = self.backColor;
    }
    else{
        self.button.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
}

- (void)setLabel:(NSString *)value
{
    [self.button setTitle:value forState:UIControlStateNormal];
}

@end
