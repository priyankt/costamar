//
//  CITFlightDetailViewController.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightDetailViewController.h"
#import "CITUtils.h"
#import "CITFlightData.h"
#import "SVProgressHUD.h"
#import "CITFlightDetailData.h"
#import "CITSegmentGroupData.h"
#import "CITSearchDetailSectionHeaderView.h"
#import "CITSearchDetailCell.h"
#import "CITFlightSegmentData.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+InnerBand.h"
#import "CITReservationViewController.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"
#import "CITCountryData.h"

@interface CITFlightDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fromCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *toCityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *airlineImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;

@end

@implementation CITFlightDetailViewController {
    UIAlertView *alert;
    NSArray *mPaymentOptions;
    CITFlightDetailData *mFlightDetailData;
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.topHeaderView.layer.borderWidth= 1.0f;
    self.topHeaderView.layer.borderColor = [[CITUtils borderColor] CGColor];
    
    [self.fromCityBtn setTitle:self.detailData.cityFrom forState:UIControlStateNormal];
    [self.toCityBtn setTitle:self.detailData.cityTo forState:UIControlStateNormal];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%@",[self.detailData.price stringValue]];
    UIImage *flightImage = [CITUtils getFlightImageForAirline:self.detailData.airlineid];
    if (flightImage) {
        self.airlineImageView.image = flightImage;
    }
    
    alert = [[UIAlertView alloc] initWithTitle:@"Cannot Reserve"
                                       message:@"Cannot reserve"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reserveFlight:(id)sender {
    
    CITCountryData *countryPref = [CITUtils getCountryPreference];
    MKNetworkOperation *paymentOperation = [ [CITUtils networkEngine] getPaymentMethods:self.detailData.flightid affiliateId:countryPref.affiliateid countryCode:countryPref.countryCode CompletionHandler:^(NSArray *paymentOptions) {
        
        mPaymentOptions = paymentOptions;
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"showReservationView" sender:self];
        
    } errorHandler:^(NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD dismiss];
        
    }];
    
    MKNetworkOperation *flightPricingOperation = [ [CITUtils networkEngine] getFlightPricingForFlight:self.detailData CompletionHandler:^(CITFlightDetailData *flightDetailData) {
        
        if (flightDetailData.status != 0) {
            mFlightDetailData = flightDetailData;
            [[CITUtils networkEngine] enqueueOperation:paymentOperation];
        } else {
            [SVProgressHUD dismiss];
            [alert show];
        }
        
    } errorHandler:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
        [SVProgressHUD dismiss];
        
    }];
    
    // Get flight details
    [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
    
    flightPricingOperation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [[CITUtils networkEngine] enqueueOperation:flightPricingOperation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.detailData.segmentGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    CITSegmentGroupData *groupData = [self.detailData.segmentGroups objectAtIndex:section];
    return [groupData.flightSegments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CITSegmentGroupData *groupData = [self.detailData.segmentGroups objectAtIndex:section];
    CITSearchDetailSectionHeaderView *sectionHeaderView = [[CITSearchDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    sectionHeaderView.titleLabel.text = [groupData getSectionTitle];
    if (section == 0) {
        [sectionHeaderView setColor:[CITUtils appBlueColor]];
    } else {
        [sectionHeaderView setColor:[CITUtils appOrangeColor]];
    }
    
    return sectionHeaderView;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 CITFlightData *data = [flightResults objectAtIndex:indexPath.row];
 CGFloat height = 40 + [data.flightSegments count] * 83;
 return height;
 }
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flightDetailCell";
    CITSearchDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CITSegmentGroupData *groupData = [self.detailData.segmentGroups objectAtIndex:indexPath.section];
    CITFlightSegmentData *flightSegmentData = [groupData.flightSegments objectAtIndex:indexPath.row];
    
    cell.headerLabel.text = [flightSegmentData getHeaderText];
    cell.salidaLabel.attributedText = [flightSegmentData getDateFromAttributedString];
    cell.llegadaLabel.attributedText = [flightSegmentData getDateToAttributedString];
    cell.aerolineaLabel.attributedText = [flightSegmentData getAirlineAttributedString];
    cell.operadoLabel.attributedText = [flightSegmentData getOperatedByAttributedString];
    cell.tarifaLabel.attributedText = [flightSegmentData getTariffAttributedString];
    cell.hora1Label.attributedText = [flightSegmentData getHourFromAttributedString];
    cell.hora2Label.attributedText = [flightSegmentData getHourToAttributedString];
    cell.vueloLabel.attributedText = [flightSegmentData  getFlightNumberAttributedString];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showReservationView"]){
        CITReservationViewController *reservationViewController = segue.destinationViewController;
        reservationViewController.detailData = mFlightDetailData;
        reservationViewController.paymentOptions = mPaymentOptions;
    }
}

@end
