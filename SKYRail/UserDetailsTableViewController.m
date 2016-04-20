//
//  UserDetailsTableViewController.m
//  SKYRail
//
//  Created by YASH on 12/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "UserDetailsTableViewController.h"
#import "User.h"

@interface UserDetailsTableViewController ()
{
    User *thisUser;
    
    NSMutableArray *persons;
}

@end

@implementation UserDetailsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    thisUser = [User currentUser];
    SVHUD_SHOW;
//    _userNameLabel.text = thisUser.userName;
//    _emailLabel.text = thisUser.email;
//    _mobileNoLabel.text = thisUser.mobileNumber;
//    _genderLabel.text = thisUser.gender;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    persons = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Person WHERE email = '%@'", thisUser.email];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            persons = [Person returnArrayFromJSONStructure:results];
            if (error) {
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
                _userNameLabel.text = [NSString stringWithFormat:@"Name : %@", [[persons firstObject] name]];
                _emailLabel.text = [NSString stringWithFormat:@"email : %@", [[persons firstObject] email]];
                _mobileNoLabel.text = [NSString stringWithFormat:@"Mobile No : %@", [[persons firstObject] mobNo]];
                _genderLabel.text = [NSString stringWithFormat:@"Gender : %@", [[persons firstObject] gender]];
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

- (IBAction)logOutAction:(id)sender
{
    [User clearUser];
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpNavVC"];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2)
    {
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"DELETE FROM Person WHERE email = '%@'", [[persons firstObject] email]];
            
            if (![[DBManager sharedManager] dbExecuteUpdate:queryString error:&error])
            {
                // Failed
                NSLog(@"Failed %@", error.localizedDescription);
            }
            [self logOutAction:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"Fetch error: %@", exception.reason);
        }
        @finally {
        }
    }
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"easterEggNavVC"];
        [self presentViewController:navVC animated:YES completion:nil];
        
    }
    
}
@end
