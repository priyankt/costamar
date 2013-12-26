//
//  CITFlightData.m
//  costamar
//
//  Created by Mahavir Jain on 03/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightData.h"
#import "CITFlightSegmentData.h"
#import "UIColor+InnerBand.h"
#import "CITUtils.h"
#import "CITCountryData.h"
#import "CITFilterParams.h"

@implementation CITFlightData

- (id)initWithDictionary:(NSDictionary *)flightDict
{
    self = [super init];
    if (self) {
        self.airline = flightDict[@"airline"];
        self.flightid = flightDict[@"flightid"];
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.price = [f numberFromString:flightDict[@"price"]];
        
        self.flightSegments = [[NSMutableArray alloc] init];
        for (NSDictionary *segment in flightDict[@"flightsegment"]) {
            [self.flightSegments addObject:[[CITFlightSegmentData alloc] initWithDictionary:segment]];
        }
    }
    
    return self;
}

- (NSAttributedString *)getPriceAttributedString
{
    NSString *title = NSLocalizedString(@"base_price", nil);
    NSString *priceString = [title stringByAppendingString:[@"$" stringByAppendingString:[self.price stringValue]]];
    NSMutableAttributedString *priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
                      
    [priceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[priceString rangeOfString:title]];
    
    [priceAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f39200"] range:[priceString rangeOfString:[@"$" stringByAppendingString:[self.price stringValue]]]];
    
    [priceAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:[priceString rangeOfString:priceString]];
    
    return priceAttributedString;
}

- (NSDictionary *)getFlightDetailParams
{
    CITCountryData *countryPreference = [CITUtils getCountryPreference];
    NSDictionary *flightDetailParams = @{@"flight":@{@"countryid":countryPreference.companyid,@"conglomerateid":countryPreference.conglomerateid,@"affiliateid":countryPreference.affiliateid},@"flightid":self.flightid};

    NSLog(@"%@", flightDetailParams);

    return flightDetailParams;
}

- (BOOL)failedFilter:(CITFilterParams *)filterParams
{
    BOOL failed = NO;
    if(self.flightSegments && [self.flightSegments count] > 0){
        for (CITFlightSegmentData *flightSegment in self.flightSegments) {
            if ([flightSegment failedFilter:filterParams]) {
                failed = YES;
                break;
            }
        }
    }

    if (self.price && !failed) {
        failed = [self.price doubleValue] > filterParams.thresholdPrice;
    }
    
    return failed;
}

@end
