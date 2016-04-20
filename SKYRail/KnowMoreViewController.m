//
//  KnowMoreViewController.m
//  SKYRail
//
//  Created by YASH on 14/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "KnowMoreViewController.h"

@interface KnowMoreViewController ()

@end

@implementation KnowMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = _cityName;
    _cityImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg", _cityName]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Platforms" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    for (NSDictionary *dict in json)
    {
        if ([[dict objectForKey:@"name"] isEqualToString:_cityName])
        {
            _cityDesc.text = [dict objectForKey:@"description"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_cityDesc setFont:[UIFont systemFontOfSize:18.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToList:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
