//
//  CITAgreementViewController.m
//  costamar
//
//  Created by Mahavir Jain on 14/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITAgreementViewController.h"
#import "CITPassengerInfoViewController.h"
#import "CITUtils.h"
#import "CITFlightDetailData.h"

#define PASSENGER_INFO_SEGUE_ID @"passengerInfo"

@interface CITAgreementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CITAgreementViewController

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
    self.textView.text = self.detailData.flightPolicy;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:PASSENGER_INFO_SEGUE_ID]){
        CITPassengerInfoViewController *passengerInfoViewController = segue.destinationViewController;
        passengerInfoViewController.detailData = self.detailData;
        passengerInfoViewController.paymentOption = self.paymentOption;
        passengerInfoViewController.journeyParams = [CITUtils retrieveJourneyParams];
    }
}

- (IBAction)obtainPassengerDetails:(id)sender {
    [self performSegueWithIdentifier:PASSENGER_INFO_SEGUE_ID sender:self];
}

@end
