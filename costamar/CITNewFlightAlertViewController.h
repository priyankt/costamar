//
//  CITNewFlightAlertViewController.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITJourneyData;

@interface CITNewFlightAlertViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) CITJourneyData *journeyData;

@end
