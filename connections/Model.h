//
//  Model.h
//  connections
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlayGames/GooglePlayGames.h>

@interface Model : NSObject

@property (strong, nonatomic) NSMutableArray *deck;
@property (strong, nonatomic) NSMutableArray *participants;
@property (nonatomic) NSInteger ownersTurn;

-(NSInteger)getSections;
-(NSInteger)getItems;

+(GPGTurnBasedParticipant*)getOpponent:(GPGTurnBasedMatch*)match;
+(NSString*)getOpponentDisplayName:(GPGTurnBasedMatch*)match;

-(void)loadNewGame:(GPGTurnBasedMatch*)match
  localParticipant:(GPGTurnBasedParticipant*)me;

-(Boolean)checkForWinner:(NSInteger)owner
                     row:(NSInteger)row
                  column:(NSInteger)column;
-(NSInteger)getValueAt:(NSInteger)row
                column:(NSInteger)column;
-(NSInteger)getOwnerAt:(NSInteger)row
                column:(NSInteger)column;
-(void)setOwnerAt:(NSInteger)owner
              row:(NSInteger)row
           column:(NSInteger)column;

-(NSInteger)getPlayerOption:(NSInteger)column
                      owner:(NSInteger)owner;
-(NSInteger)newPlayerOption:(NSInteger)column
                      owner:(NSInteger)owner;

-(NSData*)storeToData;
-(void)loadFromData:(NSData*)data;

@end
