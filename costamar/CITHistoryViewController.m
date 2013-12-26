//
//  CITHistoryViewController.m
//  costamar
//
//  Created by Mahavir Jain on 06/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITHistoryViewController.h"
#import "CITSearchHistory.h"
#import "CITHistoryCell.h"
#import "IBCoreDataStore.h"
#import "NSManagedObject+InnerBand.h"
#import "CITSearchViewController.h"

@interface CITHistoryViewController ()

@end

@implementation CITHistoryViewController {
    NSArray *journeyHistory;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    journeyHistory = [CITSearchHistory all];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if([segue.identifier isEqualToString:@"showSearchViewFromHistory"]){
        CITSearchViewController *searchViewController = segue.destinationViewController;
        CITSearchHistory *history = [journeyHistory objectAtIndex:path.row];
        searchViewController.journeyParams = [history getJourneyParams];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [journeyHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"historyCell";
    CITHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CITSearchHistory *jHistory = [journeyHistory objectAtIndex:indexPath.row];
    cell.routeLabel.attributedText = [jHistory getRoute];
    cell.dateLabel.attributedText = [jHistory getDateString];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
