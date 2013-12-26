//
//  CITSearchViewController.m
//  costamar
//
//  Created by Mahavir Jain on 15/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSearchViewController.h"
#import "HMSegmentedControl.h"
#import "UIColor+InnerBand.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageSpinner.h"
#import "MMPickerView.h"
#import "TRAutocompleteView.h"
#import "CITFlightDataSource.h"
#import "CITFlightAutocompleteCellFactory.h"
#import "CITFlightSuggestion.h"
#import "CKCalendarView.h"
#import "CITTextField.h"
#import "CITUtils.h"
#import "CITSegmentedControl.h"
#import "CITDatePicker.h"
#import "CITJourneyData.h"
#import "SVProgressHUD.h"
#import "CITSearchResultsViewController.h"
#import "CITMultiDestViewController.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"

@interface CITSearchViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet CITTextField *originTexField;
@property (weak, nonatomic) IBOutlet CITTextField *destTextField;

@property (weak, nonatomic) IBOutlet CITDatePicker *fromDatePicker;
@property (weak, nonatomic) IBOutlet CITDatePicker *toDatePicker;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *tariffButton;
@property (weak, nonatomic) IBOutlet UIButton *adultButton;
@property (weak, nonatomic) IBOutlet UIButton *childrenButton;
@property (weak, nonatomic) IBOutlet UIButton *infantButton;

@property (weak, nonatomic) IBOutlet CITSegmentedControl *segmentedControl;

@property(nonatomic, weak) CKCalendarView *calendar;

@end

@implementation CITSearchViewController {
    
    NSArray *adultOptions;
    NSArray *childrenOptions;
    NSArray *infantOptions;
    NSArray *tariffOptions;
    
    NSArray *searchResults;
    
    UIAlertView *alertView;
    TRAutocompleteView *originAutocompleteView;
    TRAutocompleteView *destAutocompleteView;
    
    BOOL isStartDate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    if (self.journeyParams.toDate != nil) {
        self.segmentedControl.selectedSegmentIndex = 1;
        [self segmentedControlChangedValue:self.segmentedControl];
    }
    
    [self customizeTextFields];
    [self initializeOptions];
    
    self.journeyParams.fromDate = [self.journeyParams getFromDate];
    [self.fromDatePicker updateDateLabels:self.journeyParams.fromDate];
    [self.fromDatePicker.btn addTarget:self action:@selector(getStartDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.journeyParams.toDate = [self.journeyParams getToDate];
    [self.toDatePicker updateDateLabels:self.journeyParams.toDate];
    self.toDatePicker.headerLabel.text = NSLocalizedString(@"return_date", nil);
    [self.toDatePicker.btn addTarget:self action:@selector(getEndDate:) forControlEvents:UIControlEventTouchUpInside];

    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:[NSString stringWithFormat:NSLocalizedString(@"unknown_error", nil), @"Please try again"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    isStartDate = NO;
}

- (void)initializeOptions
{
    adultOptions = [CITUtils getOptionsForType:ADULTS];
    childrenOptions = [CITUtils getOptionsForType:CHILDREN];
    infantOptions = [CITUtils getOptionsForType:INFANTS];
    tariffOptions = [CITUtils getOptionsForType:CABIN];
    
    if (self.journeyParams.tariff) {
        [self.tariffButton setTitle:[CITUtils prependSpace:self.journeyParams.tariff] forState:UIControlStateNormal];
    } else {
        [self.tariffButton setTitle:[CITUtils prependSpace:[tariffOptions firstObject]] forState:UIControlStateNormal];
    }
    
    if (self.journeyParams.adults) {
        [self.adultButton setTitle:[CITUtils prependSpace:self.journeyParams.adults] forState:UIControlStateNormal];
    } else {
        [self.adultButton setTitle:[CITUtils prependSpace:[adultOptions firstObject]] forState:UIControlStateNormal];
    }
    
    if (self.journeyParams.children) {
        [self.childrenButton setTitle:[CITUtils prependSpace:self.journeyParams.children] forState:UIControlStateNormal];
    } else {
        [self.childrenButton setTitle:[CITUtils prependSpace:[childrenOptions firstObject]] forState:UIControlStateNormal];
    }
    
    if (self.journeyParams.infants) {
        [self.infantButton setTitle:[CITUtils prependSpace:self.journeyParams.infants] forState:UIControlStateNormal];
    } else {
        [self.infantButton setTitle:[CITUtils prependSpace:[infantOptions firstObject]] forState:UIControlStateNormal];
    }
}

- (void)customizeTextFields
{
    self.originTexField.delegate = self;
    if (self.journeyParams.originAirport && self.journeyParams.originCode) {
        self.originTexField.text = self.journeyParams.originAirport;
    }
    originAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.originTexField
                                                         usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                         cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                        presentingIn:self];
    
    originAutocompleteView.backgroundColor = [CITUtils appDarkBlueColor];
    
    originAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        //originCode = flightData.code;
        self.journeyParams.originCode = flightData.code;
    };
    
    self.destTextField.delegate = self;
    if (self.journeyParams.destAirport && self.journeyParams.destCode) {
        self.destTextField.text = self.journeyParams.destAirport;
    }
    destAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.destTextField
                                                        usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                        cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                       presentingIn:self];
    
    destAutocompleteView.backgroundColor = [CITUtils appDarkBlueColor];
    
    destAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        //destCode = flightData.code;
        self.journeyParams.destCode = flightData.code;
    };

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)getStartDate:(id)sender {
    [self showCalendar:YES];
}

- (IBAction)getEndDate:(id)sender {
    
    [self showCalendar:NO];
}

- (void)showCalendar:(BOOL)start
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.frame = CGRectMake(10, 10, self.view.bounds.size.width, 320);
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    calendar.delegate = self;
    
    self.calendar = calendar;
    [self.view addSubview:calendar];
    
    isStartDate = start;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    self.containerView.hidden = YES;
    self.toDatePicker.hidden = YES;
    self.journeyParams.journeyType = TWO_WAY;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.journeyParams.journeyType = ONE_WAY;
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        self.toDatePicker.hidden = NO;
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        self.containerView.hidden = NO;
    }
}

- (IBAction)selectTariffType:(id)sender {
    [self showPickerViewWithOptions:tariffOptions type:CABIN selectedOption:self.journeyParams.tariff];
}

- (IBAction)selectAdults:(id)sender {
    [self showPickerViewWithOptions:adultOptions type:ADULTS selectedOption:self.journeyParams.adults];
}

- (IBAction)selectChildren:(id)sender {
    [self showPickerViewWithOptions:childrenOptions type:CHILDREN selectedOption:self.journeyParams.children];
}

- (IBAction)selectInfants:(id)sender {
    [self showPickerViewWithOptions:infantOptions type:INFANTS selectedOption:self.journeyParams.infants];
}

- (void)showPickerViewWithOptions:(NSArray *)options type:(NSString *)type selectedOption:(NSString *)selectedOption
{
    [MMPickerView showPickerViewInView:self.view
           withStrings:options
           withOptions:@{MMshowsSelectionIndicator: @"1", MMselectedObject: selectedOption, MMbuttonColor:[CITUtils appDarkBlueColor]}
            completion:^(NSString *selectedOption) {
                [self selectionCompleteWith:selectedOption selectionType:type];
            }];
}

- (void)selectionCompleteWith:(NSString *)selectedOption selectionType:(NSString *)type
{
    if ([type isEqualToString:ADULTS]) {
        self.journeyParams.adults = selectedOption;
        [self.adultButton setTitle:[CITUtils prependSpace:self.journeyParams.adults] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CHILDREN]) {
        self.journeyParams.children = selectedOption;
        [self.childrenButton setTitle:[CITUtils prependSpace:self.journeyParams.children] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:INFANTS]) {
        self.journeyParams.infants = selectedOption;
        [self.infantButton setTitle:[CITUtils prependSpace:self.journeyParams.infants] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CABIN]) {
        self.journeyParams.tariff = selectedOption;
        [self.tariffButton setTitle:self.journeyParams.tariff forState:UIControlStateNormal];
    }
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSingleDestinationFlightResults"]) {
        
        // Get destination view
        CITSearchResultsViewController *vc = [segue destinationViewController];
        vc.flightResults = searchResults;
    }
}

- (IBAction)searchFlights:(id)sender {
    
    NSString *msg = [self.journeyParams validate];
    if (msg) {
        alertView.message = msg;
        [alertView show];
    }
    else {
        MKNetworkOperation *searchFlightsOperation = [ [CITUtils networkEngine] searchFlightsForJourney:self.journeyParams CompletionHandler:^(NSArray *flights) {
            
            searchResults = flights;
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier: @"showSingleDestinationFlightResults" sender: self];
            
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
        [CITUtils saveJourneyParams:self.journeyParams];
        
        // save to history
        [self.journeyParams saveToHistory];
    }
}

- (IBAction)showHistory:(id)sender {
    [self performSegueWithIdentifier: @"showHistory" sender: self];
}

#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if (isStartDate) {
        self.journeyParams.fromDate = date;
        [self.fromDatePicker updateDateLabels:date];
    } else {
        self.journeyParams.toDate = date;
        [self.toDatePicker updateDateLabels:date];
    }
    
    calendar.hidden = YES;
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    BOOL allowSelection = YES;
    if ([CITUtils compareDate1:[CITUtils getDateFromTodayPlus:(isStartDate ? DAYS_GAP : DAYS_GAP+1)] Date2:date] == NSOrderedDescending) {
        allowSelection = NO;
    }
    
    return allowSelection;
}

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    
    NSDate *selectedDate = self.journeyParams.toDate;
    if (isStartDate) {
        selectedDate = self.journeyParams.fromDate;
    }

    // dt == date
    if ([CITUtils compareDate1:selectedDate Date2:date] == NSOrderedSame) {
        dateItem.backgroundColor = [CITUtils appBlueColor];
        dateItem.textColor = [UIColor blackColor];
    }
    // dt < date
    else if ([CITUtils compareDate1:[CITUtils getDateFromTodayPlus:(isStartDate ? DAYS_GAP : DAYS_GAP+1)] Date2:date] == NSOrderedAscending || [CITUtils compareDate1:[CITUtils getDateFromTodayPlus:(isStartDate ? DAYS_GAP : DAYS_GAP+1)] Date2:date] == NSOrderedSame) {
        dateItem.backgroundColor = [UIColor whiteColor];
        dateItem.textColor = [UIColor blackColor];
    }
    // dt > date
    else {
        dateItem.backgroundColor = [UIColor lightTextColor];
        dateItem.textColor = [UIColor lightGrayColor];
    }
    
    // if current date == date, then background color = red
    if ([CITUtils compareDate1:[NSDate date] Date2:date] == NSOrderedSame) {
        dateItem.backgroundColor = [CITUtils calendarRedColor];
    }
}

@end
