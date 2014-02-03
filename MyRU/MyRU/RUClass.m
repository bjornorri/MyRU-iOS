//
//  RUClass.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 03/02/14.
//  Copyright (c) 2014 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUClass.h"

@implementation RUClass

- (id)init
{
    self = [super init];
    if (self)
    {
        self.teachers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (bool)isOver
{
    NSArray* time = [[self endTime] componentsSeparatedByString:@":"];
    
    int hour = [time[0] intValue];
    int minute = [time[1] intValue];
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [components setHour: hour];
    [components setMinute: minute];
    [components setSecond: 0];
    NSDate* endDate = [myCalendar dateFromComponents:components];
    
    if([endDate timeIntervalSinceNow] < 0.0)
    {
        return YES;
    }
    return NO;
}

@end
