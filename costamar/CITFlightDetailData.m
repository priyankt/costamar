//
//  CITFlightDetailData.m
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightDetailData.h"
#import "CITSegmentGroupData.h"
#import "CITUtils.h"
#import "CITCountryData.h"

@implementation CITFlightDetailData

- (id)initWithDictionary:(NSDictionary *)flightDetailDict
{
    self = [super init];
    if (self) {
        self.airline = flightDetailDict[@"Airline"];
        self.airlineid = flightDetailDict[@"AirlineId"];
        self.cityFrom = flightDetailDict[@"CityFrom"];
        self.cityTo = flightDetailDict[@"CityTo"];
        self.flightid = flightDetailDict[@"FlightId"];
        self.flightPolicy = flightDetailDict[@"FlightPolicy"];
        self.status = flightDetailDict[@"Status"];
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.price = [f numberFromString:flightDetailDict[@"Price"]];
        
        self.segmentGroups = [[NSMutableArray alloc] init];
        if ([flightDetailDict[@"SegmentGroup"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *segmentGroupDict in flightDetailDict[@"SegmentGroup"]) {
                [self.segmentGroups addObject:[[CITSegmentGroupData alloc] initWithDictionary:segmentGroupDict]];
            }
        }
    }
    
    return self;
}

- (NSDictionary *)getParamsForFlightPricing
{
    CITCountryData *countryPreference = [CITUtils getCountryPreference];
    return @{@"flight":@{@"countryid":countryPreference.companyid,@"conglomerateid":countryPreference.conglomerateid,@"affiliateid":countryPreference.affiliateid},@"flightid":self.flightid};
}

@end
