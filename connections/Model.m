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

-(GPGTurnBasedParticipant*)getOpponentFromMatch:(GPGTurnBasedMatch*)match
{
    NSArray *participants = match.participants;
    GPGTurnBasedParticipant *opponent = [participants objectAtIndex:0];
    
    NSString *myId = match.localParticipantId;
    if([myId isEqualToString:opponent.participantId] && [participants count] > 1){
        opponent = [participants objectAtIndex:1];
    }
    
    return opponent;
}

-(NSString*)getOpponentDisplayName
{
    NSString *myName = _match.localParticipant.displayName;
    if( myName != nil ){
        NSArray *participants = _match.participants;
        GPGTurnBasedParticipant *opponent = [participants objectAtIndex:0];
        
        if([myName isEqualToString:opponent.displayName]){
            if( [participants count] > 1 ){
                opponent = [participants objectAtIndex:1];
                return opponent.displayName;
            }
        }
        else{
            
        }
    }
    
    return [self getOpponent].displayName;
}

-(GPGTurnBasedParticipant*)getOpponent
{
    NSString *myId = _match.localParticipantId;
    if( myId != nil ){
        NSArray *participants = _match.participants;
        GPGTurnBasedParticipant *opponent = [participants objectAtIndex:0];
        
        if([myId isEqualToString:opponent.participantId]){
            if( [participants count] > 1 ){
                opponent = [participants objectAtIndex:1];
                return opponent;
            }
        }
        else{
            return opponent;
        }
    }
    
    GPGTurnBasedParticipant *participant = nil;
//    if( _match.myTurn || _match.userMatchStatus == GPGTurnBasedUserMatchStatusTurn )
//    {
//        switch ( _ownersTurn ) {
//            case 1:
//                participant = [_participants objectAtIndex:1];
//                
//                return participant;
//                break;
//            case 2:
//                participant = [_participants objectAtIndex:0];
//                
//                return participant;
//                break;
//        }
//    }
//    else
//    {
//        switch ( _ownersTurn ) {
//            case 1:
//                participant = [_participants objectAtIndex:0];
//                
//                return participant;
//                break;
//            case 2:
//                participant = [_participants objectAtIndex:1];
//                
//                return participant;
//                break;
//        }
//    }
    
    return participant;
}

-(void)loadFromData:(GPGTurnBasedMatch*)match
{
    [self loadFromCompatibleData:match];
//    _match = match;
//    
//    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:match.data];
//    
//    if( array.count < 7 ){
//        return;
//    }
//    
//    NSArray *gameboard = [array objectAtIndex:0];
//    NSArray *owners = [array objectAtIndex:1];
//    NSArray *p1 = [array objectAtIndex:2];
//    NSArray *p2 = [array objectAtIndex:3];
//    NSArray *unshuffled = [array objectAtIndex:4];
//    NSString *ownersTurnString = [array objectAtIndex:5];
//    _ownersTurn = [ownersTurnString integerValue];
//    _participants = [array objectAtIndex:6];
//    
//    [self loadFromArray:gameboard owners:owners player1:p1 player2:p2 deck:unshuffled];
}

-(void)loadFromCompatibleData:(GPGTurnBasedMatch*)match
{
    _match = match;
    NSString* newStr = [[NSString alloc] initWithData:match.data encoding:NSUTF8StringEncoding];
    
    NSRange start = [newStr rangeOfString:@"["];
    NSRange end = [newStr rangeOfString:@"]"];
    NSRange range = {start.location, (end.location - start.location) + end.length};
    NSString *gameboard = [newStr substringWithRange:range];
    NSArray *gameboard_arr = [self load2DArrayFromString:gameboard];
    
    newStr = [newStr substringFromIndex:(end.location + end.length)];
    start = [newStr rangeOfString:@"["];
    end = [newStr rangeOfString:@"]"];
    range.location = start.location;
    range.length = (end.location - start.location) + end.length;
    NSString *owners = [newStr substringWithRange:range];
    NSArray *owners_arr = [self load2DArrayFromString:owners];
    
    newStr = [newStr substringFromIndex:(end.location + end.length)];
    start = [newStr rangeOfString:@"["];
    end = [newStr rangeOfString:@"]"];
    range.location = start.location;
    range.length = (end.location - start.location) + end.length;
    NSString *p1 = [newStr substringWithRange:range];
    NSArray *p1_arr = [self load1DArrayFromString:p1];
    
    newStr = [newStr substringFromIndex:(end.location + end.length)];
    start = [newStr rangeOfString:@"["];
    end = [newStr rangeOfString:@"]"];
    range.location = start.location;
    range.length = (end.location - start.location) + end.length;
    NSString *p2 = [newStr substringWithRange:range];
    NSArray *p2_arr = [self load1DArrayFromString:p2];
    
    newStr = [newStr substringFromIndex:(end.location + end.length)];
    start = [newStr rangeOfString:@"["];
    end = [newStr rangeOfString:@"]"];
    range.location = start.location;
    range.length = (end.location - start.location) + end.length;
    NSString *unshuffled = [newStr substringWithRange:range];
    NSArray *deck_arr = [self load1DArrayFromString:unshuffled];
    
    newStr = [newStr substringFromIndex:(end.location + end.length)];
    start = [newStr rangeOfString:@"("];
    end = [newStr rangeOfString:@")"];
    range.location = start.location + start.length;
    range.length = end.location - start.location;
    NSString *ownersTurnString = [newStr substringWithRange:range];
    
//    newStr = [newStr substringFromIndex:(end.location + end.length)];
//    start = [newStr rangeOfString:@"["];
//    end = [newStr rangeOfString:@"]"];
//    range.location = start.location;
//    range.length = (end.location - start.location) + end.length;
//    NSString *participants = [newStr substringWithRange:range];
//    NSLog(participants);
    
    _ownersTurn = [ownersTurnString integerValue];
    [self loadFromArray:gameboard_arr owners:owners_arr player1:p1_arr player2:p2_arr deck:deck_arr];
}

-(NSArray*)load1DArrayFromString:(NSString*)string
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSRange range = [string rangeOfString:@"["];
    NSInteger start = range.location + range.length;
    NSInteger end = [string rangeOfString:@","].location;
    while( end > 0 ){
        range.location = start;
        range.length = end - start;
        NSString *value = [string substringWithRange:range];
        
        [array addObject:value];
        string = [string substringFromIndex:end + 1];
        
        start = 0;
        end = [string rangeOfString:@","].location;
        
        if( ![string containsString:@","] ){
            end = -1;
            break;
        }
    }
    
    end = [string rangeOfString:@"]"].location;
    range.location = start;
    range.length = end - start;
    NSString *value = [string substringWithRange:range];
    
    [array addObject:value];
    string = [string substringFromIndex:end + 1];
    
    return array;
}

-(NSArray*)load2DArrayFromString:(NSString*)string
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSMutableArray *row = [[NSMutableArray alloc] init];
    [array addObject:row];
    NSRange range = [string rangeOfString:@"["];
    NSInteger start = range.location + range.length;
    NSInteger end = [string rangeOfString:@","].location;
    while( end > 0 ){
        range.location = start;
        range.length = end - start;
        NSString *value = [string substringWithRange:range];
        
        [row addObject:value];
        string = [string substringFromIndex:end + 1];
        
        if( ![string containsString:@","] ){
            end = -1;
            break;
        }
        
        start = 0;
        end = [string rangeOfString:@","].location;
        
        NSInteger semCol = [string rangeOfString:@";"].location;
        if( semCol < end ){
            range.location = start;
            range.length = semCol - start;
            NSString *value = [string substringWithRange:range];
            
            [row addObject:value];
            string = [string substringFromIndex:semCol + 1];
            
            start = 0;
            end = [string rangeOfString:@","].location;
            
            row = [[NSMutableArray alloc] init];
            [array addObject:row];
        }
    }
    
    end = [string rangeOfString:@"]"].location;
    range.location = start;
    range.length = end - start;
    NSString *value = [string substringWithRange:range];
    
    [row addObject:value];
    string = [string substringFromIndex:end + 1];
    
    return array;
}

-(NSData*)storeToCompatibleData
{
    NSString *dataString = [self storeGameboardToString];
    if( dataString == nil )
        return nil;
    
    NSString *temp = [self storeOwnersToString];
    if( temp == nil )
        return nil;
    dataString = [dataString stringByAppendingString:temp];
    
    temp = [self storeP1CardsToString];
    if( temp == nil )
        return nil;
    dataString = [dataString stringByAppendingString:temp];
    
    temp = [self storeP2CardsToString];
    if( temp == nil )
        return nil;
    dataString = [dataString stringByAppendingString:temp];
    
    temp = [self storeDeckToString];
    if( temp == nil )
        return nil;
    dataString = [dataString stringByAppendingString:temp];
    
    NSString *ownersTurnString = [NSString stringWithFormat:@"(%ld)", (long)_ownersTurn];
    dataString = [dataString stringByAppendingString:ownersTurnString];
    
//    temp = [self storeParticipantsToString];
//    if( temp == nil )
//        return nil;
//    dataString = [dataString stringByAppendingString:temp];

    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

-(NSData*)storeToData
{
    return [self storeToCompatibleData];
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSArray *temp = [self storeGameboardToArray];
//    if( temp == nil )
//        return nil;
//    [array addObject:temp];
//    
//    temp = [self storeOwnersToArray];
//    if( temp == nil )
//        return nil;
//    [array addObject:temp];
//    
//    temp = [self storeP1CardsToArray];
//    if( temp == nil )
//        return nil;
//    [array addObject:temp];
//    
//    temp = [self storeP2CardsToArray];
//    if( temp == nil )
//        return nil;
//    [array addObject:temp];
//
//    if( _deck == nil)
//        return nil;
//    [array addObject:_deck];
//    
//    NSString *ownersTurnString = [NSString stringWithFormat:@"%ld", (long)_ownersTurn];
//    [array addObject:ownersTurnString];
//    
//    if( _participants == nil )
//        return nil;
//    [array addObject:_participants];
//    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    
//    return data;
}

-(void)loadNewGame:(GPGTurnBasedMatch*)match
  localParticipant:(GPGTurnBasedParticipant*)me
{
    _ownersTurn = 1;
    
    _match = match;
    
//    _participants = [[NSMutableArray alloc]init];
//    [_participants addObject:me];
//    [_participants addObject:[self getOpponentFromMatch:match]];
    
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
        [p1 addObject:[NSString stringWithFormat:@"%ld",(long)[self getNextPlayerOption:unshuffled]]];
        [p2 addObject:[NSString stringWithFormat:@"%ld",(long)[self getNextPlayerOption:unshuffled]]];
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
        owner2Cards[column] = (int)value;
    }
    else{
        owner1Cards[column] = (int)value;
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

-(NSString *)storeGameboardToString
{
    NSString *string = @"[";
    for( int i=0; i<[self getSections]; i++ ){
        for( int j=0; j<[self getItems]; j++ ){
            NSInteger val = [self getValueAt:i column:j];
            NSString *str_val;
            if( j == [self getItems] - 1 ){
                str_val = [NSString stringWithFormat:@"%ld",(long)val];
            }
            else{
                str_val = [NSString stringWithFormat:@"%ld,",(long)val];
            }
            string = [string stringByAppendingString:str_val];
        }
        if( i < [self getSections] - 1 ){
            string = [string stringByAppendingString:@";"];
        }
    }
    string = [string stringByAppendingString:@"]"];
    return string;
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

-(NSString *)storeOwnersToString
{
    NSString *string = @"[";
    for( int i=0; i<[self getSections]; i++ ){
        for( int j=0; j<[self getItems]; j++ ){
            NSInteger val = [self getOwnerAt:i column:j];
            NSString *str_val;
            if( j == [self getItems] - 1 ){
                str_val = [NSString stringWithFormat:@"%ld",(long)val];
            }
            else{
                str_val = [NSString stringWithFormat:@"%ld,",(long)val];
            }
            string = [string stringByAppendingString:str_val];
        }
        if( i < [self getSections] - 1 ){
            string = [string stringByAppendingString:@";"];
        }
    }
    string = [string stringByAppendingString:@"]"];
    return string;
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

-(NSString *)storeP1CardsToString
{
    NSString *string = @"[";
    for( int j=0; j<[self getPlayerCards]; j++ ){
        NSInteger val = [self getPlayerOption:j owner:1];
        NSString *str_val;
        if( j == [self getPlayerCards] - 1 ){
            str_val = [NSString stringWithFormat:@"%ld",(long)val];
        }
        else{
            str_val = [NSString stringWithFormat:@"%ld,",(long)val];
        }
        string = [string stringByAppendingString:str_val];
    }
    
    string = [string stringByAppendingString:@"]"];
    return string;
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

-(NSString *)storeP2CardsToString
{
    NSString *string = @"[";
    for( int j=0; j<[self getPlayerCards]; j++ ){
        NSInteger val = [self getPlayerOption:j owner:2];
        NSString *str_val;
        if( j == [self getPlayerCards] - 1 ){
            str_val = [NSString stringWithFormat:@"%ld",(long)val];
        }
        else{
            str_val = [NSString stringWithFormat:@"%ld,",(long)val];
        }
        string = [string stringByAppendingString:str_val];
    }
    
    string = [string stringByAppendingString:@"]"];
    return string;
}

-(NSString *)storeDeckToString
{
    NSString *string = @"[";
    for( int j=0; j<[self.deck count]; j++ ){
        NSString *val = [self.deck objectAtIndex:j];
        if( j < [self.deck count] - 1 ){
            val = [NSString stringWithFormat:@"%@,", val];
        }
        string = [string stringByAppendingString:val];
    }
    
    string = [string stringByAppendingString:@"]"];
    return string;
}

//-(NSString *)storeParticipantsToString
//{
//    NSString *string = @"[";
//    for( int j=0; j<[self.participants count]; j++ ){
//        NSString *val = [self.participants objectAtIndex:j];
//        if( j < [self.participants count] - 1 ){
//            val = [NSString stringWithFormat:@"%@,", val];
//        }
//        string = [string stringByAppendingString:val];
//    }
//    
//    string = [string stringByAppendingString:@"]"];
//    return string;
//}

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
        NSInteger currCol = 0;
        NSInteger currRow = row + column;
        
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
        NSInteger currRow = [self getSections] - 1;
        NSInteger currCol = column - ([self getSections] - 1 - row);
        
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
