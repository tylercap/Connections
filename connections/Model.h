//
//  Model.h
//  connections
//
//  Created by Tyler Cap on 3/10/15.
//  Copyright (c) 2015 Tyler Cap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Model : NSObject

-(NSInteger)getSections;
-(NSInteger)getItems;

-(void)loadNewGame;
-(NSInteger)getIntValueAt:(NSInteger)row
                   column:(NSInteger)column;

@end
