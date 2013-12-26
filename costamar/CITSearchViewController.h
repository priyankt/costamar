//
//  CITSearchViewController.h
//  costamar
//
//  Created by Mahavir Jain on 15/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITJourneyData;
@class CITMultiDestData;

@interface CITSearchViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) CITJourneyData *journeyParams;

@end
