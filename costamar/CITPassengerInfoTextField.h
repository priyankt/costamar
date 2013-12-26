//
//  CITPassengerInfoTextField.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PASSENGER_NAME 1
#define PASSENGER_LASTNAMEP 2
#define PASSENGER_LASTNAMEM 3
#define PASSENGER_DOC_NUMBER 4
#define PAYER_EMAIL 5
#define PAYER_CONFIRM_EMAIL 6
#define PAYER_PHONE 7
#define PASSENGER_BIRTHDATE 8

@interface CITPassengerInfoTextField : UITextField

@property (nonatomic, assign) int type;

@end
