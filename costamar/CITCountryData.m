//
//  CITCountryData.m
//  costamar
//
//  Created by Mahavir Jain on 04/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITCountryData.h"

@implementation CITCountryData

- (id)initWithDictionary:(NSDictionary *)countryDict
{
    self = [super init];
    if (self) {
        self.affiliateid = countryDict[@"affiliateid"];
        self.companyid = countryDict[@"companyid"];
        self.conglomerateid = countryDict[@"conglomerateid"];
        self.countryCode = countryDict[@"countrycode"];
        self.countryName =countryDict[@"countryname"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:self.affiliateid forKey:@"affiliateid"];
    [encoder encodeObject:self.companyid forKey:@"companyid"];
    [encoder encodeObject:self.conglomerateid forKey:@"conglomerateid"];
	[encoder encodeObject:self.countryCode forKey:@"countryCode"];
	[encoder encodeObject:self.countryName forKey:@"countryName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if(self)
	{
        //decode properties, other class vars
        self.affiliateid = [decoder decodeObjectForKey:@"affiliateid"];
        self.companyid = [decoder decodeObjectForKey:@"companyid"];
        self.conglomerateid = [decoder decodeObjectForKey:@"conglomerateid"];
        self.countryCode = [decoder decodeObjectForKey:@"countryCode"];
        self.countryName = [decoder decodeObjectForKey:@"countryName"];
	}
    
	return self;
}

- (BOOL)isEqual:(id)object
{
    BOOL equal = NO;
    if ([object isKindOfClass:self.class]) {
        CITCountryData *other = object;
        if ([self.affiliateid isEqualToNumber:other.affiliateid] && [self.companyid isEqualToNumber:other.companyid] && [self.conglomerateid isEqualToNumber:other.conglomerateid] && [self.countryCode isEqualToString:other.countryCode] && [self.countryName isEqualToString:other.countryName]) {
            equal = YES;
        }
    }
    
    return equal;
}

@end
