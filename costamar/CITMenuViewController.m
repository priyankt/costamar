//
//  CITMenuViewController.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMenuViewController.h"
#import "CITSearchViewController.h"
#import "CITJourneyData.h"
#import "CITUtils.h"

#define SEARCH_VIEW_SEGUE @"showSearchView"

@interface CITMenuViewController ()

@end

@implementation CITMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEARCH_VIEW_SEGUE]){
        CITSearchViewController *searchViewController = segue.destinationViewController;
        searchViewController.journeyParams = [[CITJourneyData alloc] initWithOriginCode:nil originAirport:nil destCode:nil destAirport:nil fromDate:[CITUtils getDateFromTodayPlus:DAYS_GAP] toDate:nil adults:@"1" children:@"0" infants:@"0" tariff:@"Economica" journeyType:ONE_WAY];
    }
}

@end
