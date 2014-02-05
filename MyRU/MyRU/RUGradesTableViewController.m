//
//  RUGradesTableViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 12/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUGradesTableViewController.h"
#import "RuGrade.h"
#import "RUGradeCell.h"
#import "RUData.h"
#import "RUTabBarController.h"
#import "RUGradeViewController.h"

@interface RUGradesTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation RUGradesTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.refreshControl setTintColor:[UIColor grayColor]];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}

// Fetch the page again, parse and load into the table view.
- (void)reloadData
{   
    [[RUData sharedData] refreshData];
    [(RUTabBarController*)[self tabBarController] reloadDataInAllTableViewControllers];
    [self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = (int)[[[RUData sharedData] getGrades] count];
    
    if(sections == 0)
    {
        [[self emptyLabel] setHidden:NO];
    }
    else
    {
        [[self emptyLabel] setHidden:YES];
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[RUData sharedData] getGrades] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUGradeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RUGradeCell"];
    NSArray* gradesInCourse = [[[RUData sharedData] getGrades] objectAtIndex:[indexPath section]];
    RUGrade* grade = [gradesInCourse objectAtIndex:[indexPath row]];
    
    [cell setGrade:grade];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray* array = [[[RUData sharedData] getGrades] objectAtIndex:section];
    if(array.count > 0){
        return [[array objectAtIndex:0] getCourse];
    }
    return @"??";
}


- (IBAction)didPushLogoutButton:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [(RUTabBarController*)[self tabBarController] logOut];
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, self.view.frame.size.width, 30)];
    NSString* title = [self tableView:self.tableView titleForHeaderInSection:section];
    [label setText:title];
    [label setBackgroundColor:[UIColor whiteColor]];
    
    UIFont* labelFont = [UIFont boldSystemFontOfSize:17.0];
    [label setFont:labelFont];
    UIView* redLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    [redLine setBackgroundColor:[UIColor redColor]];
    [view addSubview:label];
    [view addSubview:redLine];
    return view;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RUGradeViewController* destination = [segue destinationViewController];
    NSIndexPath* indexPath = [[self tableView] indexPathForCell:sender];
    NSArray* gradesInCourse = [[[RUData sharedData] getGrades] objectAtIndex:[indexPath section]];
    [destination setGrade:[gradesInCourse objectAtIndex:[indexPath row]]];
}

@end
