//
//  CITFlightDetailData.h
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITFlightDetailData : NSObject

@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSString *airlineid;
@property (nonatomic, strong) NSString *cityFrom;
@property (nonatomic, strong) NSString *cityTo;
@property (nonatomic, strong) NSString *flightid;
@property (nonatomic, strong) NSString *flightPolicy;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSMutableArray *segmentGroups;
@property (nonatomic, strong) NSNumber *status;

- (id)initWithDictionary:(NSDictionary *)flightDetailDict;
- (NSDictionary *)getParamsForFlightPricing;

@end
