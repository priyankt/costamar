//
//  CITReservationViewController.h
//  costamar
//
//  Created by Mahavir Jain on 06/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITFlightDetailData;

@interface CITReservationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CITFlightDetailData *detailData;
@property (nonatomic, strong) NSArray *paymentOptions;

@end
