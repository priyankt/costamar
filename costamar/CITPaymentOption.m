//
//  CITPaymentOption.m
//  costamar
//
//  Created by Mahavir Jain on 13/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITPaymentOption.h"

@implementation CITPaymentOption

- (id)initWithDict:(NSDictionary *)paymentDict
{
    self = [super init];
    if (self) {
        self.description = paymentDict[@"description"];
        self.name = paymentDict[@"name"];
        self.resource = paymentDict[@"resource"];
        self.supplierid = paymentDict[@"supplierid"];
    }
    
    return self;
}

@end
