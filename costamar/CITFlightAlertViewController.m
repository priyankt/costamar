//
//  CITFlightAlertViewController.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightAlertViewController.h"
#import "IBCoreDataStore.h"
#import "NSManagedObject+InnerBand.h"
#import "CITFlightAlert.h"
#import "CITFlightAlertViewCell.h"
#import "CITNewFlightAlertViewController.h"
#import "CITUtils.h"
#import "CITJourneyData.h"
#import "CITSearchResultsViewController.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"
#import "SVProgressHUD.h"

#define NEW_FLIGHT_ALERT_SEGUE_ID @"showNewFlightAlertView"
#define EDIT_FLIGHT_ALERT_SEGUE_ID @"showEditFlightAlertView"
#define SHOW_SEARCH_RESULTS @"showSearchResultsFromAlert"

@interface CITFlightAlertViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CITFlightAlertViewController {
    NSMutableArray *flightAlerts;
    NSArray *searchResults;
    UIActionSheet *actionSheet;
    CITFlightAlert *selectedAlert;
    UIAlertView *alertView;
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    alertView = [CITUtils alertView];
    
    actionSheet = [[UIActionSheet alloc]
          initWithTitle:NSLocalizedString(@"selectalert_action", nil)
          delegate:self
          cancelButtonTitle:nil
          destructiveButtonTitle:nil
          otherButtonTitles:nil];
    for (NSString *title in [CITUtils getOptionsForType:ALERT_ACTION]) {
        [actionSheet addButtonWithTitle:title];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    flightAlerts = [[CITFlightAlert all] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NEW_FLIGHT_ALERT_SEGUE_ID]) {
        CITNewFlightAlertViewController *newAlertController = segue.destinationViewController;
        newAlertController.journeyData = [[CITJourneyData alloc] init];
    }
    if ([segue.identifier isEqualToString:EDIT_FLIGHT_ALERT_SEGUE_ID]) {
        CITNewFlightAlertViewController *newAlertController = segue.destinationViewController;
        newAlertController.journeyData = [selectedAlert getJourneyData];
    }
    if ([segue.identifier isEqualToString:SHOW_SEARCH_RESULTS]) {
        CITSearchResultsViewController *searchResultsController = segue.destinationViewController;
        searchResultsController.journeyParams = [selectedAlert getJourneyData];
        searchResultsController.flightResults = searchResults;
    }
}

- (IBAction)createNewAlert:(id)sender {
    [self performSegueWithIdentifier:NEW_FLIGHT_ALERT_SEGUE_ID sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [flightAlerts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flightAlertCell";
    CITFlightAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CITFlightAlert *alert = [flightAlerts objectAtIndex:indexPath.row];
    
    cell.headerLabel.text = [alert getAlertHeaderString];
    cell.dateLabel.text = [alert getAlertDateString];
    cell.passengerLabel.text = [alert getAlertNumberOfPassengersString];
    cell.maxPriceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_max_price", nil), (alert.maxPrice ? alert.maxPrice : @"-")];
    cell.bestPriceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_best_price", nil), (alert.bestPrice ? alert.bestPrice : @"-")];
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedAlert = flightAlerts[indexPath.row];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegete

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    // 0 query webservice for this alert
    if (buttonIndex == 0) {
        CITJourneyData *journeyData = [selectedAlert getJourneyData];
        MKNetworkOperation *searchFlightsOperation = [ [CITUtils networkEngine] searchFlightsForJourney:journeyData CompletionHandler:^(NSArray *flights) {
            
            searchResults = flights;
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:SHOW_SEARCH_RESULTS sender:self];
            
        } errorHandler:^(NSError *error){
            
            [SVProgressHUD dismiss];
            alertView.message = [NSString stringWithFormat:@"Unknown Error: %@", error.localizedDescription];
            [alertView show];
            
        }];
        
        // Search Flights
        [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
        searchFlightsOperation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        [[CITUtils networkEngine] enqueueOperation:searchFlightsOperation];
        
        // save adults, children, infant count for passenger info view
        [CITUtils saveJourneyParams:journeyData];
        
        // save to history
        [journeyData saveToHistory];
    }
    // edit this alert
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:EDIT_FLIGHT_ALERT_SEGUE_ID sender:self];
    }
    // delete this alert
    if (buttonIndex == 2) {
        // remove from database
        [selectedAlert destroy];
        // remove from array else tableview will display it
        [flightAlerts removeObject:selectedAlert];
        // load table view data
        [self.tableView reloadData];
    }
}

@end
