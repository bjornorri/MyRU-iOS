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

@interface RUGradesTableViewController ()

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
    return [[[RUData sharedData] getGrades] count];
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


/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
