//
//  BookTicketTableViewController.m
//  SKYRail
//
//  Created by YASH on 12/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "BookTicketTableViewController.h"
#import "TicketDetailsTableViewController.h"

@interface BookTicketTableViewController ()
{
    NSInteger availablity;
    NSInteger numberOfTickets;
    NSInteger startPid;
    NSInteger endPid;
    NSInteger startXcoord;
    NSInteger startYcoord;
    NSInteger endXcoord;
    NSInteger endYcoord;
    NSInteger distanceToTravel;
    NSInteger costIncurred;
    
    NSMutableArray *initialResult;
    NSMutableArray *trainNames;
    NSMutableArray *tickets;
    NSMutableArray *trainSearchResults;
    NSMutableArray *seatsGone;
    NSMutableArray *pricingResults;
    NSMutableArray *persons;
    NSMutableArray *bookings;
    
    User *user;
}

@end

@implementation BookTicketTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    user = [User currentUser];
    bookings = [NSMutableArray new];
    initialResult = [NSMutableArray new];
    trainNames = [NSMutableArray new];
    tickets = [NSMutableArray new];
    trainSearchResults = [NSMutableArray new];
    seatsGone = [NSMutableArray new];
    pricingResults = [NSMutableArray new];
    persons = [NSMutableArray new];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @try
//        {
//            NSError *error;
//            
//            NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id, Xcoord, YCoord FROM Platform WHERE Platform_Name like ',%@,'", _boardingStationTextField.text];
//            NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
//            
//            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
//            NSLog(@"START RESULTS %@", results);
//            
//            startPid = [[[results firstObject] objectForKey:@"Platform_Id"] integerValue];
//            startXcoord = [[[results firstObject] objectForKey:@"Xcoord"] integerValue];
//            startYcoord = [[[results firstObject] objectForKey:@"YCoord"] integerValue];
//            
//            if (error) {
//                SVHUD_FAILURE(error.localizedDescription);
//                return;
//            }
//        }
//        @catch (NSException *exception)
//        {
//            NSLog(@"Fetch error: %@", exception.reason);
//        }
//        @finally
//        {
//            @try
//            {
//                
//                NSError *error;
//                
//                NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id, Xcoord, YCoord FROM Platform WHERE Platform_Name like ',%@,'", _alightingStationTextField.text];
//                NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
//                
//                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
//                NSLog(@"END RESULTS %@", results);
//                
//                endPid = [[[results firstObject] objectForKey:@"Platform_Id"] integerValue];
//                endXcoord = [[[results firstObject] objectForKey:@"Xcoord"] integerValue];
//                endYcoord = [[[results firstObject] objectForKey:@"YCoord"] integerValue];
//                
//                distanceToTravel = sqrt(((endXcoord-startXcoord)^2) + ((endYcoord-startYcoord)));
//                
//                if (error)
//                {
//                    SVHUD_FAILURE(error.localizedDescription);
//                    return;
//                }
//            }
//            @catch (NSException *exception)
//            {
//                NSLog(@"Fetch error: %@", exception.reason);
//            }
//            @finally
//            {
//                @try
//                {
//                    
//                    NSError *error;
//                    
//                    NSString *queryString = [NSString stringWithFormat:@"SELECT train_id FROM visits WHERE platform_id = %li INTERSECT SELECT train_id FROM visits WHERE platform_id = %li", startPid, endPid];
//                    
//                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
//                    NSLog(@"results %@", results);
//                    initialResult = [NSMutableArray arrayWithArray:results];
//                    if (error)
//                    {
//                        SVHUD_FAILURE(error.localizedDescription);
//                        return;
//                    }
//                }
//                @catch (NSException *exception)
//                {
//                    NSLog(@"Fetch error: %@", exception.reason);
//                }
//                @finally
//                {
//                    @try
//                    {
//                        for (int i=0; i<initialResult.count; i++)
//                        {
//                            NSError *err;
//                            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Train WHERE train_id = %li", [[[initialResult objectAtIndex:i] objectForKey:@"train_id"] integerValue]];
//                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&err];
//                            NSLog(@"results %@", results);
//                            [trainNames addObjectsFromArray:results];
//                            NSLog(@"train names %@ %li", [[trainNames objectAtIndex:i] objectForKey:@"Train_name"], [[[trainNames objectAtIndex:i] objectForKey:@"Train_ID"] integerValue]);
//                            if (err)
//                            {
//                                SVHUD_FAILURE(err.localizedDescription);
//                                return;
//                            }
//                        }
//                    }
//                    @catch (NSException *exception)
//                    {
//                        NSLog(@"Fetch error: %@", exception.reason);
//                    }
//                    @finally
//                    {
//                        @try {
//                            NSError *error;
//                            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Pricing WHERE Train_ID = %li", [[[trainNames firstObject] objectForKey:@"Train_ID"] integerValue]];
//                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
//                            pricingResults = [Pricing returnArrayFromJSONStructure:results];
//                            costIncurred = [[[pricingResults firstObject] baseFare] integerValue] * (distanceToTravel * [[pricingResults firstObject] integerValue]);
//                            if (error)
//                            {
//                                SVHUD_FAILURE(error.localizedDescription);
//                                return;
//                            }
//                        }
//                        @catch (NSException *exception)
//                        {
//                            NSLog(@"Fetch error: %@", exception.reason);
//                        }
//                        @finally
//                        {
//                            NSError *error;
//                            NSString *queryString = [NSString stringWithFormat:@"SELECT * from Person WHERE email = '%@'", user.email];
//                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
//                            persons = [Person returnArrayFromJSONStructure:results];
//                        }
//                    }
//                }
//            }
//        }
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    tickets = [NSMutableArray new];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3)
    {
        @try
        {
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id, Xcoord, YCoord FROM Platform WHERE Platform_Name like ',%@,'", _boardingStationTextField.text];
            NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
            
            // figure out the right keys here, rest done
            startPid = [[[results firstObject] objectForKey:@"Platform_id"] integerValue];
            startXcoord = [[[results firstObject] objectForKey:@"Xcoord"] integerValue];
            startYcoord = [[[results firstObject] objectForKey:@"YCoord"] integerValue];
            
            NSLog(@"START RESULTS id %li x %li y %li", startPid, startXcoord, startYcoord);
            
            
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
            @try
            {
                
                NSError *error;
                
                NSString *queryString = [NSString stringWithFormat:@"SELECT Platform_id, Xcoord, YCoord FROM Platform WHERE Platform_Name like ',%@,'", _alightingStationTextField.text];
                NSString *actualQuery = [queryString stringByReplacingOccurrencesOfString:@"," withString:@"%"];
                
                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:actualQuery error:&error];
                
                // figure out the right keys here, rest done
                endPid = [[[results firstObject] objectForKey:@"Platform_id"] integerValue];
                endXcoord = [[[results firstObject] objectForKey:@"Xcoord"] integerValue];
                endYcoord = [[[results firstObject] objectForKey:@"YCoord"] integerValue];
                
                NSLog(@"END RESULTS id %li x %li y %li", endPid, endXcoord, endYcoord);
                
                distanceToTravel = (sqrt(((endXcoord-startXcoord)^2) + ((endYcoord-startYcoord)))) * 100;
                NSLog(@"DISTANCE %li", distanceToTravel);
                
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
                    
                    NSString *queryString = [NSString stringWithFormat:@"SELECT train_id FROM visits WHERE platform_id = %li INTERSECT SELECT train_id FROM visits WHERE platform_id = %li", startPid, endPid];
                    NSLog(@"FIRST QUERY %@", queryString);
                    
                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                    NSLog(@"results %@", results);
                    initialResult = [NSMutableArray arrayWithArray:results];
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
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"Fetch error: %@", exception.reason);
                    }
                    @finally
                    {
                        @try {
                            NSError *error;
                            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Pricing WHERE Train_ID = %li", [[[trainNames firstObject] objectForKey:@"Train_ID"] integerValue]];
                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                            pricingResults = [Pricing returnArrayFromJSONStructure:results];
                            costIncurred = [[[pricingResults firstObject] baseFare] integerValue] * (distanceToTravel * [[pricingResults firstObject] integerValue]);
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
                            NSError *error;
                            NSString *queryString = [NSString stringWithFormat:@"SELECT * from Person WHERE email = '%@'", user.email];
                            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                            persons = [Person returnArrayFromJSONStructure:results];
                            @try {
                                NSError *error;
                                
                                NSString *queryString = [NSString stringWithFormat:@"SELECT sum(Seats) FROM Tickets WHERE date_of_journey = '%@' AND train_id IN (SELECT train_id FROM train WHERE train_name = '%@'", _dateOfJourneryTextField.text, [[trainNames firstObject] objectForKey:@"Train_name"]];
                                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                                [seatsGone addObjectsFromArray:results];
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
                                if (([[trainNames firstObject] capacity] - [[seatsGone firstObject] integerValue]) > [_numberOfSeatsTextField.text integerValue])
                                {
                                    // book here
                                    NSString *queryString = [NSString stringWithFormat:@"INSERT INTO Tickets (Train_ID, Journey_Distance, Date_Of_Journey, Startp_ID, Endp_ID, Person_ID, Cost) VALUES (%li, %li, '%@', %li, %li, %li, %li)", [[[trainNames firstObject] objectForKey:@"Train_ID"] integerValue], distanceToTravel, [[trainNames firstObject] objectForKey:@"date_of_journey"], startPid, endPid, [[persons firstObject] personId], costIncurred];
                                    NSError *error;
                                    if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
                                    {
                                        // Failed
                                        NSLog(@"Failed %@", error.localizedDescription);
                                    }
                                    @try
                                    {
                                        NSError *error;
                                        
                                        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Tickets"];
                                        NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                                        bookings = [Tickets returnArrayFromJSONStructure:results];
                                        if (error)
                                        {
                                            SVHUD_FAILURE(error.localizedDescription);
                                            return;
                                        }
                                    } @catch (NSException *exception)
                                    {
                                        NSLog(@"Fetch error: %@", exception.reason);
                                    }
                                    @finally
                                    {
                                        NSString *queryString = [NSString stringWithFormat:@"INSERT INTO Booking_History (Person_id, PNR) VALUES (%li, %li)", [[persons firstObject] personId], [[[bookings firstObject] PNR] integerValue]];
                                        NSError *error;
                                        if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
                                        {
                                            // Failed
                                            NSLog(@"Failed %@", error.localizedDescription);
                                        }
                                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailsNavVC"];
                                        TicketDetailsTableViewController *tdtvc = [navVC viewControllers][0];
                                        tdtvc.pnr = [[bookings firstObject] PNR];
                                        [self presentViewController:navVC animated:YES completion:nil];
                                    }
                                }
                                else
                                {
                                    UIAlertView *noSeatsAlert = [[UIAlertView alloc] initWithTitle:@"Seats Unavailable" message:@"The requested number of seats is not free at the moment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [noSeatsAlert show];
                                }
                            }

                        }
                    }
                }
            }
        }

//        @try {
//            NSError *error;
//            
//            NSString *queryString = [NSString stringWithFormat:@"SELECT sum(Seats) FROM Tickets WHERE date_of_journey = '%@' AND train_id IN (SELECT train_id FROM train WHERE train_name = '%@'", _dateOfJourneryTextField.text, [[trainNames firstObject] objectForKey:@"Train_name"]];
//            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
//            [seatsGone addObjectsFromArray:results];
//            if (error)
//            {
//                SVHUD_FAILURE(error.localizedDescription);
//                return;
//            }
//        }
//        @catch (NSException *exception)
//        {
//            NSLog(@"Fetch error: %@", exception.reason);
//        }
//        @finally
//        {
//            if (([[trainNames firstObject] capacity] - [[seatsGone firstObject] integerValue]) > [_numberOfSeatsTextField.text integerValue])
//            {
//                // book here
//                NSString *queryString = [NSString stringWithFormat:@"INSERT INTO Tickets (Train_ID, Journey_Distance, Date_Of_Journey, Startp_ID, Endp_ID, Person_ID, Cost) VALUES (%li, %li, '%@', %li, %li, %li, %li)", [[[trainNames firstObject] objectForKey:@"Train_ID"] integerValue], distanceToTravel, [[trainNames firstObject] objectForKey:@"date_of_journey"], startPid, endPid, [[persons firstObject] personId], costIncurred];
//                NSError *error;
//                if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
//                {
//                    // Failed
//                    NSLog(@"Failed %@", error.localizedDescription);
//                }
//                @try
//                {
//                    NSError *error;
//                    
//                    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Tickets"];
//                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
//                    bookings = [Tickets returnArrayFromJSONStructure:results];
//                    if (error)
//                    {
//                        SVHUD_FAILURE(error.localizedDescription);
//                        return;
//                    }
//                } @catch (NSException *exception)
//                {
//                    NSLog(@"Fetch error: %@", exception.reason);
//                }
//                @finally
//                {
//                        NSString *queryString = [NSString stringWithFormat:@"INSERT INTO Booking_History (Person_id, PNR) VALUES (%li, %li)", [[persons firstObject] personId], [[[bookings firstObject] PNR] integerValue]];
//                        NSError *error;
//                        if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
//                        {
//                            // Failed
//                            NSLog(@"Failed %@", error.localizedDescription);
//                        }
//                        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailsNavVC"];
//                        TicketDetailsTableViewController *tdtvc = [navVC viewControllers][0];
//                        tdtvc.pnr = [[bookings firstObject] PNR];
//                        [self presentViewController:navVC animated:YES completion:nil];
//                }
//            }
//            else
//            {
//                UIAlertView *noSeatsAlert = [[UIAlertView alloc] initWithTitle:@"Seats Unavailable" message:@"The requested number of seats is not free at the moment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [noSeatsAlert show];
//            }
//        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.boardingStationTextField)
        [self.boardingStationTextField becomeFirstResponder];
    if (textField == self.alightingStationTextField)
        [self.alightingStationTextField becomeFirstResponder];
    if (textField == self.dateOfJourneryTextField)
        [self.dateOfJourneryTextField becomeFirstResponder];
    if (textField == self.numberOfSeatsTextField)
        [self.numberOfSeatsTextField becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.numberOfSeatsTextField resignFirstResponder];
    [self.boardingStationTextField resignFirstResponder];
    [self.alightingStationTextField resignFirstResponder];
    [self.dateOfJourneryTextField resignFirstResponder];
}
@end
