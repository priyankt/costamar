//
//  CITMultiDestCityData.m
//  costamar
//
//  Created by Mahavir Jain on 09/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMultiDestCityData.h"
#import "CITUtils.h"

@implementation CITMultiDestCityData

- (NSString *)formattedFromDate
{
    NSDateFormatter *f = [CITUtils dateFormatter];
    
    return [f stringFromDate:self.dateFrom];
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.originCode) {
        dict[@"cityfrom"] = self.originCode;
    }
    if (self.destCode) {
        dict[@"cityto"] = self.destCode;
    }
    if (self.dateFrom) {
        dict[@"datefrom"] = [self formattedFromDate];
    }
    if (self.dateTo) {
        dict[@"dateto"] = @"";
    }
    
    return dict;
}

@end
