//
//  TicketDetailsTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "TicketDetailsTableViewController.h"

@interface TicketDetailsTableViewController ()
{
    NSMutableArray *tickets;
    NSMutableArray *persons;
    
    NSString *startPlatform;
    NSString *endPlatform;
}

@end

@implementation TicketDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Ticket";
    
}

- (IBAction)backToLast:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    User *user = [User currentUser];
    persons = [NSMutableArray new];
    tickets = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Tickets WHERE PNR = %@", _pnr];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            
            tickets = [Tickets returnArrayFromJSONStructure:results];
            
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
                
                NSError *error;
                
                NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_Name FROM Platform WHERE Platform_id = %li", [[tickets objectAtIndex:0] startPid]];
                
                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                
                startPlatform = [results firstObject];
            
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
                    
                    NSError *error;
                    
                    NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_Name FROM Platform WHERE Platform_id = %li", [[tickets objectAtIndex:0] endPid]];
                    
                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                    
                    endPlatform = [results firstObject];
                    
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
                        NSError *error;
                        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Person WHERE email = %@", user.email];
                        NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                        persons = [Person returnArrayFromJSONStructure:results];
                        if (error)
                        {
                            SVHUD_FAILURE(error.localizedDescription);
                            return;
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Fetch error: %@", exception.reason);
                    }
                    @finally {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SVHUD_HIDE;
                            _pnrLabel.text = [NSString stringWithFormat:@"PNR : %@", [[tickets objectAtIndex:0] PNR]];
                            _trainNoLabel.text = [NSString stringWithFormat:@"Train No : %li", [[tickets objectAtIndex:0] trainId]];
                            _trainNameLabel.text = [NSString stringWithFormat:@"%@", [[tickets objectAtIndex:0] trainName]];
                            _toLabel.text = [NSString stringWithFormat:@"To : %li", [[tickets objectAtIndex:0] startPid]];
                            _fromLabel.text = [NSString stringWithFormat:@"From : %li", [[tickets objectAtIndex:0] endPid]];
                            _dojLabel.text = [NSString stringWithFormat:@"On : %@", [[tickets objectAtIndex:0] dateOfJourney]];
                            _costLabel.text = [NSString stringWithFormat:@"Cost : %li", [[tickets objectAtIndex:0] costOfTicket]];
                        });
                    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        @try {
            
            NSError *error;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/mm/yyyy"];
            
            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
            
            NSString *queryString = [NSString stringWithFormat:@"INSERT INTO CancelledTickets (PNR, Train_ID, Journey_Distance, Date_Of_Journey, Startp_ID, Endp_ID, Deletion_Time, Person_ID) VALUES (%li, %li, %@, '%@', %li, %li, '%@', %li);", (long) [[tickets objectAtIndex:0] PNR], (long) [[tickets objectAtIndex:0] trainId], [[tickets objectAtIndex:0] distance], [[tickets objectAtIndex:0] dateOfJourney], (long) [[tickets objectAtIndex:0] startPid], (long) [[tickets objectAtIndex:0] endPid], stringFromDate, (long) [[persons objectAtIndex:0] personId]];
            
            if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
            {
                // Failed
                NSLog(@"Failed %@", error.localizedDescription);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Fetch error: %@", exception.reason);
        }
        @finally {
            @try {
                NSError *error;
                NSString *queryString = [NSString stringWithFormat:@"DELETE FROM Tickets WHERE PNR = %@", _pnr];
                if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
                {
                    // Failed
                    NSLog(@"Failed %@", error.localizedDescription);
                }
            } @catch (NSException *exception) {
                NSLog(@"Fetch error: %@", exception.reason);
            } @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SVHUD_HIDE;
                });
            }
        }

    [self dismissViewControllerAnimated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
