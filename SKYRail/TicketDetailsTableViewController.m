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
    NSString *trainName;
    
    NSInteger costHere;
    NSInteger personNow;
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
        
        @try
        {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Tickets WHERE PNR = %@", _pnr];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            
            tickets = [Tickets returnArrayFromJSONStructure:results];
            NSLog(@"ticket %li", [[tickets firstObject] costOfTicket]);
            costHere = [[tickets firstObject] costOfTicket];
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
            
            @try {
                
                NSError *error;
                
                NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_Name FROM Platform WHERE Platform_id = %li", [[tickets objectAtIndex:0] startPid]];
                
                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                
                startPlatform = [[results firstObject] objectForKey:@"Platform_Name"];
            
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
                    
                    endPlatform = [[results firstObject] objectForKey:@"Platform_Name"];
                    
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
                        for (Person *p in persons)
                        {
                            if ([p.email isEqualToString:user.email])
                            {
                                personNow = p.personId;
                                break;
                            }
                        }
                        NSLog(@"person id now %li", personNow);
                        if (error)
                        {
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
                        @try
                        {
                            
                            NSError *error;
                            
                            NSString *queryString = [NSString stringWithFormat:@"SELECT Train_Name FROM Train WHERE Train_id = %li", [[tickets firstObject] trainId]];
                            
                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                            
                            trainName = [[results firstObject] objectForKey:@"Train_name"];
                            NSLog(@"train name here %@", trainName);
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
                                _pnrLabel.text = [NSString stringWithFormat:@"PNR : %@", [[tickets firstObject] PNR]];
                                _trainNoLabel.text = [NSString stringWithFormat:@"Train No : %li", [[tickets firstObject] trainId]];
                                _trainNameLabel.text = [NSString stringWithFormat:@"Train : %@", trainName];
                                _toLabel.text = [NSString stringWithFormat:@"To : %@", endPlatform];
                                _fromLabel.text = [NSString stringWithFormat:@"From : %@", startPlatform];
                                _dojLabel.text = [NSString stringWithFormat:@"On : %@", [[tickets firstObject] dateOfJourney]];
                                _costLabel.text = [NSString stringWithFormat:@"Cost : %li", costHere];
                                [self.tableView reloadData];
                            });
                        }
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
            [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
            
            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
            NSLog(@"person id in cancel process %li", personNow);
            NSString *queryString = [NSString stringWithFormat:@"INSERT INTO CancelledTickets (PNR, Train_ID, Journey_Distance, Date_Of_Journey, Startp_ID, Endp_ID, Deletion_Time, Person_ID) VALUES (%li, %li, %@, '%@', %li, %li, '%@', %li);", [[[tickets firstObject] PNR] integerValue], [[tickets firstObject] trainId], [[tickets firstObject] distance], [[tickets firstObject] dateOfJourney], [[tickets firstObject] startPid], [[tickets firstObject] endPid], stringFromDate, _personId];
            NSLog(@"cancel query %@", queryString);
            if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
            {
                // Failed
                NSLog(@"Failed %@", error.localizedDescription);
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
                NSString *queryString = [NSString stringWithFormat:@"DELETE FROM Tickets WHERE PNR = %@", _pnr];
                if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
                {
                    // Failed
                    NSLog(@"Failed %@", error.localizedDescription);
                }
                
            }
            @catch (NSException *exception)
            {
                NSLog(@"Fetch error: %@", exception.reason);
            }
            @finally
            {
                NSError *error;
                NSString *queryString = [NSString stringWithFormat:@"DELETE FROM Booking_History WHERE PNR = %@", _pnr];
                if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
                {
                    // Failed
                    NSLog(@"Failed %@", error.localizedDescription);
                }
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
