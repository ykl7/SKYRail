//
//  BookingHistoryTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "BookingHistoryTableViewController.h"
#import "TicketDetailsTableViewController.h"
#import "CancelledTicketDetailsTableViewController.h"

@interface BookingHistoryTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    NSMutableArray *bookings;
    NSMutableArray *persons;
    NSMutableArray *cancelledTickets;
    
    NSInteger personIdNow;
}

@end

@implementation BookingHistoryTableViewController

- (void)viewDidLoad {
    SVHUD_SHOW;
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"My Bookings";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    User *thisUser = [User currentUser];
    
    bookings = [NSMutableArray new];
    persons = [NSMutableArray new];
    cancelledTickets = [NSMutableArray new];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Person;"];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            persons = [Person returnArrayFromJSONStructure:results];
            
            for (Person *p in persons)
            {
                if ([p.email isEqualToString:thisUser.email])
                {
                    personIdNow = p.personId;
                    break;
                }
            }
            NSLog(@"person id %li", personIdNow);
            
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
            @try {
                
                NSError *error;
                
                NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Booking_History WHERE Person_id = %li", personIdNow];
                
                NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                
                bookings = [BookingHistory returnArrayFromJSONStructure:results];
                
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
                    
                    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM CancelledTickets WHERE Person_id = %li", personIdNow];
                    
                    NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
                    
                    cancelledTickets = [CancelledTickets returnArrayFromJSONStructure:results];
                    
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        SVHUD_HIDE;
                    });
                }
            }
        }
        
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [bookings count];
    }
    else
    {
        return [cancelledTickets count];
    }
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
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"PNR %@", [[bookings objectAtIndex:indexPath.row] PNR]];
    }
    if (indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"PNR %@", [[cancelledTickets objectAtIndex:indexPath.row] PNR]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ticketDetailsNavVC"];
        TicketDetailsTableViewController *tdtvc = [navVC viewControllers][0];
        tdtvc.pnr = [[bookings objectAtIndex:indexPath.row] PNR];
        tdtvc.personId = personIdNow;
        [self presentViewController:navVC animated:YES completion:nil];
    }
    if (indexPath.section == 1)
    {
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cancelTicketNavVC"];
        CancelledTicketDetailsTableViewController *ctdtvc = [navVC viewControllers][0];
        ctdtvc.pnr = [[cancelledTickets objectAtIndex:indexPath.row] PNR];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section == 0)
    {
        title = @"YOUR TICKETS";
    }
    if (section == 1)
    {
        title = @"CANCELLED TICKETS";
    }
    return title;
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
    return (bookings.count == 0);
}

@end
