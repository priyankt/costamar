//
//  CITPassengerInfoViewController.m
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITPassengerInfoViewController.h"
#import "CITJourneyData.h"
#import "CITPax.h"
#import "CITAdultPassengerCell.h"
#import "CITChildPassengerCell.h"
#import "CITInfantPassengerCell.h"
#import "CITPayerDetailsCell.h"
#import "MMPickerView.h"
#import "CITUtils.h"
#import "CITFlightPayer.h"
#import "CITPassengerInfoTextField.h"
#import "CITPassengerInfoSelectButton.h"
#import "CITBookingPayment.h"
#import "CITBookingResponse.h"
#import "SVProgressHUD.h"
#import "CITBookingResponseViewController.h"
#import "CITPaymentOption.h"
#import "CITFlightDetailData.h"
#import "CITNetworkEngine.h"

#define BOOKING_RESPONSE_SEGUE_ID @"showBookingResponse"

@interface CITPassengerInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *fromCityButton;
@property (weak, nonatomic) IBOutlet UIButton *toCityLButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CITPassengerInfoViewController {
    NSArray *paxList;
    NSArray *titleOptions;
    NSArray *docTypeOptions;
    NSArray *countriesOptions;
    NSMutableArray *adultAssignedOptions;
    CITFlightPayer *payerDetails;
    
    int adultCount;
    int childCount;
    int infantCount;
    
    int selectedIndex;
    
    UIDatePicker *datePicker;
    UIToolbar *datePickerToolbar;
    
    UITextField *activeDatePickerTextField;
    UIAlertView *alertView;
    
    CITBookingResponse *mBookingResponse;
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.headerView.layer.borderWidth= 1.0f;
    self.headerView.layer.borderColor = [[CITUtils borderColor] CGColor];
    
    paxList = [self.journeyParams getPaxList];
    titleOptions = [CITUtils getOptionsForType:TITLES];
    docTypeOptions = [CITUtils getOptionsForType:DOC_TYPES];
    countriesOptions = [CITUtils getOptionsForType:COUNTRIES];
    adultAssignedOptions = [[NSMutableArray alloc] init];
    payerDetails = [[CITFlightPayer alloc] initWithPaymentSupplier:self.paymentOption.supplierid];
    
    adultCount = childCount = infantCount = 1;
    
    [self.fromCityButton setTitle:self.detailData.cityFrom forState:UIControlStateNormal];
    [self.toCityLButton setTitle:self.detailData.cityTo forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", self.detailData.price];
    self.flightName.text = self.detailData.airline;
    
    [self initializeDatePicker];
    
    alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok_button_title", nil) otherButtonTitles:nil];
}

- (void)initializeDatePicker
{
    datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    datePickerToolbar.tintColor = [CITUtils appDarkBlueColor];
    //[datePickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePickingDate:)];
    
    [datePickerToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, done, nil]];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
}

- (void)donePickingDate:(UIBarButtonItem *)doneButton
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:BOOKING_RESPONSE_SEGUE_ID]) {
        CITBookingResponseViewController *bookingResponseViewController = segue.destinationViewController;
        bookingResponseViewController.bookingResponse = mBookingResponse;
    }
}

- (NSString *)validate
{
    NSString *msg = nil;
    for (CITPax *pax in paxList) {
        msg = [pax validate];
        if (msg && [msg length] > 0) {
            alertView.message = msg;
            [alertView show];
            break;
        }
    }
    
    msg = [payerDetails validate];
    if (msg && [msg length] > 0) {
        alertView.message = msg;
        [alertView show];
    }
    
    return msg;
}

- (IBAction)reserveFlight:(id)sender {
    
    NSString *msg = [self validate];
    
    if (msg == nil ) {
        CITBookingPayment *bookingPayment = [[CITBookingPayment alloc] initWithPayer:payerDetails paxList:paxList flightid:self.detailData.flightid];
        // call rest api for booking
        MKNetworkOperation *bookingOperation = [ [CITUtils networkEngine] bookFlightWithBookingPayment:bookingPayment CompletionHandler:^(CITBookingResponse *bookingResponse) {
            
            mBookingResponse = bookingResponse;
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:BOOKING_RESPONSE_SEGUE_ID sender:self];
            
        } errorHandler:^(NSError *error){
            
            [SVProgressHUD dismiss];
            alertView.message = [NSString stringWithFormat:NSLocalizedString(@"unknown_error", nil), error.localizedDescription];
            [alertView show];
            
        }];
        
        // Get flight details
        [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
        
        bookingOperation.postDataEncoding = MKNKPostDataEncodingTypeJSON;
        [[CITUtils networkEngine] enqueueOperation:bookingOperation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(CITPassengerInfoTextField *)textField
{
    // copy the text field value into corresponding object
    if (textField.type == PASSENGER_NAME) {
        CITPax *pax = paxList[textField.tag - 1000];
        pax.name = textField.text;
    }
    if (textField.type == PASSENGER_LASTNAMEM) {
        CITPax *pax = paxList[textField.tag - 1000];
        pax.lastnamem = textField.text;
    }
    if (textField.type == PASSENGER_LASTNAMEP) {
        CITPax *pax = paxList[textField.tag - 1000];
        pax.lastnamep = textField.text;
    }
    if (textField.type == PASSENGER_DOC_NUMBER) {
        CITPax *pax = paxList[textField.tag - 1000];
        pax.docNumber = textField.text;
    }
    if (textField.type == PASSENGER_BIRTHDATE) {
        CITPax *pax = paxList[textField.tag - 1000];
        NSDateFormatter *f = [CITUtils dateFormatter];
        pax.birthday = [f stringFromDate:datePicker.date];
        textField.text = [f stringFromDate:datePicker.date];
    }
    if (textField.type == PAYER_EMAIL) {
        payerDetails.email = textField.text;
    }
    if (textField.type == PAYER_CONFIRM_EMAIL) {
        payerDetails.confirmEmail = textField.text;
    }
    if (textField.type == PAYER_PHONE) {
        payerDetails.phone = textField.text;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // Section 1 => adult, child, infant info
    // Section 2 => Payer Info
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 1;
    // Return the number of rows in the section.
    if (section == 0) {
        rowCount = [paxList count];
    }
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    if (indexPath.section == 0) {
        CITPax *pax = paxList[indexPath.row];
        if ([pax.paxType isEqualToString:ADULT]) {
            rowHeight = 300;
        }
        if ([pax.paxType isEqualToString:CHILD]) {
            rowHeight = 200;
        }
        if ([pax.paxType isEqualToString:INFANT]) {
            rowHeight = 240;
        }
    } else {
        rowHeight = 235;
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        CITPax *pax = paxList[indexPath.row];
        if ([pax.paxType isEqualToString:ADULT]) {
            CITAdultPassengerCell *adultCell = [tableView dequeueReusableCellWithIdentifier:@"adultCell" forIndexPath:indexPath];
            if ([adultCell.adultLabel.text length] <= 0) {
                adultCell.adultLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_adult_no", nil), adultCount++];
                [adultCell.adultLabel.layer setBorderColor: [[CITUtils appOrangeColor] CGColor]];
                [adultCell.adultLabel.layer setBorderWidth: 1.0f];
            }
            
            if ([pax.title length] == 0) {
                pax.title = titleOptions.firstObject;
            }
            adultCell.titleButton.translatesAutoresizingMaskIntoConstraints = NO;
            adultCell.titleButton.tag = 1000 + indexPath.row;
            adultCell.titleButton.type = PASSENGER_TITLE;
            [adultCell.titleButton setTitle:[CITUtils getOptionForValue:pax.title type:TITLES] forState:UIControlStateNormal];
            [adultCell.titleButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
            
            adultCell.nameLabel.tag = 1000 + indexPath.row;
            adultCell.nameLabel.type = PASSENGER_NAME;
            adultCell.nameLabel.text = pax.name;
            adultCell.nameLabel.delegate = self;
            
            adultCell.lastNameM.tag = 1000 + indexPath.row;
            adultCell.lastNameM.type = PASSENGER_LASTNAMEM;
            adultCell.lastNameM.text = pax.lastnamem;
            adultCell.lastNameM.delegate = self;
            
            adultCell.lastNameP.tag = 1000 + indexPath.row;
            adultCell.lastNameP.type = PASSENGER_LASTNAMEP;
            adultCell.lastNameP.text = pax.lastnamep;
            adultCell.lastNameP.delegate = self;
            
            if ([pax.countryDocType length] == 0) {
                pax.countryDocType = countriesOptions.firstObject;
            }
            adultCell.countryButton.tag = 1000 + indexPath.row;
            adultCell.countryButton.type = PASSENGER_COUNTRY;
            [adultCell.countryButton setTitle:[CITUtils getOptionForValue:pax.countryDocType type:COUNTRIES] forState:UIControlStateNormal];
            [adultCell.countryButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([pax.docType length] == 0) {
                pax.docType = docTypeOptions.firstObject;
            }
            adultCell.docTypeButton.tag = 1000 + indexPath.row;
            adultCell.docTypeButton.type = PASSENGER_DOC_TYPE;
            [adultCell.docTypeButton setTitle:[CITUtils getOptionForValue:pax.docType type:DOC_TYPES] forState:UIControlStateNormal];
            [adultCell.docTypeButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
            
            adultCell.docNumber.tag = 1000 + indexPath.row;
            adultCell.docNumber.type = PASSENGER_DOC_NUMBER;
            adultCell.docNumber.text = pax.docNumber;
            adultCell.docNumber.delegate = self;
            
            // insert adult index into adultassigned array
            [adultAssignedOptions addObject:[NSString stringWithFormat:@"%d", adultCount-1]];
            cell = adultCell;
        }
        if ([pax.paxType isEqualToString:CHILD]) {
            CITChildPassengerCell *childCell = [tableView dequeueReusableCellWithIdentifier:@"childCell" forIndexPath:indexPath];
            if ([childCell.childLabel.text length] <= 0) {
                childCell.childLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_child_no", nil), childCount++];
                [childCell.childLabel.layer setBorderColor: [[CITUtils appOrangeColor] CGColor]];
                [childCell.childLabel.layer setBorderWidth: 1.0f];
            }
            
            childCell.nameLabel.tag = 1000 + indexPath.row;
            childCell.nameLabel.type = PASSENGER_NAME;
            childCell.nameLabel.text = pax.name;
            childCell.nameLabel.delegate = self;
            
            childCell.lastNameP.tag = 1000 + indexPath.row;
            childCell.lastNameP.type = PASSENGER_LASTNAMEP;
            childCell.lastNameP.text = pax.lastnamep;
            childCell.lastNameP.delegate = self;

            childCell.lastNameM.tag = 1000 + indexPath.row;
            childCell.lastNameM.type = PASSENGER_LASTNAMEM;
            childCell.lastNameM.text = pax.lastnamem;
            childCell.lastNameM.delegate = self;
            
            childCell.dobLabel.tag = 1000 + indexPath.row;
            childCell.dobLabel.type = PASSENGER_BIRTHDATE;
            childCell.dobLabel.inputAccessoryView = datePickerToolbar;
            childCell.dobLabel.inputView = datePicker;
            childCell.dobLabel.text = pax.birthday;
            childCell.dobLabel.delegate = self;
            
            cell = childCell;
        }
        if ([pax.paxType isEqualToString:INFANT]) {
            CITInfantPassengerCell *infantCell = [tableView dequeueReusableCellWithIdentifier:@"infantCell" forIndexPath:indexPath];
            infantCell.tag = indexPath.row;
            if ([infantCell.infantLabel.text length] <= 0) {
                infantCell.infantLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_infant_no", nil), infantCount++];
                [infantCell.infantLabel.layer setBorderColor: [[CITUtils appOrangeColor] CGColor]];
                [infantCell.infantLabel.layer setBorderWidth: 1.0f];
            }
            
            infantCell.nameLabel.tag = 1000 + indexPath.row;
            infantCell.nameLabel.type = PASSENGER_NAME;
            infantCell.nameLabel.text = pax.name;
            infantCell.nameLabel.delegate = self;
            
            infantCell.lastNameP.tag = 1000 + indexPath.row;
            infantCell.lastNameP.type = PASSENGER_LASTNAMEP;
            infantCell.lastNameP.text = pax.lastnamep;
            infantCell.lastNameP.delegate = self;
            
            infantCell.lastNameM.tag = 1000 + indexPath.row;
            infantCell.lastNameM.type = PASSENGER_LASTNAMEM;
            infantCell.lastNameM.text = pax.lastnamem;
            infantCell.lastNameM.delegate = self;
            
            infantCell.dobLabel.tag = 1000 + indexPath.row;
            infantCell.dobLabel.type = PASSENGER_BIRTHDATE;
            infantCell.dobLabel.inputAccessoryView = datePickerToolbar;
            infantCell.dobLabel.inputView = datePicker;
            infantCell.dobLabel.text = pax.birthday;
            infantCell.dobLabel.delegate = self;
            
            if (!pax.adtassigned) {
                pax.adtassigned = [adultAssignedOptions.firstObject integerValue];
            }
            infantCell.adultInchargeButton.tag = 1000 + indexPath.row;
            infantCell.adultInchargeButton.type = PASSENGER_ASSIGNED_ADULT;
            [infantCell.adultInchargeButton setTitle:[NSString stringWithFormat:@"%d", pax.adtassigned] forState:UIControlStateNormal];
            [infantCell.adultInchargeButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
            cell = infantCell;
        }
    } else {
        CITPayerDetailsCell *payerCell = [tableView dequeueReusableCellWithIdentifier:@"payerCell" forIndexPath:indexPath];
        
        if ([payerDetails.country length] == 0) {
            payerDetails.country = countriesOptions.firstObject;
        }
        payerCell.citySelectButton.tag = 2000;
        payerCell.citySelectButton.type = PAYER_COUNTRY;
        [payerCell.citySelectButton setTitle:[CITUtils getOptionForValue:payerDetails.country type:COUNTRIES] forState:UIControlStateNormal];
        [payerCell.citySelectButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];

        payerCell.emailLabel.type = PAYER_EMAIL;
        payerCell.emailLabel.text = payerDetails.email;
        payerCell.emailLabel.delegate = self;

        payerCell.confirmEmailLabel.type = PAYER_CONFIRM_EMAIL;
        payerCell.confirmEmailLabel.delegate = self;
        
        payerCell.phoneLabel.type = PAYER_PHONE;
        payerCell.phoneLabel.text = payerDetails.phone;
        payerCell.phoneLabel.delegate = self;

        cell = payerCell;
    }
    
    return cell;
}

- (void)showPickerView:(CITPassengerInfoSelectButton *)sender
{
    // hide keyboard else it blocks picker
    [self.view endEditing:YES];
    
    if (sender.type == PASSENGER_TITLE) {
        CITPax *pax = paxList[sender.tag - 1000];
        [MMPickerView showPickerViewInView:self.view
               withStrings:titleOptions
               withOptions:@{MMshowsSelectionIndicator: @"1", MMselectedObject: pax.title, MMbuttonColor:[CITUtils appDarkBlueColor]}
                completion:^(NSString *selectedOption) {
                    [sender setTitle:selectedOption forState:UIControlStateNormal];
                    pax.title = selectedOption;
                }];

    }
    if (sender.type == PASSENGER_COUNTRY) {
        CITPax *pax = paxList[sender.tag - 1000];
        [MMPickerView showPickerViewInView:self.view
               withStrings:countriesOptions
               withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject: pax.countryDocType, MMbuttonColor:[CITUtils appDarkBlueColor]}
                completion:^(NSString *selectedOption) {
                    [sender setTitle:selectedOption forState:UIControlStateNormal];
                    pax.countryDocType = selectedOption;
                }];
    }
    if (sender.type == PASSENGER_DOC_TYPE) {
        CITPax *pax = paxList[sender.tag - 1000];
        [MMPickerView showPickerViewInView:self.view
               withStrings:docTypeOptions
               withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject: pax.docType, MMbuttonColor:[CITUtils appDarkBlueColor]}
                completion:^(NSString *selectedOption) {
                    [sender setTitle:selectedOption forState:UIControlStateNormal];
                    pax.docType = selectedOption;
                }];
    }
    if (sender.type == PASSENGER_ASSIGNED_ADULT) {
        CITPax *pax = paxList[sender.tag - 1000];
        [MMPickerView showPickerViewInView:self.view
               withStrings:adultAssignedOptions
               withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject: [NSString stringWithFormat:@"%d", pax.adtassigned], MMbuttonColor:[CITUtils appDarkBlueColor]}
                completion:^(NSString *selectedOption) {
                    [sender setTitle:selectedOption forState:UIControlStateNormal];
                    pax.adtassigned = [selectedOption intValue];
                }];
    }
    if (sender.type == PAYER_COUNTRY) {
        [MMPickerView showPickerViewInView:self.view
               withStrings:countriesOptions
               withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject: payerDetails.country, MMbuttonColor:[CITUtils appDarkBlueColor]}
                completion:^(NSString *selectedOption) {
                    [sender setTitle:selectedOption forState:UIControlStateNormal];
                    payerDetails.country = selectedOption;
                }];
    }
}

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}
*/
@end
