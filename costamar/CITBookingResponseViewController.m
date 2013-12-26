//
//  CITBookingResponseViewController.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITBookingResponseViewController.h"
#import "CITBookingResponse.h"

@interface CITBookingResponseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation CITBookingResponseViewController

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
    if ([self.bookingResponse.codePayment length] > 0) {
        self.messageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"booking_successful_payment", nil), self.bookingResponse.codePayment];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
