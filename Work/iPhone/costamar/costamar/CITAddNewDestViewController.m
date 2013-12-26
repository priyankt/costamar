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

@interface CITAddNewDestViewController () <CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originTextField;
@property (weak, nonatomic) IBOutlet UITextField *destTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAndYearLabel;
@property (weak, nonatomic) IBOutlet UIButton *datePickButton;
@property(nonatomic, weak) CKCalendarView *calendar;

@end

@implementation CITAddNewDestViewController

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
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self customizeTextFields];
    [self setViewBorder:self.datePickButton];
}

- (void)setViewBorder:(UIView *)view
{
    view.layer.masksToBounds=YES;
    view.layer.borderWidth= 1.0f;
    view.layer.borderColor = [[UIColor colorWithHexString:@"#c6c6c6"] CGColor];
}

- (void)customizeTextFields
{
    self.originTextField.delegate = self;
    [self setViewBorder:self.originTextField];
    [self addRightView:self.originTextField];
    
    self.destTextField.delegate = self;
    [self setViewBorder:self.destTextField];
    [self addRightView:self.destTextField];
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
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addNewDestination:(id)sender {
}

#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    //self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMM ''yy"];
    self.monthAndYearLabel.text = [formatter stringFromDate:date];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    self.dateLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    
    calendar.hidden = YES;
    
}

@end
