//
//  CITFlightSegmentData.h
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITFilterParams;

@interface CITFlightSegmentData : NSObject

@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSString *airlineid;
@property (nonatomic, strong) NSString *base;
@property (nonatomic, strong) NSString *cabinType;
@property (nonatomic, strong) NSString *cityFrom;
@property (nonatomic, strong) NSString *cityTo;
@property (nonatomic, strong) NSDate *dateFrom;
@property (nonatomic, strong) NSDate *dateTo;
@property (nonatomic, strong) NSString *flightid;
@property (nonatomic, strong) NSString *flightNumber;
@property (nonatomic, strong) NSString *hourFrom;
@property (nonatomic, strong) NSString *hourTo;
@property (nonatomic, strong) NSString *operatedBy;
@property (nonatomic, strong) NSNumber *stop;

- (id)initWithDictionary:(NSDictionary *)segment;
- (NSAttributedString *)getFromLabelText;
- (NSAttributedString *)getToLabelText;
- (NSString *)getStopLabelText;
- (NSString *)getHeaderText;
- (NSAttributedString *)getDateFromAttributedString;
- (NSAttributedString *)getDateToAttributedString;
- (NSAttributedString *)getAirlineAttributedString;
- (NSAttributedString *)getOperatedByAttributedString;
- (NSAttributedString *)getTariffAttributedString;
- (NSAttributedString *)getHourFromAttributedString;
- (NSAttributedString *)getHourToAttributedString;
- (NSAttributedString *)getFlightNumberAttributedString;
- (BOOL)failedFilter:(CITFilterParams *)filterParams;

@end
