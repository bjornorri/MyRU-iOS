//
//  RUGrade.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 10/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUGrade : NSObject

@property(nonatomic, copy)NSString* assignmentName;
@property(nonatomic, copy)NSString* grade;
@property(nonatomic, copy)NSString* order;
@property(nonatomic, copy)NSString* feedback;
@property(nonatomic, copy)NSString* inCourse;

-(NSString*)getCourse;
-(NSString*)getRank;
-(NSString*)getGrade;

@end
