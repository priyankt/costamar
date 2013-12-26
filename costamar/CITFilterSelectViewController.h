//
//  CITFilterSelectViewController.h
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITFilterParams;

@interface CITFilterSelectViewController : UITableViewController

@property (nonatomic, strong) CITFilterParams *filterParams;
@property (nonatomic, assign) BOOL showAirlineOptions;

@end
