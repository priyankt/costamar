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

@interface CITInitialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *ingresarButton;

@end

@implementation CITInitialViewController {
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
    MKNetworkOperation *getCountriesOperation = [ [CITUtils networkEngine] getCountriesListWithCompletionHandler:^(NSArray *countries) {
        options = countries;
        [SVProgressHUD dismiss];
    } errorHandler:^(NSError *error){
        [SVProgressHUD dismiss];
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
    [[CITUtils networkEngine] enqueueOperation:getCountriesOperation];

//    options = [NSArray arrayWithObjects:@"PERU [PE]",@"ECUADOR [EC]",@"ESTADOS UNIDOS [US]",@"COLOMBIA [CO]",@"REPUBLICA DOMINICANA [DO]",@"MEXICO [MX]", nil];
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
                           withOptions:@{MMtoolbarColor: [UIColor grayColor], MMshowsSelectionIndicator: @"1"}
                            objectToStringConverter:^NSString *(id object) {
                                return object[@"countryname"];
                            }
                            completion:^(id selectedOption) {
                                if ([selectedOption isKindOfClass:[NSDictionary class]]) {
                                    [CITUtils setCountryPreference:selectedOption];
                                }
                                if ([selectedOption isKindOfClass:[NSString class]]) {
                                    [self.countryButton setTitle:selectedOption forState:UIControlStateNormal];
                                }
                            }];
}

- (IBAction)showMenu:(id)sender {
    [self performSegueWithIdentifier:@"showMenuView" sender:self];
}

@end
