//
//  BetweenTwoStationsTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "BetweenTwoStationsTableViewController.h"
#import "ScheduleTableViewController.h"

@interface BetweenTwoStationsTableViewController ()
{
    NSMutableArray *initialResult;
    NSMutableArray *trainNames;
}

@end

@implementation BetweenTwoStationsTableViewController

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
    NSLog(@"start %li end %li", _startPid, _endPid);
    initialResult = [NSMutableArray new];
    trainNames = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT train_id FROM visits WHERE platform_id = %li INTERSECT SELECT train_id FROM visits WHERE platform_id = %li", _startPid, _endPid];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            NSLog(@"results %@", results);
            initialResult = [NSMutableArray arrayWithArray:results];
            if (error) {
                SVHUD_FAILURE(error.localizedDescription);
                return;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Fetch error: %@", exception.reason);
        }
        @finally {
            @try {
                for (int i=0; i<initialResult.count; i++)
                {
                    NSError *err;
                    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Train WHERE train_id = %li", [[[initialResult objectAtIndex:i] objectForKey:@"train_id"] integerValue]];
                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&err];
                    NSLog(@"results %@", results);
                    [trainNames addObjectsFromArray:results];
                    NSLog(@"train names %@ %li", [[trainNames objectAtIndex:i] objectForKey:@"Train_name"], [[[trainNames objectAtIndex:i] objectForKey:@"Train_ID"] integerValue]);
                    if (err)
                    {
                        SVHUD_FAILURE(err.localizedDescription);
                        return;
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@"Fetch error: %@", exception.reason);
            } @finally {
                @try {
                    
                } @catch (NSException *exception) {
                    NSLog(@"Fetch error: %@", exception.reason);
                } @finally {
                    
                }
            }
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
    return [trainNames count];
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
    cell.textLabel.text = [NSString stringWithFormat:@"Train Name %@", [[trainNames objectAtIndex:indexPath.row] objectForKey:@"Train_name"]];
    cell.detailTextLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleNavVC"];
    ScheduleTableViewController *stvc = [navVC viewControllers][0];
    stvc.trainId = [[[trainNames objectAtIndex:indexPath.row] objectForKey:@"Train_ID"] integerValue];
    [self presentViewController:navVC animated:YES completion:nil];
}
@end
