//
//  LoginTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "LoginTableViewController.h"

@interface LoginTableViewController ()
{
    NSMutableArray *previousUsers;
    
    User *thisUser;
    
    BOOL loggedIn;
}

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    thisUser = [User currentUser];
    
    _nameTextField.text = thisUser.email;
    _passwordTextField.text = thisUser.password;

}

- (void)viewWillAppear:(BOOL)animated
{
    loggedIn = NO;
    SVHUD_SHOW;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @try {
            
            NSError *error;
            
            NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM Person"];
            
            NSArray *results = [[DBManager sharedManager] dbExecuteQuery:queryString error:&error];
            
            previousUsers = [Person returnArrayFromJSONStructure:results];
            
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
            });
        }
        
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToSignUp:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        for (Person *p in previousUsers)
        {
            if ([p.email isEqualToString:_nameTextField.text])
            {
                if ([p.password isEqualToString:_passwordTextField.text])
                {
                    User *currentUser = [[User alloc] initWithName:p.name email:p.email password:p.password mobileNo:p.mobNo gender:p.gender];
                    [currentUser saveToDefaults];
                    loggedIn = YES;
                    UITabBarController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
                    [tabBarVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                    [self presentViewController:tabBarVC animated:YES completion:nil];
                    break;
                }
            }
        }
        if (loggedIn == NO)
        {
            UIAlertView *invalidLogin = [[UIAlertView alloc] initWithTitle:@"Invalid credentials" message:@"Please check the details you have entered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [invalidLogin show];
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
    if (textField == self.nameTextField)
        [self.nameTextField becomeFirstResponder];
    if (textField == self.passwordTextField)
        [self.passwordTextField becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
