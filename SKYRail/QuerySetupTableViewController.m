//
//  QuerySetupTableViewController.m
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "QuerySetupTableViewController.h"
#import "QueryResultsTableViewController.h"

@interface QuerySetupTableViewController ()

@property (strong, nonatomic) AudioController *audioController;

@property (strong, nonatomic) IBOutlet UITextView *queryTextView;

@end

@implementation QuerySetupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Have Fun";
    
    self.audioController = [[AudioController alloc] init];
    [self.audioController tryPlayMusic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self numberOfSectionsInTableView:tableView] - 1)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.queryTextView resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"loadQueryResultSegue"])
    {
        
        QueryResultsTableViewController *qrtvc = [segue destinationViewController];
        
        qrtvc.queryString = self.queryTextView.text;
        
    }
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

@end
