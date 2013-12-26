//
//  CITSearchResultsViewController.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSearchResultsViewController.h"
#import "CITUtils.h"
#import "SVProgressHUD.h"
#import "CITSearchResultCell.h"
#import "CITFlightData.h"
#import "CITFlightSegmentData.h"
#import "CITFlightDetailData.h"
#import "CITFlightDetailViewController.h"
#import "CITSearchResultSectionHeaderView.h"
#import "UICOlor+InnerBand.h"
#import "CITFlightData.h"
#import "CITFilterParams.h"
#import "CITFilterViewController.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"

#define FILTER_OPTIONS_SEGUE @"showFilterView"
#define DETAIL_VIEW_SEGUE @"showDetailView"

@interface CITSearchResultsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalResultsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CITSearchResultsViewController {
    CITFlightDetailData *flightDetailData;
    NSMutableArray *filteredResults;
    CITFilterParams *filterParams;
    BOOL sortAscending;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!filterParams) {
        filterParams = [[CITFilterParams alloc] initWithFlightResults:self.flightResults];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    filteredResults = [[NSMutableArray alloc] init];
    for (CITFlightData *flight in self.flightResults) {
        if (![flight failedFilter:filterParams]) {
            [filteredResults addObject:flight];
        }
    }
    self.totalResultsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"result_count", nil), [filteredResults count], [self.flightResults count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFilterOptions:(id)sender {
    [self performSegueWithIdentifier:FILTER_OPTIONS_SEGUE sender:self];
}

- (IBAction)sortResults:(id)sender {
    if (sortAscending) {
        sortAscending = NO;
    } else {
        sortAscending = YES;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                 ascending:sortAscending];
    [filteredResults sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:DETAIL_VIEW_SEGUE]){
        CITFlightDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.detailData = flightDetailData;
    }
    
    if([segue.identifier isEqualToString:FILTER_OPTIONS_SEGUE]){
        CITFilterViewController *filterViewController = segue.destinationViewController;
        filterViewController.filterParams = filterParams;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    return [filteredResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    CITFlightData *data = [filteredResults objectAtIndex:section];
    return [data.flightSegments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CITFlightData *data = [filteredResults objectAtIndex:section];
    CITSearchResultSectionHeaderView *headerView = [[CITSearchResultSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    headerView.PriceLabel.attributedText = [data getPriceAttributedString];
    UIImage *flightImage = [CITUtils getFlightImageForAirline:data.airline];
    if (flightImage) {
        headerView.flightImageView.image = flightImage;
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    footerView.backgroundColor = [CITUtils appDarkBlueColor];
    
    return footerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flightResultCell";
    CITSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    CITFlightData *flightData = [filteredResults objectAtIndex:indexPath.section];
    CITFlightSegmentData *flightSegmentData = [flightData.flightSegments objectAtIndex:indexPath.row];
    
    cell.salidaLabel.attributedText = [flightSegmentData getFromLabelText];
    cell.LlegadaLabel.attributedText = [flightSegmentData getToLabelText];
    cell.escalasLabel.text = [flightSegmentData getStopLabelText];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKNetworkOperation *flightDetailsOperation = [ [CITUtils networkEngine] getFlightDetialWithData:[self.flightResults objectAtIndex:indexPath.section] CompletionHandler:^(CITFlightDetailData *detailData) {
        
        flightDetailData = detailData;
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:DETAIL_VIEW_SEGUE sender:self];
        
    } errorHandler:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD dismiss];
        
    }];
    
    // Get flight details
    [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
    
    flightDetailsOperation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [[CITUtils networkEngine] enqueueOperation:flightDetailsOperation];    
}

@end
