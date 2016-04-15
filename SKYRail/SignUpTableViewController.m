//
//  SignUpTableViewController.m
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "User.h"

@interface SignUpTableViewController ()

@end

@implementation SignUpTableViewController

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
    if (indexPath.section == 1)
    {
        if (([_nameTextField.text length] > 0) && ([_emailTextField.text length] >= 5) && ([_genderTextField.text length] == 1) && ([_mobileNumberTextField.text length] == 10) && ([_passwordTextField.text length] >= 6))
        {
            if (!([_genderTextField.text containsString:@"M"]) && !([_genderTextField.text containsString:@"F"]) && !([_genderTextField.text containsString:@"m"]) && !([_genderTextField.text containsString:@"f"]))
            {
                UIAlertView *genderInvalid = [[UIAlertView alloc] initWithTitle:@"Invalid gender" message:@"Only M, F, m, f allowed. Please change and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [genderInvalid show];
            }
            else if (![_emailTextField.text containsString:@"@"] && ![_emailTextField.text containsString:@"."])
            {
                UIAlertView *emailInvalid = [[UIAlertView alloc] initWithTitle:@"Invalid email" message:@"Please re-enter your email id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [emailInvalid show];
            }
            else
            {
                // enter user details into a table here
                
                UITabBarController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
                [tabBarVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [self presentViewController:tabBarVC animated:YES completion:nil];
            }
        }
        else
        {
            if ([_passwordTextField.text length] < 6)
            {
                UIAlertView *passwordLengthAlert = [[UIAlertView alloc] initWithTitle:@"Weak Password" message:@"Password should be atleast 6 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [passwordLengthAlert show];
            }
            else if ([_mobileNumberTextField.text length] != 10)
            {
                UIAlertView *mobileInvalidAlert = [[UIAlertView alloc] initWithTitle:@"Invalid mobile number" message:@"Please enter valid 10-digit mobile number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [mobileInvalidAlert show];
            }
            else if ([_nameTextField.text length] == 0)
            {
                UIAlertView *nameAlert = [[UIAlertView alloc] initWithTitle:@"Invalid name" message:@"Please enter valid name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [nameAlert show];
            }
            else if ([_genderTextField.text length] != 1)
            {
                UIAlertView *genderAlert = [[UIAlertView alloc] initWithTitle:@"Invalid gender" message:@"Please enter valid gender" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [genderAlert show];
            }
            else
            {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check the values you have entered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        }
    }
    if (indexPath.section == 2)
    {
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVCNav"];
        [self presentViewController:navVC animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField)
        [self.nameTextField becomeFirstResponder];
    if (textField == self.mobileNumberTextField)
        [self.mobileNumberTextField becomeFirstResponder];
    if (textField == self.passwordTextField)
        [self.passwordTextField becomeFirstResponder];
    if (textField == self.genderTextField)
        [self.genderTextField becomeFirstResponder];
    if (textField == self.emailTextField)
        [self.emailTextField becomeFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.mobileNumberTextField resignFirstResponder];
    [self.genderTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
