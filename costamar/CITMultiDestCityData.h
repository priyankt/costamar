//
//  CITMultiDestCityData.h
//  costamar
//
//  Created by Mahavir Jain on 09/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITMultiDestCityData : NSObject

@property (nonatomic,strong) NSString *originCode;
@property (nonatomic,strong) NSString *destCode;
@property (nonatomic,strong) NSDate *dateFrom;
@property (nonatomic,strong) NSDate *dateTo;

- (NSString *)formattedFromDate;
- (NSDictionary *)toDictionary;

@end
