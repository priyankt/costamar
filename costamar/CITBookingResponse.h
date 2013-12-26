//
//  CITBookingResponse.h
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITBookingResponse : NSObject

@property (nonatomic, strong) NSString *pnr;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *codePayment;

- (id)initWithDictionary:(NSDictionary *)bookingResponseDict;

@end
