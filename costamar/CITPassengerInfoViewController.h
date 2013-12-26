//
//  CITPassengerInfoViewController.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITFlightDetailData;
@class CITPaymentOption;
@class CITJourneyData;

@interface CITPassengerInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) CITJourneyData *journeyParams;
@property (nonatomic,strong) CITPaymentOption *paymentOption;
@property (nonatomic,strong) CITFlightDetailData *detailData;

@end
