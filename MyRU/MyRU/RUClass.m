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

@end
