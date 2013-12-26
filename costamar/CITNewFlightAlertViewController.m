//
//  CITNewFlightAlertViewController.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITNewFlightAlertViewController.h"
#import "CITTextField.h"
#import "CITDatePicker.h"
#import "CITSegmentedControl.h"
#import "CKCalendarView.h"
#import "TRAutocompleteView.h"
#import "CITUtils.h"
#import "CITFlightAlert.h"
#import "CITFlightDataSource.h"
#import "CITFlightAutocompleteCellFactory.h"
#import "CITFlightSuggestion.h"
#import "MMPickerView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "CITJourneyData.h"

@interface CITNewFlightAlertViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet CITTextField *originTextField;
@property (weak, nonatomic) IBOutlet CITTextField *destTextField;
@property (weak, nonatomic) IBOutlet CITDatePicker *fromDatePicker;
@property (weak, nonatomic) IBOutlet CITDatePicker *toDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UIButton *tariffButton;
@property (weak, nonatomic) IBOutlet UIButton *adultButton;
@property (weak, nonatomic) IBOutlet UIButton *childrenButton;
@property (weak, nonatomic) IBOutlet UIButton *infantButton;
@property (weak, nonatomic) IBOutlet UIButton *frequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *alertTypeButton;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (weak, nonatomic) IBOutlet CITSegmentedControl *segmentedControl;

@property(nonatomic, weak) CKCalendarView *calendar;

@end

@implementation CITNewFlightAlertViewController {
    
    NSArray *adultOptions;
    NSArray *childrenOptions;
    NSArray *infantOptions;
    NSArray *tariffOptions;
    NSArray *frequencyOptions;
    NSArray *alertTypeOptions;
    
    TRAutocompleteView *originAutocompleteView;
    TRAutocompleteView *destAutocompleteView;
    
    BOOL isStartDate;
    
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
    self.segmentedControl.sectionTitles = @[NSLocalizedString(@"btn_one_way", nil),NSLocalizedString(@"btn_multi_way", nil)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self customizeTextFields];
    
    [self initializePickers];
    
    self.journeyData.fromDate = [self.journeyData getFromDate];
    [self.fromDatePicker updateDateLabels:self.journeyData.fromDate];
    [self.fromDatePicker.btn addTarget:self action:@selector(getDateFromPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    self.journeyData.toDate = [self.journeyData getToDate];
    [self.toDatePicker updateDateLabels:self.journeyData.toDate];
    self.toDatePicker.headerLabel.text = NSLocalizedString(@"return_date", nil);
    [self.toDatePicker.btn addTarget:self action:@selector(getDateFromPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    isStartDate = NO;
    
    alertView = [CITUtils alertView];
}

- (void)initializePickers
{
    adultOptions = [CITUtils getOptionsForType:ADULTS];
    if (!self.journeyData.adults || [self.journeyData.adults length] == 0) {
        self.journeyData.adults = [adultOptions firstObject];
    }
    [self.adultButton setTitle:[CITUtils prependSpace:self.journeyData.adults] forState:UIControlStateNormal];
    
    childrenOptions = [CITUtils getOptionsForType:CHILDREN];
    if (!self.journeyData.children || [self.journeyData.children length] == 0) {
        self.journeyData.children = [childrenOptions firstObject];
    }
    [self.childrenButton setTitle:[CITUtils prependSpace:self.journeyData.children] forState:UIControlStateNormal];
    
    infantOptions = [CITUtils getOptionsForType:INFANTS];
    if (!self.journeyData.infants || [self.journeyData.infants length] == 0) {
        self.journeyData.infants = [infantOptions firstObject];
    }
    [self.infantButton setTitle:[CITUtils prependSpace:self.journeyData.infants] forState:UIControlStateNormal];

    tariffOptions = [CITUtils getOptionsForType:CABIN];
    if (!self.journeyData.tariff || [self.journeyData.tariff length] == 0) {
        self.journeyData.tariff = [tariffOptions firstObject];
    }
    [self.tariffButton setTitle:[CITUtils prependSpace:self.journeyData.tariff] forState:UIControlStateNormal];
    
    frequencyOptions = [CITUtils getOptionsForType:ALERT_FREQUENCY];
    if (!self.journeyData.alertFrequency || [self.journeyData.alertFrequency length] == 0) {
        self.journeyData.alertFrequency = [frequencyOptions firstObject];
    }
    [self.frequencyButton setTitle:[CITUtils prependSpace:self.journeyData.alertFrequency] forState:UIControlStateNormal];

    alertTypeOptions = [CITUtils getOptionsForType:ALERT_TYPE];
    if (!self.journeyData.alertType || [self.journeyData.alertType length] == 0) {
        self.journeyData.alertType = [alertTypeOptions firstObject];
        [self.alertTypeButton setTitle:[CITUtils prependSpace:self.journeyData.alertType] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDateFromPicker:(id)sender {
    
    if (sender == self.fromDatePicker.btn) {
        [self showCalendar:YES];
    } else {
        [self showCalendar:NO];
    }
}

- (void)showCalendar:(BOOL)isFromDate
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.frame = CGRectMake(10, 10, self.view.bounds.size.width, 320);
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    calendar.delegate = self;
    
    self.calendar = calendar;
    [self.view addSubview:calendar];
    
    isStartDate = isFromDate;
}

- (void)customizeTextFields
{
    self.originTextField.delegate = self;
    self.originTextField.text = [self.journeyData getOriginAirport];
    originAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.originTextField
                                                              usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                              cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                             presentingIn:self];
    originAutocompleteView.topMargin = originAutocompleteView.topMargin + 50;
    originAutocompleteView.backgroundColor = [CITUtils appDarkBlueColor];
    
    originAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        //originCode = flightData.code;
        self.journeyData.originCode = flightData.code;
        self.journeyData.originAirport = self.originTextField.text;
    };
    
    self.destTextField.delegate = self;
    self.destTextField.text = [self.journeyData getDestAirport];
    destAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.destTextField
                                                            usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                            cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                           presentingIn:self];
    destAutocompleteView.topMargin = destAutocompleteView.topMargin+50;
    destAutocompleteView.backgroundColor = [CITUtils appDarkBlueColor];
    
    destAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        //destCode = flightData.code;
        self.journeyData.destCode = flightData.code;
        self.journeyData.destAirport = self.destTextField.text;
    };
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    self.toDatePicker.hidden = YES;
    self.journeyData.journeyType = TWO_WAY;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.journeyData.journeyType = ONE_WAY;
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        self.toDatePicker.hidden = NO;
    }
}

- (IBAction)selectAdults:(id)sender {
    [self showPickerViewWithOptions:adultOptions type:ADULTS selectedOption:self.journeyData.adults];
}

- (IBAction)selectChildren:(id)sender {
    [self showPickerViewWithOptions:childrenOptions type:CHILDREN selectedOption:self.journeyData.children];
}

- (IBAction)selectInfants:(id)sender {
    [self showPickerViewWithOptions:infantOptions type:INFANTS selectedOption:self.journeyData.infants];
}

- (IBAction)showTariff:(id)sender {
    [self showPickerViewWithOptions:tariffOptions type:CABIN selectedOption:self.journeyData.tariff];
}

- (IBAction)selectFrequency:(id)sender {
    [self showPickerViewWithOptions:frequencyOptions type:ALERT_FREQUENCY selectedOption:self.journeyData.alertFrequency];
}

- (IBAction)selectNotificationType:(id)sender {
    [self showPickerViewWithOptions:alertTypeOptions type:ALERT_TYPE selectedOption:self.journeyData.alertType];
}

- (void)showPickerViewWithOptions:(NSArray *)options type:(NSString *)type selectedOption:(NSString *)selectedOption
{
    [self.view endEditing:YES];
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
        self.journeyData.adults = selectedOption;
        [self.adultButton setTitle:[CITUtils prependSpace:self.journeyData.adults] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CHILDREN]) {
        self.journeyData.children = selectedOption;
        [self.childrenButton setTitle:[CITUtils prependSpace:self.journeyData.children] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:INFANTS]) {
        self.journeyData.infants = selectedOption;
        [self.infantButton setTitle:[CITUtils prependSpace:self.journeyData.infants] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CABIN]) {
        self.journeyData.tariff = selectedOption;
        [self.tariffButton setTitle:self.journeyData.tariff forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ALERT_FREQUENCY]) {
        self.journeyData.alertFrequency = selectedOption;
        [self.frequencyButton setTitle:self.journeyData.alertFrequency forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ALERT_TYPE]) {
        self.journeyData.alertType = selectedOption;
        [self.alertTypeButton setTitle:self.journeyData.alertType forState:UIControlStateNormal];
    }
}

- (IBAction)createAlert:(id)sender {
    
    NSString *msg = [self.journeyData validate];
    if (msg) {
        alertView.message = msg;
        [alertView show];
    }
    else {
        [self.journeyData saveToFlightAlerts];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if (isStartDate) {
        self.journeyData.fromDate = date;
        [self.fromDatePicker updateDateLabels:date];
    } else {
        self.journeyData.toDate = date;
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
    
    NSDate *selectedDate = self.journeyData.toDate;
    if (isStartDate) {
        selectedDate = self.journeyData.fromDate;
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
