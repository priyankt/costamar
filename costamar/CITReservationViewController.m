//
//  CITReservationViewController.m
//  costamar
//
//  Created by Mahavir Jain on 06/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITReservationViewController.h"
#import "CITAgreementViewController.h"
#import "CITPaymentOptionCell.h"
#import "CITPaymentOption.h"
#import <QuartzCore/QuartzCore.h>
#import "CITUtils.h"
#import "CITFlightDetailData.h"

#define SHOW_AGREEMENT_SEGUE_ID @"showAgreement"

@interface CITReservationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *fromCityButton;
@property (weak, nonatomic) IBOutlet UIButton *toCityButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *airlineLabel;

@end

@implementation CITReservationViewController {
    CITPaymentOption *selectedOption;
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
	// Do any additional setup after loading the view.

    // Add border to header view
    self.headerView.layer.borderWidth= 1.0f;
    self.headerView.layer.borderColor = [[CITUtils borderColor] CGColor];

    // set table delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    // Add border to table
    [self.tableView.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.tableView.layer setBorderWidth:1.0f];
    //[self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    // initialized first option as selected option
    if (self.paymentOptions && [self.paymentOptions count] > 0) {
        selectedOption = self.paymentOptions.firstObject;
    }
    
    // set text for labels
    self.airlineLabel.text = self.detailData.airline;
    [self.fromCityButton setTitle:self.detailData.cityFrom forState:UIControlStateNormal];
    [self.toCityButton setTitle:self.detailData.cityTo forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"$ %@", [self.detailData.price stringValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    // show first option as selected
    if (self.paymentOptions && [self.paymentOptions count] > 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SHOW_AGREEMENT_SEGUE_ID]){
        CITAgreementViewController *agreementViewController = segue.destinationViewController;
        agreementViewController.detailData = self.detailData;
        agreementViewController.paymentOption = selectedOption;
    }
}

- (IBAction)goNext:(id)sender {
    [self performSegueWithIdentifier:SHOW_AGREEMENT_SEGUE_ID sender:self];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paymentCell";
    CITPaymentOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CITPaymentOption *option = self.paymentOptions[indexPath.row];
    CGSize maxSize = CGSizeMake(cell.descriptionLabel.frame.size.width, MAXFLOAT);
    CGFloat descriptionLabelHeight = 0;
    if (option.description != (NSString *)[NSNull null]) {
        CGRect labelRect = [option.description boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.descriptionLabel.font} context:nil];
        descriptionLabelHeight = labelRect.size.height;
    }
    
    return 50+descriptionLabelHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.paymentOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paymentCell";
    CITPaymentOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CITPaymentOption *option = self.paymentOptions[indexPath.row];
    cell.nameLabel.text = option.name;
    if (option.description != (NSString *)[NSNull null]) {
        cell.descriptionLabel.text = option.description;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedOption = self.paymentOptions[indexPath.row];
}

@end
