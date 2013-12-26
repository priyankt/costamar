//
//  CITPax.m
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITPax.h"
#import "CITUtils.h"
#import "CITFlightPayer.h"

@implementation CITPax

- (id)initWithType:(NSString *)paxType adultAssigned:(NSInteger)adultAssigned
{
    self = [super init];
    if (self) {
        self.paxType = paxType;
        self.adtassigned = adultAssigned;
        // extension is always empty
        self.extension = @"";
    }
    
    return self;
}

- (NSDictionary *)toDictWithPayer:(CITFlightPayer *)payer
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if ([self.paxType isEqualToString:ADULT]) {
        dict[@"docnumber"] = self.docNumber;
        dict[@"extension"] = self.extension;
        dict[@"email"] = payer.email;
        dict[@"phone"] = payer.phone;
    } else {
        dict[@"birthday"] = self.birthday;
    }

    // set country as payer country for all
    dict[@"country"] = [CITUtils getValueForOption:payer.country type:COUNTRIES];
    
    dict[@"title"] = [CITUtils getValueForOption:self.title type:TITLES];
    dict[@"adtassigned"] = [NSString stringWithFormat:@"%d", self.adtassigned];
    dict[@"paxtype"] = self.paxType;
    dict[@"name"] = self.name;
    dict[@"lastnamep"] = self.lastnamep;
    dict[@"lastnamem"] = self.lastnamem;
    dict[@"doctype"] = [CITUtils getValueForOption:self.docType type:DOC_TYPES];
    dict[@"countrydoctype"] = [CITUtils getValueForOption:self.countryDocType type:COUNTRIES];
    
    return dict;
}

- (NSString *)validate
{
    if (!self.name || [self.name length] <= 0) {
        return NSLocalizedString(@"invalid_name", nil);
    }
    if (!self.lastnamem || [self.lastnamem length] <= 0) {
        return NSLocalizedString(@"invalid_lastnamem", nil);
    }
    if (!self.lastnamep || [self.lastnamep length] <= 0) {
        return NSLocalizedString(@"invalid_lastnamep", nil);
    }
    if (!self.docNumber || [self.docNumber length] <= 0) {
        return NSLocalizedString(@"invalid_doc_number", nil);
    }
    if (![self.paxType isEqual: ADULT] && (!self.birthday || [self.birthday length] <= 0)) {
        return NSLocalizedString(@"invalid_birthdate", nil);
    }
    
    return nil;
}

@end
