//
//  MyLabelCell.m
//  jumpsum
//
//  Created by Tyler Cap on 2/6/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "MyLabelCell.h"

@implementation MyLabelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)showHowTo
{
    NSString *line1 = @"Get 5 tiles in a row vertically, horizontally, or diagonally to win.";
    
    NSString *lightning = [self getEmoji:@"\U000026A1"];
    NSString *clover = [self getEmoji:@"\U0001F340"];
    
    NSString *line2 = [NSString stringWithFormat:@"%@ is a wild that can be placed on any open space.", clover ];
    NSString *line3 = [NSString stringWithFormat:@"%@ can open up any space that your opponent occupies.", lightning ];
    
    [self setLabel:line1 line2:line2 line3:line3];
}

- (NSString*)getEmoji:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    data = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoji = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    return valueEmoji;
}

- (void)setLabel:(NSString *) line1
           line2:(NSString *) line2
           line3:(NSString *) line3
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.label setFont:[UIFont systemFontOfSize:24]];
    }
    
    self.label.text = [NSString stringWithFormat:@"%@\n%@\n%@", line1, line2, line3];
}

@end
