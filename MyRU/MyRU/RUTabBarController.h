//
//  RUTabBarController.h
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 11/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUTabBarController : UITabBarController

- (void)reloadDataInAllTableViewControllers;
- (void)logOut;

@end
