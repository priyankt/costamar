//
//  CITFlightPayer.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITPax;

@interface CITFlightPayer : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *confirmEmail;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *phone;
// payment method selected id
@property (nonatomic, strong) NSNumber *paymentSupplierId;

- (id)initWithPaymentSupplier:(NSNumber *)paymentSupplier;
- (NSDictionary *)toDictWithFirstAdult:(CITPax *)adult;
- (NSString *)validate;

@end
