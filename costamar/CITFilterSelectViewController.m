//
//  CITFilterSelectViewController.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFilterSelectViewController.h"
#import "CITUtils.h"
#import "CITFilterParams.h"

@interface CITFilterSelectViewController ()

@end

@implementation CITFilterSelectViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectAll:(id)sender {
    [self.filterParams updateAllWithValue:YES airlineOptions:self.showAirlineOptions];
    [self.tableView reloadData];
}

- (IBAction)selectNone:(id)sender {
    [self.filterParams updateAllWithValue:NO airlineOptions:self.showAirlineOptions];
    [self.tableView reloadData];
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
    return [self.filterParams getRowCount:self.showAirlineOptions];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"filterOptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell.layer setBorderColor:[CITUtils borderColor].CGColor];
    [cell.layer setBorderWidth:1.0f];
    
    NSString *labelText = [self.filterParams getLabelForRow:indexPath.row showAirlineOptions:self.showAirlineOptions];
    cell.textLabel.text = labelText;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if ([self.filterParams isSelectedRow:indexPath.row showAirlineOptions:self.showAirlineOptions]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
