//
//  TrainNameSearchTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "TrainNameSearchTableViewController.h"
#import "ScheduleTableViewController.h"

@interface TrainNameSearchTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    NSMutableArray *trainSearchResults;
    NSMutableArray *startPidResults;
    NSMutableArray *endPidResults;
}

@end

@implementation TrainNameSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    trainSearchResults = [NSMutableArray new];
    startPidResults = [NSMutableArray new];
    endPidResults = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try
        {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Train WHERE Train_Name like ',%@,'", _trainName];
            NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
            
            trainSearchResults = [Train returnArrayFromJSONStructure:results];
            NSLog(@"train search results %@", trainSearchResults);
            
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
                SVHUD_HIDE;
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
    return [trainSearchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[trainSearchResults objectAtIndex:indexPath.row] trainName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleNavVC"];
    ScheduleTableViewController *stvc = [navVC viewControllers][0];
    stvc.trainId = [[trainSearchResults objectAtIndex:indexPath.row] trainId];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - DZN Empty Data Set Source

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"NO ROWS LOADED";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:18.f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return (trainSearchResults.count == 0);
}

@end
