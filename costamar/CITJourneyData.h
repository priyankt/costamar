//
//  CITJourneyData.h
//  costamar
//
//  Created by Mahavir Jain on 29/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITJourneyData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *originCode;
@property (nonatomic, strong) NSString *originAirport;
@property (nonatomic, strong) NSString *destCode;
@property (nonatomic, strong) NSString *destAirport;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSString *adults;
@property (nonatomic, strong) NSString *children;
@property (nonatomic, strong) NSString *infants;
@property (nonatomic, strong) NSString *tariff;
@property (nonatomic, assign) int journeyType;
@property (nonatomic, strong) NSNumber *maxPrice;
@property (nonatomic, retain) NSString * bestPrice;
@property (nonatomic, strong) NSString *alertFrequency;
@property (nonatomic, strong) NSString *alertType;

- (id)initWithOriginCode:(NSString *)originCode originAirport:(NSString *)originAirport destCode:(NSString *)destCode destAirport:(NSString *)destAirport fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate adults:(NSString *)adults children:(NSString *)children infants:(NSString *)infants tariff:(NSString *)tariff journeyType:(int)journeyType;

- (NSString *)formattedFromDate;
- (NSDictionary *)getJourneyParams;
- (void)saveToHistory;
- (NSArray *)getPaxList;

- (NSDate *)getFromDate;
- (NSDate *)getToDate;
- (NSString *)getOriginAirport;
- (NSString *)getDestAirport;

- (NSString *)validate;

- (void)saveToFlightAlerts;

@end
