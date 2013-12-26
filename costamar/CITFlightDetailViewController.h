//
//  CITFlightDetailViewController.h
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITFlightDetailData;

@interface CITFlightDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CITFlightDetailData *detailData;

@end
