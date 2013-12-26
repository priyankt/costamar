//
//  CITBookingResponse.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITBookingResponse.h"

@implementation CITBookingResponse

- (id)initWithDictionary:(NSDictionary *)bookingResponseDict
{
    self = [super init];
    if (self) {
        self.pnr = bookingResponseDict[@"Pnr"];
        self.status = [bookingResponseDict[@"Status"] boolValue];
        self.message = bookingResponseDict[@"Message"];
        self.codePayment = bookingResponseDict[@"CodePayment"];
    }
    
    return self;
}

@end
