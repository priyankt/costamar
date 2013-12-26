//
//  CITFlightPayer.m
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightPayer.h"
#import "CITUtils.h"
#import "CITPax.h"

@implementation CITFlightPayer

- (id)initWithPaymentSupplier:(NSNumber *)paymentSupplier;
{
    self = [super init];
    if (self) {
        self.paymentSupplierId = paymentSupplier;
    }
    
    return self;
}

- (NSDictionary *)toDictWithFirstAdult:(CITPax *)firstAdult
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"name"] = firstAdult.name;
    dict[@"email"] = self.email;
    dict[@"lastnamem"] = firstAdult.lastnamem;
    dict[@"lastnamep"] = firstAdult.lastnamep;
    dict[@"country"] = [CITUtils getValueForOption:firstAdult.countryDocType type:COUNTRIES];
    dict[@"phone"] = self.phone;
    dict[@"paymentsupplierid"] = self.paymentSupplierId;
    
    return dict;
}

- (NSString *)validate
{
    if (!self.email || [self.email length] <= 0 ) {
        return NSLocalizedString(@"invalid_email", nil);
    }
    if (!self.phone || [self.phone length] <= 0) {
        return NSLocalizedString(@"invalid_phone", nil);
    }
    if (!self.confirmEmail || ![self.email isEqualToString:self.confirmEmail]) {
        return NSLocalizedString(@"invalid_confirm_email", nil);
    }
    
    return nil;
}

@end
