//
//  CITMultiDestData.h
//  costamar
//
//  Created by Mahavir Jain on 09/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITCountryData;

@interface CITMultiDestData : NSObject

@property (nonatomic, strong) NSNumber *affiliateid;
@property (nonatomic, strong) NSNumber *countryid;
@property (nonatomic, strong) NSNumber *conglomerateid;
@property (nonatomic, strong) NSString *adults;
@property (nonatomic, strong) NSString *children;
@property (nonatomic, strong) NSString *infants;
@property (nonatomic, strong) NSString *tariff;
@property (nonatomic, strong) NSMutableArray *cities;

- (id)initWithCountryData:(CITCountryData *)countryData;
- (NSDictionary *)getMultiDestParams;

@end
