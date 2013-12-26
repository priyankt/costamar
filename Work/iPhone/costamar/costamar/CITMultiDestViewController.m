//
//  CITMultiDestViewController.m
//  costamar
//
//  Created by Mahavir Jain on 18/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMultiDestViewController.h"

@interface CITMultiDestViewController ()

@end

@implementation CITMultiDestViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sectionHeaderView.bounds.size.width, 1)];
    topLineView.backgroundColor = [UIColor blackColor];
    [sectionHeaderView addSubview:topLineView];
    
    UILabel *origenLabel = [self headerLabelAtX:15 width:56 text:@"Origen"];
    [sectionHeaderView addSubview:origenLabel];
    
    [sectionHeaderView addSubview:[self separatorAtX:79]];
    
    UILabel *destinoLabel = [self headerLabelAtX:89 width:56 text:@"Destino"];
    [sectionHeaderView addSubview:destinoLabel];
    
    [sectionHeaderView addSubview:[self separatorAtX:152]];

    UILabel *fechaLabel = [self headerLabelAtX:162 width:92 text:@"Fecha"];
    [sectionHeaderView addSubview:fechaLabel];
    
    [sectionHeaderView addSubview:[self separatorAtX:259]];
    
    UILabel *borrarLabel = [self headerLabelAtX:265 width:50 text:@"Borrar"];
    [sectionHeaderView addSubview:borrarLabel];

    sectionHeaderView.backgroundColor = [UIColor lightGrayColor];
    
    return sectionHeaderView;
}

- (UILabel *)headerLabelAtX:(CGFloat)x width:(CGFloat)width text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 12, width, 21)];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByClipping;
    label.text = text;

    return label;
}

- (UILabel *)separatorAtX:(CGFloat)xValue
{
    UILabel *separator = [[UILabel alloc] initWithFrame:CGRectMake(xValue, 0, 1, 44)];
    separator.backgroundColor = [UIColor blackColor];
    separator.text = @"";
    
    return separator;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Add top border for table
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 1)];
        topLineView.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:topLineView];
    }
    
    // Add bottom border for table
    if (indexPath.row == 1) {
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-1, self.view.bounds.size.width, 1)];
        bottomLineView.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:bottomLineView];
    }
    
    return cell;
}

- (IBAction)addNewDest:(id)sender {
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
