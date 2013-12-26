//
//  CITFlightAlert.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CITFlightJourney.h"

@class CITJourneyData;

@interface CITFlightAlert : CITFlightJourney

@property (nonatomic, retain) NSDate * dttm;
@property (nonatomic, retain) NSString * maxPrice;
@property (nonatomic, retain) NSString * bestPrice;
@property (nonatomic, retain) NSString * alertFrequency;
@property (nonatomic, retain) NSString * alertType;

- (NSString *)getAlertHeaderString;
- (NSString *)getAlertDateString;
- (NSString *)getAlertNumberOfPassengersString;
- (CITJourneyData *)getJourneyData;

@end
