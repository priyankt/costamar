//
//  CITMultiDestData.m
//  costamar
//
//  Created by Mahavir Jain on 09/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMultiDestData.h"
#import "CITUtils.h"
#import "CITMultiDestCityData.h"
#import "CITCountryData.h"

@implementation CITMultiDestData

- (id)initWithCountryData:(CITCountryData *)countryData
{
    self = [super init];
    if (self) {
        self.affiliateid = countryData.affiliateid;
        self.countryid = countryData.companyid;
        self.conglomerateid = countryData.conglomerateid;
        self.adults = @"1";
        self.children = @"0";
        self.infants = @"0";
        self.tariff = @"Economica";
        
        self.cities = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSDictionary *)getMultiDestParams
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (self.affiliateid) {
        [data setObject:self.affiliateid forKey:@"affiliateid"];
    }
    if (self.countryid) {
        [data setObject:self.countryid forKey:@"countryid"];
    }
    if (self.conglomerateid) {
        [data setObject:self.conglomerateid forKey:@"conglomerateid"];
    }
    if (self.adults) {
        [data setObject:self.adults forKey:@"adult"];
    }
    if (self.children) {
        [data setObject:self.children forKey:@"child"];
    }
    if (self.infants) {
        [data setObject:self.infants forKey:@"infant"];
    }
    if (self.tariff) {
        [data setObject:[CITUtils getValueForOption:self.tariff type:CABIN] forKey:@"cabin"];
    }
    if (self.cities) {
        NSMutableArray *cities = [[NSMutableArray alloc] initWithCapacity:[self.cities count]];
        for (CITMultiDestCityData *city in self.cities) {
            [cities addObject:[city toDictionary]];
        }
        [data setObject:cities forKey:@"cityarray"];
    }
    
    return @{@"flight":data};
}

@end
