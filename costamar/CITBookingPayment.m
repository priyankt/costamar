//
//  CITBookingPayment.m
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITBookingPayment.h"
#import "CITUtils.h"
#import "CITPax.h"
#import "CITCountryData.h"
#import "CITFlightPayer.h"

@implementation CITBookingPayment

- (id)initWithPayer:(CITFlightPayer *)payer paxList:(NSArray *)paxList flightid:(NSString *)flightid
{
    self = [super init];
    if (self) {
        self.payer = payer;
        self.paxList = paxList;
        self.flightid = flightid;
    }
    
    return self;
}

- (NSDictionary *)toDict
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    CITCountryData *countryPreference = [CITUtils getCountryPreference];
    dict[@"flight"] = @{@"affiliateid":countryPreference.affiliateid,@"congolomerateid":countryPreference.conglomerateid,@"countryid":countryPreference.companyid};
    
    CITPax *firstAdultPassenger = self.paxList.firstObject;
    dict[@"flightpayer"] = [self.payer toDictWithFirstAdult:firstAdultPassenger];
    
    NSMutableArray *passengerList = [[NSMutableArray alloc] initWithCapacity:[self.paxList count]];
    for (CITPax *pax  in self.paxList) {
        // For child and infants, title field will take its value from the first adult passenger
        if (![pax.paxType isEqualToString:ADULT]) {
            pax.title = firstAdultPassenger.title;
        }
        NSDictionary *paxDict = [pax toDictWithPayer:self.payer];
        [passengerList addObject:paxDict];
    }    
    dict[@"paxlist"] = passengerList;

    return @{@"bookingPayment":dict,@"flightid":self.flightid};
}

@end
