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
int owner1Cards[6];
int owner2Cards[6];

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

-(NSInteger)getPlayerCards
{
    return 6;
}

-(void)loadFromData:(NSData *)data
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSArray *gameboard = [array objectAtIndex:0];
    NSArray *owners = [array objectAtIndex:1];
    NSArray *p1 = [array objectAtIndex:2];
    NSArray *p2 = [array objectAtIndex:3];
    NSArray *unshuffled = [array objectAtIndex:4];
    NSString *ownersTurnString = [array objectAtIndex:5];
    _ownersTurn = [ownersTurnString integerValue];
    
    [self loadFromArray:gameboard owners:owners player1:p1 player2:p2 deck:unshuffled];
}

-(NSData*)storeToData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[self storeGameboardToArray]];
    [array addObject:[self storeOwnersToArray]];
    [array addObject:[self storeP1CardsToArray]];
    [array addObject:[self storeP2CardsToArray]];
    [array addObject:_deck];
    NSString *ownersTurnString = [NSString stringWithFormat:@"%ld", (long)_ownersTurn];
    [array addObject:ownersTurnString];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    return data;
}

-(void)loadNewGame
{
    _ownersTurn = 1;
    
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

    NSMutableArray* p1 = [[NSMutableArray alloc] init];
    NSMutableArray* p2 = [[NSMutableArray alloc] init];
    for( int i=0; i<[self getPlayerCards]; i++ ){
        [p1 addObject:[NSString stringWithFormat:@"%d",[self getNextPlayerOption:unshuffled]]];
        [p2 addObject:[NSString stringWithFormat:@"%d",[self getNextPlayerOption:unshuffled]]];
    }
    
    [self loadFromArray:array owners:owners player1:p1 player2:p2 deck:unshuffled];
}

-(NSInteger)getNextPlayerOption
{
    return [self getNextPlayerOption:_deck];
}

-(NSInteger)getNextPlayerOption:(NSMutableArray*)deck
{
    int remaining = (int)[deck count];
    if( remaining == 0 ){
        return -3;
    }
    
    NSUInteger index = arc4random_uniform(remaining);
    NSInteger value = [[deck objectAtIndex:index] integerValue];
    
    [deck removeObjectAtIndex:index];
    
    return value;
}

-(NSInteger)getPlayerOption:(NSInteger)column
                      owner:(NSInteger)owner
{
    if( owner == 2 ){
        return owner2Cards[column];
    }
    else{
        return owner1Cards[column];
    }
}

-(NSInteger)newPlayerOption:(NSInteger)column
                      owner:(NSInteger)owner
{
    NSInteger value = [self getNextPlayerOption];
    
    if( owner == 2 ){
        owner2Cards[column] = value;
    }
    else{
        owner1Cards[column] = value;
    }
    
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
    return owners[row][column];
}

-(void)setValueAt:(NSInteger)value
              row:(NSInteger)row
           column:(NSInteger)column
{
    values[row][column] = (int)value;
}

-(void)setP1At:(NSInteger)value
        column:(NSInteger)column
{
    owner1Cards[column] = (int)value;
}

-(void)setP2At:(NSInteger)value
        column:(NSInteger)column
{
    owner2Cards[column] = (int)value;
}

-(void)setOwnerAt:(NSInteger)value
              row:(NSInteger)row
           column:(NSInteger)column
{
    owners[row][column] = (int)value;
}

-(void)loadFromArray:(NSArray *)gameboard
              owners:(NSArray *)owners
             player1:(NSArray *)p1
             player2:(NSArray *)p2
                deck:(NSArray *)unshuffled
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
    
    for( int j=0; j<p1.count; j++ ){
        [self setP1At:[p1[j] integerValue] column:j];
    }
    for( int j=0; j<p2.count; j++ ){
        [self setP2At:[p2[j] integerValue] column:j];
    }
    
    _deck = [[NSMutableArray alloc]init];
    for( int i = 0; i < unshuffled.count; i++ ){
        [_deck addObject:[unshuffled objectAtIndex:i]];
    }
}

-(NSMutableArray *)storeGameboardToArray
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

-(NSMutableArray *)storeOwnersToArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for( int i=0; i<[self getSections]; i++ ){
        NSMutableArray* row = [[NSMutableArray alloc] init];
        [array addObject:row];
        
        for( int j=0; j<[self getItems]; j++ ){
            NSInteger val = [self getOwnerAt:i column:j];
            NSString *str_val = [NSString stringWithFormat:@"%ld",(long)val];
            [row addObject:str_val];
        }
    }
    
    return array;
}

-(NSMutableArray *)storeP1CardsToArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for( int j=0; j<[self getPlayerCards]; j++ ){
        NSInteger val = [self getPlayerOption:j owner:1];
        NSString *str_val = [NSString stringWithFormat:@"%ld",(long)val];
        [array addObject:str_val];
    }
    
    return array;
}

-(NSMutableArray *)storeP2CardsToArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for( int j=0; j<[self getPlayerCards]; j++ ){
        NSInteger val = [self getPlayerOption:j owner:2];
        NSString *str_val = [NSString stringWithFormat:@"%ld",(long)val];
        [array addObject:str_val];
    }
    
    return array;
}

-(Boolean)checkForWinner:(NSInteger)owner
                     row:(NSInteger)row
                  column:(NSInteger)column
{
    // check horizontal
    int connections = 0;
    for( int i = 0; i < [self getItems]; i++ ){
        if( owners[row][i] == owner ){
            connections++;
        }
        else{
            connections = 0;
        }
        
        if( connections == 5 ){
            return YES;
        }
    }
    
    // check vertical
    connections = 0;
    for( int i = 0; i < [self getSections]; i++ ){
        if( owners[i][column] == owner ){
            connections++;
        }
        else{
            connections = 0;
        }
        
        if( connections == 5 ){
            return YES;
        }
    }
    
    // check diagonal
    return [self checkDiagonal:owner row:row column:column];
}

-(Boolean)checkDiagonal:(NSInteger)owner
                    row:(NSInteger)row
                 column:(NSInteger)column
{
    return [self checkDiagonal1:owner row:row column:column] || [self checkDiagonal2:owner row:row column:column];
}

-(Boolean)checkDiagonal1:(NSInteger)owner
                     row:(NSInteger)row
                  column:(NSInteger)column
{
    // top left to bottom right (column and row increase together)
    int connections = 0;
    if( column <= row ){
        for( int i = 0; i < [self getItems]; i++ ){
            if( (row - column) + i >= [self getSections] ){
                break;
            }
            if( owners[(row - column) + i][i] == owner ){
                connections++;
            }
            else{
                connections = 0;
            }
            
            if( connections == 5 ){
                return YES;
            }
        }
    }
    else{ //column > row
        for( int i = 0; i < [self getSections]; i++ ){
            if( (column - row) + i >= [self getItems] ){
                break;
            }
            if( owners[i][(column - row) + i] == owner ){
                connections++;
            }
            else{
                connections = 0;
            }
            
            if( connections == 5 ){
                return YES;
            }
        }
    }
    
    return NO;
}

-(Boolean)checkDiagonal2:(NSInteger)owner
                     row:(NSInteger)row
                  column:(NSInteger)column
{
    // bottom left to top right (column increases while row decreases)
    int connections = 0;
    if( column < ([self getSections] - 1 - row) ){
        // we will start at column 0 and move until row 0
        int currCol = 0;
        int currRow = row + column;
        
        while( currRow >= 0 ){
            if( owners[currRow][currCol] == owner ){
                connections++;
            }
            else{
                connections = 0;
            }
            
            if( connections == 5 ){
                return YES;
            }
            
            currRow--;
            currCol++;
        }
    }
    else{ //column >= ([self getSections] - 1 - row)
        // we will start at last row and end at last column
        int currRow = [self getSections] - 1;
        int currCol = column - ([self getSections] - 1 - row);
        
        while( currCol < [self getItems] ){
            if( owners[currRow][currCol] == owner ){
                connections++;
            }
            else{
                connections = 0;
            }
            
            if( connections == 5 ){
                return YES;
            }
            
            currRow--;
            currCol++;
        }
    }
    
    return NO;
}

@end
