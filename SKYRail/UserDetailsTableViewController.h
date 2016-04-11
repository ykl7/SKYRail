//
//  UserDetailsTableViewController.h
//  SKYRail
//
//  Created by YASH on 12/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;

@end
