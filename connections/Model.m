//
//  Model.m
//  connections
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import "Model.h"

int values[9][8];
int owners[9][8];

@implementation Model

- (id)init
{
    self = [super init];
    
    return self;
}

// at least one of sections or items must be even

-(NSInteger)getSections
{
    return 9;
}

-(NSInteger)getItems
{
    return 8;
}

-(void)loadNewGame
{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    NSMutableArray *unshuffled = [[NSMutableArray alloc]init];

    int remaining = (int) ([self getSections] * [self getItems]);
    for( int i=0; i<(remaining / 2); i++ ){
        for( int j=0; j<2; j++ ){
            [values addObject:[NSString stringWithFormat:@"%d",i]];
            [unshuffled addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    // two extra cards in the deck for "remove" and "wild"
    for( int i = -2; i < 0; i++ ){
        for( int j=0; j<2; j++ ){
            [unshuffled addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray* owners = [[NSMutableArray alloc] init];
    for( int i=0; i<[self getSections]; i++ ){
        NSMutableArray* row = [[NSMutableArray alloc] init];
        [array addObject:row];
        
        NSMutableArray* oRow = [[NSMutableArray alloc] init];
        [owners addObject:oRow];
        
        for( int j=0; j<[self getItems]; j++ ){
            NSUInteger index = arc4random_uniform(remaining);
            [row addObject:[values objectAtIndex:index]];
            
            [values removeObjectAtIndex:index];
            remaining--;
            
            [oRow addObject:@"0"];
        }
    }
    
    [self loadFromArray:array owners:owners deck:unshuffled];
}

-(NSInteger)getPlayerOption:(NSInteger)num
{
    int remaining = (int)[self.deck count];
    NSUInteger index = arc4random_uniform(remaining);
    NSInteger value = [[self.deck objectAtIndex:index] integerValue];
    
    [self.deck removeObjectAtIndex:index];
    
    return value;
}

-(NSInteger)getValueAt:(NSInteger)row
                column:(NSInteger)column
{
    return values[row][column];
}

-(NSInteger)getOwnerAt:(NSInteger)row
                column:(NSInteger)column
{
    return values[row][column];
}

-(void)setValueAt:(NSInteger)value
              row:(NSInteger)row
           column:(NSInteger)column
{
    values[row][column] = (int)value;
}

-(void)setOwnerAt:(NSInteger)value
              row:(NSInteger)row
           column:(NSInteger)column
{
    owners[row][column] = (int)value;
}

-(void)loadFromArray:(NSArray *)gameboard
              owners:(NSArray *)owners
                deck:(NSMutableArray *)unshuffled
{
    for( int i=0; i<gameboard.count; i++ ){
        NSArray *row = gameboard[i];
        
        for( int j=0; j<row.count; j++ ){
            [self setValueAt:[row[j] integerValue] row:i column:j];
        }
    }
    
    for( int i=0; i<owners.count; i++ ){
        NSArray *row = owners[i];
        
        for( int j=0; j<row.count; j++ ){
            [self setOwnerAt:[row[j] integerValue] row:i column:j];
        }
    }
    
    _deck = unshuffled;
}

-(NSMutableArray *)storeToArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for( int i=0; i<[self getSections]; i++ ){
        NSMutableArray* row = [[NSMutableArray alloc] init];
        [array addObject:row];
        
        for( int j=0; j<[self getItems]; j++ ){
            NSInteger val = [self getValueAt:i column:j];
            NSString *str_val = [NSString stringWithFormat:@"%ld",(long)val];
            [row addObject:str_val];
        }
    }
    
    return array;
}

@end
