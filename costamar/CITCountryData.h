//
//  CITCountryData.h
//  costamar
//
//  Created by Mahavir Jain on 04/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITCountryData : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *affiliateid;
@property (nonatomic, strong) NSNumber *companyid;
@property (nonatomic, strong) NSNumber *conglomerateid;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *countryName;

- (id)initWithDictionary:(NSDictionary *)countryDict;
- (BOOL)isEqual:(id)object;

@end
