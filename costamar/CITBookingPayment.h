//
//  CITBookingPayment.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITFlightPayer;

@interface CITBookingPayment : NSObject

@property (nonatomic, strong) CITFlightPayer *payer;
@property (nonatomic, strong) NSArray *paxList;
@property (nonatomic, strong) NSString *flightid;
// add flight:{affiliateid, congolomerateid, countryid}

- (id)initWithPayer:(CITFlightPayer *)payer paxList:(NSArray *)paxList flightid:(NSString *)flightid;
- (NSDictionary *)toDict;

@end
