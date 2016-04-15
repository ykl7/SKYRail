//
//  LaunchViewController.m
//  SKYRail
//
//  Created by YASH on 14/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "LaunchViewController.h"
#import "User.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIView animateWithDuration:3.0 animations:^{
        _trainImage.center = CGPointMake((self.view.frame.size.width)*2, (self.view.frame.size.height)/2);
    }];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayWelcome) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(moveToNewView) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    _welcomeLabel.hidden = YES;
}

- (void) displayWelcome
{
    _welcomeLabel.hidden = false;
}

- (void) moveToNewView
{
    User *currentUser = [User currentUser];
    if (currentUser)
    {
        UITabBarController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
        [tabBarVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:tabBarVC animated:YES completion:nil];
    }
    else
    {
        UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpNavVC"];
        [self presentViewController:navVC animated:YES
                         completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
