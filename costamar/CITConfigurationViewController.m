//
//  CITConfigurationViewController.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITConfigurationViewController.h"
#import "CITUtils.h"
#import "SVProgressHUD.h"
#import "MMPickerView.h"
#import "CITSearchHistory.h"
#import "CITCountryData.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"

@interface CITConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *clearHistoryButton;

@end

@implementation CITConfigurationViewController {
    NSArray *options;
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
    MKNetworkOperation *getCountriesOperation = [ [CITUtils networkEngine] getCountriesListWithCompletionHandler:^(NSArray *countries) {
        options = countries;
        CITCountryData *countryPreference = [CITUtils getCountryPreference];
        if (countryPreference == nil) {
            countryPreference = [options objectAtIndex:0];
            [CITUtils setCountryPreference:countryPreference];
        }
        [self.countryButton setTitle:countryPreference.countryName forState:UIControlStateNormal];
        [SVProgressHUD dismiss];
        
    } errorHandler:^(NSError *error){
        [SVProgressHUD dismiss];
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
    [[CITUtils networkEngine] enqueueOperation:getCountriesOperation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCountry:(id)sender {
    [MMPickerView showPickerViewInView:self.view
                           withObjects:options
                           withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1", MMselectedObject:[CITUtils getCountryPreference]}
                            objectToStringConverter:^NSString *(CITCountryData *object) {
                                return object.countryName;
                            }
                            completion:^(id selectedOption) {
                                if ([selectedOption isKindOfClass:[CITCountryData class]]) {
                                    NSLog(@"%@", selectedOption);
                                    [CITUtils setCountryPreference:selectedOption];
                                }
                                if ([selectedOption isKindOfClass:[NSString class]]) {
                                    [self.countryButton setTitle:selectedOption forState:UIControlStateNormal];
                                }
                            }];

}

- (IBAction)clearHistory:(id)sender {    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", nil) maskType:SVProgressHUDMaskTypeGradient];
    [CITSearchHistory clearHistory];
    [SVProgressHUD dismiss];
}

@end
