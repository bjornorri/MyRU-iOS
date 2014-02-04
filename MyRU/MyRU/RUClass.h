//
//  RUClass.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 03/02/14.
//  Copyright (c) 2014 Björn Orri Sæmundsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUClass : NSObject

@property(nonatomic, copy) NSString* course;
@property(strong, nonatomic) NSMutableArray* teachers;
@property(nonatomic, copy) NSString* type;
@property(nonatomic, copy) NSString* location;
@property(nonatomic, copy) NSString* startString;
@property(nonatomic, copy) NSString* endString;
@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;


-(bool)isOver;
-(bool)isNow;

@end
