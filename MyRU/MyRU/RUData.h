//
//  RUData.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 09/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUData : NSObject

+ (id)sharedData;
- (bool)userIsLoggedIn;
- (void)setAuthentication:(NSString *)string;
- (int)refreshData;
- (NSArray*)getAssignments;
- (NSArray*)getGrades;
- (void)clearData;

@end
