//
//  CITInitialViewController.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITInitialViewController.h"
#import "MMPickerView.h"
#import "UIColor+InnerBand.h"
#import "CITNetworkEngine.h"
#import "CITUtils.h"
#import "SVProgressHUD.h"
#import "CITCountryData.h"

#define SHOW_MENU_SEGUE @"showMenuView"

@interface CITInitialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *ingresarButton;

@end

@implementation CITInitialViewController {
    NSArray *options;
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
    alertView = [CITUtils alertView];
    
    // Define Fetch icons operation
    MKNetworkOperation *fetchIconsOperation = [[CITUtils networkEngine] fetchFlightIconsWithCompletionHandler:^(NSString *outputFilePath){
        
        [SVProgressHUD dismiss];
        
    } errorHandler:^(NSError *error) {
        NSLog(@"error");        
        [SVProgressHUD dismiss];
        alertView.message = [NSString stringWithFormat:NSLocalizedString(@"unknown_error", nil), error.localizedDescription];
        [alertView show];
        
    }];
    
    MKNetworkOperation *getCountriesOperation = [ [CITUtils networkEngine] getCountriesListWithCompletionHandler:^(NSArray *countries) {
        
        options = countries;
        CITCountryData *countryPreference = [CITUtils getCountryPreference];
        if (countryPreference == nil) {
            countryPreference = [options objectAtIndex:0];
            [CITUtils setCountryPreference:countryPreference];
        }
        [self.countryButton setTitle:countryPreference.countryName forState:UIControlStateNormal];
        [[CITUtils networkEngine] enqueueOperation:fetchIconsOperation];

    } errorHandler:^(NSError *error){
        NSLog(@"error");
        [SVProgressHUD dismiss];
        alertView.message = [NSString stringWithFormat:NSLocalizedString(@"unknown_error", nil), error.localizedDescription];
        [alertView show];
        
    }];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"loading", nil) maskType:SVProgressHUDMaskTypeGradient];
    [[CITUtils networkEngine] enqueueOperation:getCountriesOperation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender {
    
    [MMPickerView showPickerViewInView:self.view
                           withObjects:options
                           withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject:[CITUtils getCountryPreference]}
                            objectToStringConverter:^NSString *(CITCountryData *object) {
                                return object.countryName;
                            }
                            completion:^(id selectedOption) {
                                if ([selectedOption isKindOfClass:[CITCountryData class]]) {
                                    [CITUtils setCountryPreference:selectedOption];
                                }
                                if ([selectedOption isKindOfClass:[NSString class]]) {
                                    [self.countryButton setTitle:selectedOption forState:UIControlStateNormal];
                                }
                            }];
}

- (IBAction)showMenu:(id)sender {
    [self performSegueWithIdentifier:SHOW_MENU_SEGUE sender:self];
}

@end
