//
//  CITSearchResultsViewController.h
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITJourneyData;

@interface CITSearchResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CITJourneyData *journeyParams;
@property (nonatomic, strong) NSArray *flightResults;

@end
