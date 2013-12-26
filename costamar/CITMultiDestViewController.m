//
//  CITMultiDestViewController.m
//  costamar
//
//  Created by Mahavir Jain on 18/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMultiDestViewController.h"
#import "CITAddNewDestViewController.h"
#import "CITMultiDestCell.h"
#import "CITMultiDestHeaderCell.h"
#import "CITMultiDestCityData.h"
#import "CITUtils.h"
#import "MMPickerView.h"
#import "CITSearchResultsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "UIColor+InnerBand.h"
#import "CITMultiDestData.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"

#define BOTTOM_BORDER 1

@interface CITMultiDestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *tariffButton;
@property (weak, nonatomic) IBOutlet UIButton *adultButton;
@property (weak, nonatomic) IBOutlet UIButton *childrenButton;
@property (weak, nonatomic) IBOutlet UIButton *infantButton;

@end

@implementation CITMultiDestViewController {
    
    NSArray *adultOptions;
    NSArray *childrenOptions;
    NSArray *infantOptions;
    NSArray *tariffOptions;
    
    NSArray *searchResults;
    UIAlertView *alertView;

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
    
    if (!self.multiDestData) {
        self.multiDestData = [[CITMultiDestData alloc] initWithCountryData:[CITUtils getCountryPreference]];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self initializeOptions];
    alertView = [CITUtils alertView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeOptions
{
    adultOptions = [CITUtils getOptionsForType:ADULTS];
    childrenOptions = [CITUtils getOptionsForType:CHILDREN];
    infantOptions = [CITUtils getOptionsForType:INFANTS];
    tariffOptions = [CITUtils getOptionsForType:CABIN];
    
    [self.tariffButton setTitle:[CITUtils prependSpace:[tariffOptions firstObject]] forState:UIControlStateNormal];
    [self.adultButton setTitle:[CITUtils prependSpace:[adultOptions firstObject]] forState:UIControlStateNormal];
    [self.childrenButton setTitle:[CITUtils prependSpace:[childrenOptions firstObject]] forState:UIControlStateNormal];
    [self.infantButton setTitle:[CITUtils prependSpace:[infantOptions firstObject]] forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Add +1 for header cell
    return [self.multiDestData.cities count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CITMultiDestHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        CITMultiDestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        CITMultiDestCityData *multiDestCity = self.multiDestData.cities[indexPath.row-1];
        cell.originLabel.text = multiDestCity.originCode;
        cell.destLabel.text = multiDestCity.destCode;
        cell.dateLabel.text = [multiDestCity formattedFromDate];
        cell.removeButton.tag = indexPath.row-1;
        [cell.removeButton addTarget:self action:@selector(removeRow:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)removeRow:(id)sender
{
    [self.multiDestData.cities removeObjectAtIndex:[sender tag]];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNewDestination"])
    {
        CITAddNewDestViewController *vc = [segue destinationViewController];
        [vc setMultiDestData:self.multiDestData];
    }
    
    if ([[segue identifier] isEqualToString:@"showMultiDestFlightResults"])
    {
        CITSearchResultsViewController *vc = [segue destinationViewController];
        [vc setFlightResults:searchResults];
    }
}

- (IBAction)getMultiDestFlights:(id)sender {
    
    MKNetworkOperation *searchMultiDestFlightsOperation = [ [CITUtils networkEngine] searchFlightsForMultiDestJourney:self.multiDestData CompletionHandler:^(NSArray *flights) {
        
        searchResults = flights;
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier: @"showMultiDestFlightResults" sender: self];
        
    } errorHandler:^(NSError *error){
        
        [SVProgressHUD dismiss];
        alertView.message = [NSString stringWithFormat:NSLocalizedString(@"unknown_error", nil), error.localizedDescription];
        [alertView show];
        
    }];
    
    // Search Flights
    [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
    searchMultiDestFlightsOperation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    [[CITUtils networkEngine] enqueueOperation:searchMultiDestFlightsOperation];
}

- (IBAction)selectTariffType:(id)sender {
    [self showPickerViewWithOptions:[CITUtils getOptionsForType:CABIN] type:CABIN selectedOption:self.multiDestData.tariff];
}

- (IBAction)selectAdults:(id)sender {
    [self showPickerViewWithOptions:[CITUtils getOptionsForType:ADULTS] type:ADULTS selectedOption:self.multiDestData.adults];
}

- (IBAction)selectChildren:(id)sender {
    [self showPickerViewWithOptions:[CITUtils getOptionsForType:CHILDREN] type:CHILDREN selectedOption:self.multiDestData.children];
}

- (IBAction)selectInfants:(id)sender {
    [self showPickerViewWithOptions:[CITUtils getOptionsForType:INFANTS] type:INFANTS selectedOption:self.multiDestData.infants];
}

- (void)showPickerViewWithOptions:(NSArray *)options type:(NSString *)type selectedOption:(NSString *)selectedOption
{
    [MMPickerView showPickerViewInView:self.view
           withStrings:options
           withOptions:@{MMshowsSelectionIndicator: @"1", MMselectedObject: selectedOption,  MMbuttonColor:[CITUtils appDarkBlueColor]}
            completion:^(NSString *selectedOption) {
                [self selectionCompleteWith:selectedOption selectionType:type];
            }];
}

- (void)selectionCompleteWith:(NSString *)selectedOption selectionType:(NSString *)type
{
    if ([type isEqualToString:ADULTS]) {
        self.multiDestData.adults = selectedOption;
        [self.adultButton setTitle:[CITUtils prependSpace:self.multiDestData.adults] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CHILDREN]) {
        self.multiDestData.children = selectedOption;
        [self.childrenButton setTitle:[CITUtils prependSpace:self.multiDestData.children] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:INFANTS]) {
        self.multiDestData.infants = selectedOption;
        [self.infantButton setTitle:[CITUtils prependSpace:self.multiDestData.infants] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CABIN]) {
        self.multiDestData.tariff = selectedOption;
        [self.tariffButton setTitle:self.multiDestData.tariff forState:UIControlStateNormal];
    }
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
