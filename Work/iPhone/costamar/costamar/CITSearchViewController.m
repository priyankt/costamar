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

#define ADULTS 1
#define INFANTS 2
#define CHILDREN 3
#define TARIFF 4

@interface CITSearchViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originTexField;
@property (weak, nonatomic) IBOutlet UITextField *destTextField;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UILabel *startDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *startMonthAndYearLabel;

@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIView *endDateView;
@property (weak, nonatomic) IBOutlet UILabel *endDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *endMonthAndYearLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *tariffButton;
@property (weak, nonatomic) IBOutlet UIButton *adultButton;
@property (weak, nonatomic) IBOutlet UIButton *childrenButton;
@property (weak, nonatomic) IBOutlet UIButton *infantButton;

@property(nonatomic, weak) CKCalendarView *calendar;

@end

@implementation CITSearchViewController {
    NSString *adults;
    NSString *children;
    NSString *infants;
    NSArray *tariffOptions;
    NSString *tariffType;
    
    NSString *originCode;
    NSString *destCode;
    
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
    [self initializeSegmentedControl];
    [self customizeTextFields];
    [self setViewBorder:self.startView];
    [self setViewBorder:self.endView];
    [self setTariffOptions];
    
    self.endDateView.hidden = YES;
    isStartDate = NO;
}

- (void)setTariffOptions
{
    tariffOptions = [[NSArray alloc] initWithObjects:@"Economica", @"Economica Premium", @"Primera", @"Ejecutiva", nil];
}

- (void)setViewBorder:(UIView *)view
{
    view.layer.masksToBounds=YES;
    view.layer.borderWidth= 1.0f;
    view.layer.borderColor = [[UIColor colorWithHexString:@"#c6c6c6"] CGColor];
}

- (void)customizeTextFields
{
    [self setViewBorder:self.originTexField];
    [self addRightView:self.originTexField];
    self.originTexField.delegate = self;
    originAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.originTexField
                                                         usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                         cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                        presentingIn:self];
    
    originAutocompleteView.backgroundColor = [UIColor colorWithHexString:@"#08558c"];
    
    originAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        originCode = flightData.code;
    };
    
    [self setViewBorder:self.destTextField];
    [self addRightView:self.destTextField];
    self.destTextField.delegate = self;
    destAutocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.destTextField
                                                        usingSource:[[CITFlightDataSource alloc] initWithMinimumCharactersToTrigger:2]
                                                        cellFactory:[[CITFlightAutocompleteCellFactory alloc] initWithCellForegroundColor:[UIColor whiteColor] fontSize:14]
                                                       presentingIn:self];
    
    destAutocompleteView.backgroundColor = [UIColor colorWithHexString:@"#08558c"];;
    
    destAutocompleteView.didAutocompleteWith = ^(id<TRSuggestionItem> item)
    {
        CITFlightSuggestion *flightData = (CITFlightSuggestion *)item;
        destCode = flightData.code;
    };

}

- (void)addRightView:(UITextField *)textField
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_location.png"]];
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor colorWithHexString:@"#c6c6c6"].CGColor;
    sublayer.frame = CGRectMake(0, 0, 1, imageView.frame.size.height);
    [imageView.layer addSublayer:sublayer];
    //[rightView addSubview:imageView];
    
    textField.rightView = imageView;
    textField.rightViewMode = UITextFieldViewModeAlways;
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
    self.calendar = calendar;
    calendar.delegate = self;
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    isStartDate = start;
}

- (void)initializeSegmentedControl
{
    /*
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
     */
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Sólo Ida", @"Ida y vuelta", @"Multidestino"]];
    [segmentedControl setFrame:CGRectMake(0, 0, 320, 40)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_pressed.png"]]];
    [segmentedControl setFont:[UIFont systemFontOfSize:14]];
    [segmentedControl setTextColor:[UIColor whiteColor]];
    [segmentedControl setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [segmentedControl setSelectionLocation:HMSegmentedControlSelectionLocationDown];
    
    [self.view addSubview:segmentedControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    self.containerView.hidden = YES;
    self.endDateView.hidden = YES;
    
    if (segmentedControl.selectedSegmentIndex == 1) {
        self.endDateView.hidden = NO;
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        self.containerView.hidden = NO;
    }
}

- (IBAction)selectTariffType:(id)sender {
    [self showPickerViewWithOptions:tariffOptions type:TARIFF];
}

- (IBAction)selectAdults:(id)sender {
    [self showPickerViewWithOptions:[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",nil] type:ADULTS];
}

- (IBAction)selectChildren:(id)sender {
    [self showPickerViewWithOptions:[[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",nil] type:CHILDREN];
}

- (IBAction)selectInfants:(id)sender {
    [self showPickerViewWithOptions:[[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",nil] type:INFANTS];
}

- (void)showPickerViewWithOptions:(NSArray *)options type:(int)type
{
    [MMPickerView showPickerViewInView:self.view
                           withStrings:options
                           withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1"}
                            completion:^(NSString *selectedOption) {
                                switch (type) {
                                    case ADULTS:
                                        adults = selectedOption;
                                        self.adultButton.titleLabel.text = [NSString stringWithFormat:@" %@", adults];
                                        break;
                                    case CHILDREN:
                                        children = selectedOption;
                                        self.childrenButton.titleLabel.text = [NSString stringWithFormat:@" %@", children];
                                        break;
                                    case INFANTS:
                                        infants = selectedOption;
                                        self.infantButton.titleLabel.text = [NSString stringWithFormat:@" %@", infants];
                                        break;
                                    case TARIFF:
                                        tariffType = selectedOption;
                                        self.tariffButton.titleLabel.text = tariffType;
                                    default:
                                        break;
                                }
                            }];

}

#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMM ''yy"];
    if (isStartDate) {
        self.startMonthAndYearLabel.text = [formatter stringFromDate:date];
    }
    else {
        self.endMonthAndYearLabel.text = [formatter stringFromDate:date];
    }
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    if (isStartDate) {
        self.startDayLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    }
    else {
        self.endDayLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    }
    
    calendar.hidden = YES;
}

@end
