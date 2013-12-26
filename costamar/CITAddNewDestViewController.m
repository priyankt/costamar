//
//  CITAddNewDestViewController.m
//  costamar
//
//  Created by Mahavir Jain on 18/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITAddNewDestViewController.h"
#import "UIColor+InnerBand.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageSpinner.h"
#import "CKCalendarView.h"
#import "CITTextField.h"
#import "TRAutocompleteView.h"
#import "CITFlightDataSource.h"
#import "CITFlightAutocompleteCellFactory.h"
#import "CITFlightSuggestion.h"
#import "CITDatePicker.h"
#import "CITUtils.h"
#import "CITMultiDestCityData.h"
#import "CITMultiDestData.h"

@interface CITAddNewDestViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet CITTextField *originTextField;
@property (weak, nonatomic) IBOutlet CITTextField *destTextField;
@property (weak, nonatomic) IBOutlet CITDatePicker *datePickerView;

@property(nonatomic, weak) CKCalendarView *calendar;

@end

@implementation CITAddNewDestViewController {
    
    CITMultiDestCityData *cityData;
    
    TRAutocompleteView *originAutocompleteView;
    TRAutocompleteView *destAutocompleteView;
    
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
    cityData = [[CITMultiDestCityData alloc] init];
    cityData.dateFrom = [CITUtils getDateFromTodayPlus:DAYS_GAP];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self customizeTextFields];

    [self.datePickerView updateDateLabels:[CITUtils getDateFromTodayPlus:DAYS_GAP]];
    [self.datePickerView.btn addTarget:self action:@selector(getStartDate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)customizeTextFields
{
    self.originTextField.delegate = self;
    originAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.originTextField
                                                              usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                              cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                             presentingIn:self];
    
    originAutocompleteView.backgroundColor = [CITUtils appBlueColor];
    
    originAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        cityData.originCode = flightData.code;
    };

    self.destTextField.delegate = self;
    destAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.destTextField
                                                            usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                            cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                           presentingIn:self];
    
    destAutocompleteView.backgroundColor = [CITUtils appBlueColor];
    
    destAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        cityData.destCode = flightData.code;
    };

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.originTextField) {
        [self.destTextField becomeFirstResponder];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartDate:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
}

- (IBAction)dismissModal:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewDestination:(id)sender {
    [self.multiDestData.cities addObject:cityData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    cityData.dateFrom = date;
    [self.datePickerView updateDateLabels:date];
    
    calendar.hidden = YES;
}

@end
