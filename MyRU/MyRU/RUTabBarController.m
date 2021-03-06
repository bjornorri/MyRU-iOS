//
//  RUTabBarController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 11/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUTabBarController.h"
#import "RUData.h"

@interface RUTabBarController ()

@end

@implementation RUTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if([[RUData sharedData] userIsLoggedIn])
    {
        [[RUData sharedData] refreshData];
        
        // Set listener for foreground entering
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        
        // Set listener for time changes (a new day for example)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred:) name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
}

// This executes when the app enters the foreground
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self reloadDataInAllTableViewControllers];
}

// Fetch data again on a new day (important for timetable)
- (void)significantTimeChangeOccurred:(NSNotification*)notification
{
    NSLog(@"Significant time  change occurred!");
    
    if([[RUData sharedData] userIsLoggedIn])
    {
        [[RUData sharedData] refreshData];
        [self reloadDataInAllTableViewControllers];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(![[RUData sharedData] userIsLoggedIn])
    {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else
    {
        [super viewDidAppear:animated];
        [self reloadDataInAllTableViewControllers];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadDataInAllTableViewControllers
{
    for(UIViewController* viewController in [self viewControllers])
    {
        if([viewController isKindOfClass:[UINavigationController class]])
        {
            for(UIViewController* childController in [viewController childViewControllers])
            {
                if([childController isKindOfClass:[UITableViewController class]])
                {
                    NSLog(@"Reloading table view controller");
                    [[(UITableViewController*)childController tableView] reloadData];
                }
            }
        }
    }
}

- (IBAction)unwindLoginSegue:(UIStoryboardSegue *)segue
{
    
}

- (void)logOut
{
    [[RUData sharedData] clearData];
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
    [self reloadDataInAllTableViewControllers];
    [self setSelectedIndex:0];
}

@end
