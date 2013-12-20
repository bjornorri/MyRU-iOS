//
//  RUAssignmentTableViewController.m
//  MyRU
//
//  Created by Björn Orri Sæmundsson on 13/12/13.
//  Copyright (c) 2013 Björn Orri Sæmundsson. All rights reserved.
//

#import "RUAssignmentTableViewController.h"
#import "RUData.h"
#import "RUTabBarController.h"
#import "RUAssignmentCell.h"
#import "RUAssignment.h"
#import "RUAssignmentViewController.h"


@interface RUAssignmentTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation RUAssignmentTableViewController

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
    
    
    // This hides the section header. Remove if grouped style table view is not used.
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fetch the page again, parse and reload the data in all table views.
- (void)reloadData
{
    [[RUData sharedData] refreshData];
    [(RUTabBarController*)[self tabBarController] reloadDataInAllTableViewControllers];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = (int)[[[RUData sharedData] getAssignments] count];
    
    if(rows == 0)
    {
        [[self emptyLabel] setHidden:NO];
    }
    else
    {
        [[self emptyLabel] setHidden:YES];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUAssignmentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RUAssignmentCell"];
    RUAssignment* assignment = [[[RUData sharedData] getAssignments] objectAtIndex:[indexPath row]];
    [cell setAssignment:assignment];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // This is hidden under the navigation bar in viewDidLoad.
    return 1.0f;
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    RUAssignmentViewController* destination = [segue destinationViewController];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    [destination setAssignment:[[[RUData sharedData] getAssignments] objectAtIndex:[indexPath row]]];
}

@end
