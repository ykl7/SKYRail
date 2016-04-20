//
//  EditUserTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "EditUserTableViewController.h"

@interface EditUserTableViewController ()
{
    User *user;
    
    BOOL anyChange;
}

@end

@implementation EditUserTableViewController

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
    user = [User currentUser];
    
    [_userNameTF setText:@""];
    [_mobileNoTF setText:@""];
    
    anyChange = NO;
}

- (void)didReceiveMemoryWarning
{
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
    if ([_userNameTF.text length] > 0)
    {
        anyChange = YES;
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"UPDATE Person SET name = '%@' WHERE email = '%@'", _userNameTF.text, user.email];
            
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
        }
    }
    if ([_mobileNoTF.text length] == 10)
    {
        anyChange = YES;
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"UPDATE Person SET mob_no = %@ WHERE email = '%@'", _mobileNoTF.text, user.email];
            
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
        }
    }
    if (!anyChange)
    {
        UIAlertView *noChangeMadeAlert = [[UIAlertView alloc] initWithTitle:@"Invalid inputs" message:@"Please enter valid input(s)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noChangeMadeAlert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTF)
        [self.userNameTF becomeFirstResponder];
    if (textField == self.mobileNoTF)
        [self.mobileNoTF becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.userNameTF resignFirstResponder];
    [self.mobileNoTF resignFirstResponder];
}

@end
