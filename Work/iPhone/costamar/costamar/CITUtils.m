//
//  CITUtils.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITUtils.h"
#import "CITAppDelegate.h"

@implementation CITUtils

+ (CITNetworkEngine *) networkEngine
{
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.networkEngine;
}

+ (void)setCountryPreference:(NSDictionary *)countryData
{
    [[NSUserDefaults standardUserDefaults] setObject:countryData forKey:@"country"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getCountryPreference
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"country"];;
}

@end
