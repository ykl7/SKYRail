//
//  CancelledTicketDetailsTableViewController.m
//  SKYRail
//
//  Created by YASH on 21/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "CancelledTicketDetailsTableViewController.h"

@interface CancelledTicketDetailsTableViewController ()
{
    NSMutableArray *cancelledTickets;
}

@end

@implementation CancelledTicketDetailsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    SVHUD_SHOW;
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM CancelledTickets WHERE PNR = %@;", _pnr];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            cancelledTickets = [CancelledTickets returnArrayFromJSONStructure:results];
            
            if (error) {
                SVHUD_FAILURE(error.localizedDescription);
                return;
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"Fetch error: %@", exception.reason);
        }
        @finally
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                SVHUD_HIDE;
                _deletionLabel.text = [NSString stringWithFormat:@"Cancellation Date : %@", [[cancelledTickets firstObject] cancelTime]];
                _pnrLabel.text = [NSString stringWithFormat:@"PNR : %li", [[[cancelledTickets firstObject] PNR] integerValue]];
                _distanceLabel.text = [NSString stringWithFormat:@"Distance : %@ km", [[cancelledTickets firstObject] distance]];
                _dateLabel.text = [NSString stringWithFormat:@"Ticket Date : %@", [[cancelledTickets firstObject] dateOfJourney]];
                _trainIdLabel.text = [NSString stringWithFormat:@"Train ID : %li", [[cancelledTickets firstObject] trainId]];
                [self.tableView reloadData];
            });
        }
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToList:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
