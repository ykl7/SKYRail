//
//  BaseSearchTableViewController.m
//  SKYRail
//
//  Created by YASH on 12/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "BaseSearchTableViewController.h"
#import "TrainNameSearchTableViewController.h"
#import "BetweenTwoStationsTableViewController.h"

@interface BaseSearchTableViewController ()
{
    NSMutableArray *trainSearchResults;
    
    NSInteger startPid;
    NSInteger endPid;
}

@end

@implementation BaseSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nameSearch"])
    {
        TrainNameSearchTableViewController *tnstvc = [segue destinationViewController];
        tnstvc.trainName = _trainNameTextField.text;
    }
    else if ([segue.identifier isEqualToString:@"stationSearch"])
    {
        @try
        {
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id FROM Platform WHERE Platform_Name like ',%@,'", _boardingTextField.text];
            NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
            
            startPid = [[[results firstObject] objectForKey:@"Platform_Id"] integerValue];
            
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
            @try
            {
                
                NSError *error;
                
                NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id FROM Platform WHERE Platform_Name like ',%@,'", _alightingTextField.text];
                NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
                
                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
                
                endPid = [[[results firstObject] objectForKey:@"Platform_Id"] integerValue];
                
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
                
            }
        }
        BetweenTwoStationsTableViewController *btstvc = [segue destinationViewController];
        btstvc.startPid = startPid;
        btstvc.endPid = endPid;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.boardingTextField)
        [self.boardingTextField becomeFirstResponder];
    if (textField == self.alightingTextField)
        [self.alightingTextField becomeFirstResponder];
    if (textField == self.trainNameTextField)
        [self.trainNameTextField becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.boardingTextField resignFirstResponder];
    [self.alightingTextField resignFirstResponder];
    [self.trainNameTextField resignFirstResponder];
}
@end
