//
//  CITFlightAlert.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightAlert.h"
#import "CITUtils.h"
#import "CITJourneyData.h"

@implementation CITFlightAlert

@dynamic dttm;
@dynamic maxPrice;
@dynamic bestPrice;
@dynamic alertFrequency;
@dynamic alertType;

- (NSString *)getAlertHeaderString
{
    return [NSString stringWithFormat:@"%@ - %@", self.originCode, self.destCode];
}

- (NSString *)getAlertDateString
{
    NSDateFormatter *f = [CITUtils dateFormatter];
    NSString *dateString = [NSString stringWithFormat:[NSLocalizedString(@"date", nil) stringByAppendingString:@" %@"], [f stringFromDate:self.fromDate]];
    if (self.toDate) {
        dateString = [NSString stringWithFormat:[NSLocalizedString(@"date", nil) stringByAppendingString:@" %@ - %@"], [f stringFromDate:self.fromDate], [f stringFromDate:self.toDate]];
    }
    
    return dateString;
}

- (NSString *)getAlertNumberOfPassengersString
{
    return [NSString stringWithFormat:NSLocalizedString(@"label_filght_alert_passenger_string", nil), (self.adults ? self.adults : @"-"), (self.children ? self.children : @"-"), (self.infants ? self.infants : @"-")];
}

- (CITJourneyData *)getJourneyData
{
    CITJourneyData *journeyData = [[CITJourneyData alloc] initWithOriginCode:self.originCode originAirport:self.originAirport destCode:self.destCode destAirport:self.destAirport fromDate:self.fromDate toDate:self.toDate adults:self.adults children:self.children infants:self.infants tariff:self.tariff journeyType:[self.type intValue]];
    
    return journeyData;
}

@end
