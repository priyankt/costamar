//
//  CITPax.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITFlightPayer;

// Pax Types
#define ADULT @"ADT"
#define CHILD @"CNN"
#define INFANT @"INF"

@interface CITPax : NSObject

// Adult assigned as incharge, set 0 for adult type
@property (nonatomic, assign) NSInteger adtassigned;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *paxType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastnamep;
@property (nonatomic, strong) NSString *lastnamem;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *docType;
@property (nonatomic, strong) NSString *countryDocType;
@property (nonatomic, strong) NSString *docNumber;
// Title => Mr., Mrs.,
@property (nonatomic, strong) NSString *title;

- (id)initWithType:(NSString *)paxType adultAssigned:(NSInteger)adultAssigned;
- (NSDictionary *)toDictWithPayer:(CITFlightPayer *)payer;
- (NSString *)validate;

@end
