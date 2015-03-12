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
-(NSInteger)getIntValueAt:(NSInteger)row
                   column:(NSInteger)column;
-(NSInteger)getPlayerOption:(NSInteger)num;

@end
