//
//  TicketDetailsTableViewController.h
//  SKYRail
//
//  Created by YASH on 11/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDetailsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *pnrLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dojLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;

@end
