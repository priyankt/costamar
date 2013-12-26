//
//  CITSearchHistory.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CITFlightJourney.h"

@class CITJourneyData;

@interface CITSearchHistory : CITFlightJourney

@property (nonatomic, retain) NSDate * dttm;

- (NSAttributedString *)getRoute;
- (NSAttributedString *)getDateString;
- (CITJourneyData *)getJourneyParams;
+ (void)clearHistory;

@end
