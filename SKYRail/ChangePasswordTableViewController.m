//
//  ChangePasswordTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "ChangePasswordTableViewController.h"

@interface ChangePasswordTableViewController ()
{
    User *user;
    
    NSMutableArray *persons;
}

@end

@implementation ChangePasswordTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    user = [User currentUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    persons = [NSMutableArray new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Person WHERE email = '%@'", user.email];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if ([_confirmPasswordTF.text length] > 6 && [_oldPasswordTF.text length] > 0 && [_changedPasswordTF.text length] > 6)
        {
            if ([_oldPasswordTF.text isEqualToString:[[persons firstObject] password]] && [_changedPasswordTF.text isEqualToString:_confirmPasswordTF.text])
            {
                @try {
                    
                    NSError *error;
                    
                    NSString *queryString = [NSString stringWithFormat:@"UPDATE Person SET password = '%@' WHERE email = '%@'", _changedPasswordTF.text, user.email];
                    
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
            else
            {
                UIAlertView *invalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid entries" message:@"Please fill in required details correctly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [invalidAlert show];
            }
        }
        else
        {
            UIAlertView *invalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid entries" message:@"Please fill in required details correctly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [invalidAlert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.oldPasswordTF)
        [self.oldPasswordTF becomeFirstResponder];
    if (textField == self.changedPasswordTF)
        [self.changedPasswordTF becomeFirstResponder];
    if (textField == self.confirmPasswordTF)
        [self.confirmPasswordTF becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.oldPasswordTF resignFirstResponder];
    [self.changedPasswordTF resignFirstResponder];
    [self.confirmPasswordTF resignFirstResponder];
}
@end
