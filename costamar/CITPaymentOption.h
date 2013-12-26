//
//  CITPaymentOption.h
//  costamar
//
//  Created by Mahavir Jain on 13/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITPaymentOption : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSNumber *supplierid;

- (id)initWithDict:(NSDictionary *)paymentDict;

@end
