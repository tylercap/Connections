//
//  MyCollectionViewCell.m
//  jumpsum
//
//  Created by Tyler Cap on 2/5/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (void)setLabel:(NSInteger)value
          parent:(UIViewController *)parent
{
    self.value = value;
    self.parentController = parent;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.title setFont:[UIFont systemFontOfSize:24]];
    }

    if( value > 0 ){
        [self setHidden:NO];
        NSString *text = [NSString stringWithFormat:@"%ld",(long)value];
        self.title.text = text;
    }
    else if( value < -1){
        [self setHidden:YES];
    }
    else{
        [self setHidden:NO];
        self.title.text = @"";
    }
    
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.2;
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
}

- (void)highlight:(Boolean)highlight
{
    if( _normalBack == nil ){
        _normalBack = [UIColor colorWithWhite:1.0 alpha:1.0];
        _highlightBack = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0];
    }
    
    if(highlight){
        self.backgroundColor = _highlightBack;
    }
    else{
        self.backgroundColor = _normalBack;
    }
}

@end