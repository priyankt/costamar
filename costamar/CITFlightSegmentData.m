//
//  CITFlightSegmentData.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightSegmentData.h"
#import "CITUtils.h"
#import "CITFilterParams.h"

@implementation CITFlightSegmentData

- (id)initWithDictionary:(NSDictionary *)segment
{
    self = [super init];
    if (self) {
        self.airline = segment[@"airline"];
        self.airlineid = segment[@"airlineid"];
        self.base = segment[@"base"];
        self.cabinType = segment[@"cabintype"];
        self.cityFrom = segment[@"cityfrom"];
        self.cityTo = segment[@"cityto"];
        
        NSDateFormatter *formatter = [CITUtils dateFormatter];
        self.dateFrom = [formatter dateFromString:segment[@"datefrom"]];
        self.dateTo = [formatter dateFromString:segment[@"dateto"]];
        
        self.flightid = segment[@"flightid"];
        self.flightNumber = segment[@"flightnumber"];
        self.hourFrom = segment[@"hourfrom"];
        self.hourTo = segment[@"hourto"];
        self.operatedBy = segment[@"operatedby"];
        self.stop = segment[@"stop"];
    }
    
    return  self;
}

- (NSAttributedString *)getFromLabelText
{
    NSString *fromLabelString = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"departure_detail", nil),self.cityFrom, [self formatDate:self.dateFrom], self.hourFrom];
    NSMutableAttributedString *fromLabelAttributedText = [[NSMutableAttributedString alloc] initWithString:fromLabelString];
    [fromLabelAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[fromLabelString rangeOfString:NSLocalizedString(@"departue_detail", nil)]];

    return fromLabelAttributedText;
}

- (NSAttributedString *)getToLabelText
{
    NSString *toLabelString = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"arrival_detail", nil),self.cityTo, [self formatDate:self.dateTo], self.hourTo];
    NSMutableAttributedString *toLabelAttributedText = [[NSMutableAttributedString alloc] initWithString:toLabelString];
    [toLabelAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[toLabelString rangeOfString:NSLocalizedString(@"arrival_detail", nil)]];
    
    return toLabelAttributedText;
}

- (NSString *)getStopLabelText
{
    return [NSString stringWithFormat:NSLocalizedString(@"stop", nil),self.stop];
}

- (NSString *)formatDate:(NSDate *)date
{
    return [[CITUtils dateFormatter] stringFromDate:date];
}

- (NSString *)getHeaderText
{
    return [NSString stringWithFormat:@"%@ - %@", self.cityFrom, self.cityTo];
}

- (NSAttributedString *)getDateFromAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"departure_detail", nil) value:[self formatDate:self.dateFrom]];
}

- (NSAttributedString *)getDateToAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"arrival_detail", nil) value:[self formatDate:self.dateTo]];
}

- (NSAttributedString *)getAirlineAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"airline", nil) value:self.airline];
}

- (NSAttributedString *)getOperatedByAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:@"Operado por: " value:self.operatedBy];
}

- (NSAttributedString *)getTariffAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"label_tariff", nil) value:[CITUtils getOptionForValue:self.cabinType type:CABIN]];
}

- (NSAttributedString *)getHourFromAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"hour", nil) value:self.hourFrom];
}

- (NSAttributedString *)getHourToAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"hour", nil) value:self.hourTo];
}

- (NSAttributedString *)getFlightNumberAttributedString
{
    return [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"flight_number", nil) value:self.flightNumber];
}

- (BOOL)failedFilter:(CITFilterParams *)filterParams
{
    if (![filterParams.airlineSelection[self.airlineid] boolValue]) {
        return YES;
    }

    int stops = (self.stop ? [self.stop intValue] : 0);
    if (stops == 0 && ![filterParams.stopSelection[0] boolValue]) {
        return YES;
    }
    if (stops == 1 && ![filterParams.stopSelection[1] boolValue]) {
        return YES;
    }
    if (stops > 1 && ![filterParams.stopSelection[2] boolValue]) {
        return YES;
    }
    
    return NO;
}

@end
