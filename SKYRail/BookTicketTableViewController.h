//
//  BookTicketTableViewController.h
//  SKYRail
//
//  Created by YASH on 12/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTicketTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *boardingStationTextField;
@property (strong, nonatomic) IBOutlet UITextField *alightingStationTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateOfJourneryTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberOfSeatsTextField;

@end
