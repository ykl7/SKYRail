//
//  EasterEggViewController.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "EasterEggViewController.h"

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _productionTextView.text = @"Presented by Saket Singh, KDS and YKL.\n\n\t\t\tWe Are SKYRail.";
    [_productionTextView setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0f]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
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
