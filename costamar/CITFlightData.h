//
//  CITFlightData.h
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITFilterParams;

@interface CITFlightData : NSObject

@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSString *flightid;
@property (nonatomic, strong) NSMutableArray *flightSegments;
@property (nonatomic, strong) NSNumber *price;

- (id)initWithDictionary:(NSDictionary *)flightData;
- (NSAttributedString *)getPriceAttributedString;
//- (UIView *)getSegmentViewOfWidth:(int)width;
- (NSDictionary *)getFlightDetailParams;
- (BOOL)failedFilter:(CITFilterParams *)filterParams;

@end
