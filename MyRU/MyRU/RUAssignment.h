//
//  RUAssignment.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 10/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUAssignment : NSObject

@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* courseName;
@property(nonatomic, copy)NSString* courseId;
@property(nonatomic, copy)NSString* handedIn;
@property(nonatomic, copy)NSString* dueDate;
@property(nonatomic, copy)NSString* assignmentURL;

@end
