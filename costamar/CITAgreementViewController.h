//
//  CITAgreementViewController.h
//  costamar
//
//  Created by Mahavir Jain on 14/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITPaymentOption;
@class CITFlightDetailData;

@interface CITAgreementViewController : UIViewController

@property (nonatomic, strong) CITFlightDetailData *detailData;
@property (nonatomic, strong) CITPaymentOption *paymentOption;

@end
