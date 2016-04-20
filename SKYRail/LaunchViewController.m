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
    
    _trainImage.transform = CGAffineTransformMakeTranslation(-400, 0);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:2.0 delay:0.5 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _trainImage.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self moveToNewView];
    }];
}

- (void) moveToNewView
{
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpNavVC"];
    [self presentViewController:navVC animated:YES
                     completion:nil];
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
