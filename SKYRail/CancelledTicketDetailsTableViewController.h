//
//  CancelledTicketDetailsTableViewController.h
//  SKYRail
//
//  Created by YASH on 21/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelledTicketDetailsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *pnrLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *deletionLabel;

@property (nonatomic) NSNumber *pnr;

@end
