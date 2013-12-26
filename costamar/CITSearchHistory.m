//
//  CITSearchHistory.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSearchHistory.h"
#import "CITUtils.h"
#import "NSManagedObject+InnerBand.h"
#import "IBCoreDataStore.h"
#import "CITJourneyData.h"

@implementation CITSearchHistory

@dynamic dttm;

- (NSAttributedString *)getRoute
{
    NSAttributedString *routeAttributedString = [CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"label_route", nil) value:[NSString stringWithFormat:@"%@ - %@", self.originCode, self.destCode]];
    return routeAttributedString;
}

- (NSAttributedString *)getDateString
{
    NSDateFormatter *f = [CITUtils dateFormatter];
    NSMutableAttributedString *dateAttributedString = (NSMutableAttributedString *)[CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"label_datefrom", nil) value:[f stringFromDate:self.fromDate]];
    if (self.toDate) {
        [dateAttributedString appendAttributedString:[CITUtils getAttributedStringWithPrefix:NSLocalizedString(@"label_dateto", nil) value:[f stringFromDate:self.toDate]]];
    }
    
    return dateAttributedString;
}

- (CITJourneyData *)getJourneyParams
{
    CITJourneyData *data = [[CITJourneyData alloc] initWithOriginCode:self.originCode originAirport:self.originAirport destCode:self.destCode destAirport:self.destAirport fromDate:self.fromDate toDate:self.toDate adults:self.adults children:self.children infants:self.infants tariff:self.tariff journeyType:self.tariff];
    
    return data;
}

+ (void)clearHistory
{
    for (CITSearchHistory *history in [CITSearchHistory all]) {
        [history destroy];
    }
    
    [[IBCoreDataStore mainStore] save];
}


@end
