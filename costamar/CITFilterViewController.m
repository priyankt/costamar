//
//  CITFilterViewController.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFilterViewController.h"
#import "CITFilterSelectViewController.h"
#import "CITUtils.h"
#import "CITFilterParams.h"

#define EMBEDDED_FILTER_SEGUE @"showSelectionOptions"

@interface CITFilterViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *thresholdPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;

@end

@implementation CITFilterViewController {
    BOOL showAirlineOptions;
    CITFilterSelectViewController *childViewController;
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
    showAirlineOptions = YES;
    
    self.minPriceLabel.text = [NSString stringWithFormat:@"$ %.2f", self.filterParams.minPrice];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"$ %.2f", self.filterParams.maxPrice];
    self.thresholdPriceLabel.text = [NSString stringWithFormat:@"$ %.2f", self.filterParams.thresholdPrice];
    
    self.sliderView.continuous = YES;
    self.sliderView.minimumValue = 0;
    self.sliderView.maximumValue = self.filterParams.maxPrice - self.filterParams.minPrice;
    self.sliderView.value = self.filterParams.thresholdPrice;

    self.sliderView.minimumTrackTintColor = [CITUtils appOrangeColor];
    [self.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderValueChanged:(UISlider *)sender
{
    self.filterParams.thresholdPrice = self.filterParams.minPrice + sender.value;
    self.thresholdPriceLabel.text = [NSString stringWithFormat:@"$ %.2f", self.filterParams.thresholdPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EMBEDDED_FILTER_SEGUE]) {
        childViewController = segue.destinationViewController;
        childViewController.filterParams = self.filterParams;
        childViewController.showAirlineOptions = YES;
        childViewController.tableView.delegate = self;
    }
}

- (IBAction)showAirlineFilters:(id)sender {
    showAirlineOptions = YES;
    if (self.containerView.hidden) {
        self.containerView.hidden = NO;
    }
    childViewController.showAirlineOptions = showAirlineOptions;
    [childViewController.tableView reloadData];
}

- (IBAction)showStopFilters:(id)sender {
    showAirlineOptions = NO;
    if (self.containerView.hidden) {
        self.containerView.hidden = NO;
    }
    childViewController.showAirlineOptions = showAirlineOptions;
    [childViewController.tableView reloadData];
}

- (IBAction)showPriceFilters:(id)sender {
    self.containerView.hidden = YES;
}

- (IBAction)resetFilters:(id)sender {
    [self.filterParams resetFilterParams];
    [childViewController.tableView reloadData];
    self.sliderView.value = self.filterParams.thresholdPrice;
}

- (IBAction)applyFilters:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [childViewController.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.filterParams isSelectedRow:indexPath.row showAirlineOptions:showAirlineOptions]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.filterParams updateRow:indexPath.row value:NO showAirlineOptions:showAirlineOptions];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.filterParams updateRow:indexPath.row value:YES showAirlineOptions:showAirlineOptions];
    }
}

@end
