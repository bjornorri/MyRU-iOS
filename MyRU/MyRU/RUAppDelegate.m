//
//  RUAppDelegate.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 07/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUAppDelegate.h"
#import "RUData.h"
#import "RUTabBarController.h"
#import "RUCustomURLProtocol.h"

@implementation RUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [NSURLProtocol registerClass:[RUCustomURLProtocol class]];
    
    // NSUserDefaults
    // initialize defaults
    NSString *dateKey    = @"dateKey";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        // do any other initialization you want to do here - e.g. the starting default values.
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Authentication"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //[[RUData sharedData] setAuthentication:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // Reload the data when re-opening the app
    if([[RUData sharedData] userIsLoggedIn])
    {
        // Refetch the page, parse it and load the new data into all table view controllers.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            [[RUData sharedData] refreshData];
           
           dispatch_async( dispatch_get_main_queue(), ^
          {
              UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              RUTabBarController* tabBarController = [storyboard instantiateInitialViewController];
              [tabBarController reloadDataInAllTableViewControllers];
          });
       });
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
