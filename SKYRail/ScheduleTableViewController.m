//
//  ScheduleTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "ScheduleTableViewController.h"

@interface ScheduleTableViewController ()
{
    NSMutableArray *completeSet;
    NSMutableArray *pidSet;
    NSMutableArray *platformNames;
}

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"train id %li", _trainId);
    completeSet = [NSMutableArray new];
    pidSet = [NSMutableArray new];
    platformNames = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Visits WHERE Train_id = %li", _trainId];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            completeSet = [Visits returnArrayFromJSONStructure:results];
            
            if (error) {
                SVHUD_FAILURE(error.localizedDescription);
                return;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Fetch error: %@", exception.reason);
        }
        @finally
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [completeSet count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    // method being called before platforms array is fully populated
    cell.textLabel.text = @"";
    @try {
        
        NSError *error;
        
        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Platform WHERE Platform_Id = %li", [[completeSet objectAtIndex:indexPath.row] platformId]];
        
        NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
        NSDictionary *temp = [results firstObject];
        
        if (temp) {
            cell.textLabel.text = [NSString stringWithFormat:@"Platform %@", [temp objectForKey:@"Platform_Name"]];
        }
        
        if (error) {
            SVHUD_FAILURE(error.localizedDescription);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Fetch error: %@", exception.reason);
    }
    @finally {
        
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Arrival %@, Departure %@", [[completeSet objectAtIndex:indexPath.row] arrTime], [[completeSet objectAtIndex:indexPath.row] depTime]];
    
    return cell;
}

- (IBAction)backToSearchOption:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
