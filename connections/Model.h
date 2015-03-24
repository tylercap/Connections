//
//  Model.h
//  connections
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Model : NSObject

@property (strong, nonatomic)NSMutableArray *deck;

-(NSInteger)getSections;
-(NSInteger)getItems;

-(void)loadNewGame;
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

@end
