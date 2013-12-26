//
//  CITFlightSuggestion.m
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightSuggestion.h"

@implementation CITFlightSuggestion : NSObject 

- (id)initWith:(NSString *)cityLabel code:(NSString *)code
{
    self = [super init];
    if (self) {
        self.cityLabel = cityLabel;
        self.code = code;
    }
    
    return self;
}

- (NSString *)completionText
{
    return self.cityLabel;
}

@end
