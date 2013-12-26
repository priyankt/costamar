//
//  CITPassengerInfoSelectButton.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PASSENGER_TITLE 1
#define PASSENGER_COUNTRY 2
#define PASSENGER_DOC_TYPE 3
#define PASSENGER_ASSIGNED_ADULT 4
#define PAYER_COUNTRY 5

@interface CITPassengerInfoSelectButton : UIButton

@property (nonatomic, assign) int type;

@end
