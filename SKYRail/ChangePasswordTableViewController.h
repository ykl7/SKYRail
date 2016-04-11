//
//  ChangePasswordTableViewController.h
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *changedPasswordTF;

@end
