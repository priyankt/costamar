//
//  CITFilterParams.m
//  costamar
//
//  Created by Mahavir Jain on 23/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFilterParams.h"
#import "CITFlightData.h"
#import "CITFlightSegmentData.h"
#import "CITUtils.h"

@implementation CITFilterParams

- (id)initWithFlightResults:(NSArray *)flightResults{
    
    self = [super init];
    if (self) {
        self.minPrice = DBL_MAX;
        self.maxPrice = 0;
        self.airlineName = [[NSMutableDictionary alloc] init];
        self.airlineSelection = [[NSMutableDictionary alloc] init];
        self.stopSelection = [[NSMutableArray alloc] initWithArray:@[@YES, @YES, @YES]];
        
        for (CITFlightData *data in flightResults) {
            [self updateMinMaxPrice:[data.price doubleValue]];
            for (CITFlightSegmentData *segment in data.flightSegments) {
                self.airlineName[segment.airlineid] = segment.airline;
                self.airlineSelection[segment.airlineid] = @YES;
            }
        }
        
        self.thresholdPrice = self.maxPrice;
    }
    
    return self;
}

- (void)updateMinMaxPrice:(double)price
{
    if (price < self.minPrice) {
        self.minPrice = price;
    }
    if (price > self.maxPrice) {
        self.maxPrice = price;
    }
}

- (NSArray *)getAirlineNames
{
    return [[self.airlineName allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (int)getRowCount:(BOOL)showAirlineOptions
{
    int rowCount = 0;
    if (showAirlineOptions) {
        rowCount = [[self.airlineName allKeys] count];
    } else {
        rowCount = [self.stopSelection count];
    }
    
    return rowCount;
}

- (NSString *)getLabelForRow:(int)row showAirlineOptions:(BOOL)showAirlineOptions
{
    NSString *text = nil;
    if (showAirlineOptions) {
        text = [[self getAirlineNames] objectAtIndex:row];
    } else {
        text = [[CITUtils getOptionsForType:STOPS] objectAtIndex:row];
    }
    
    return text;
}

- (BOOL)isSelectedRow:(int)row showAirlineOptions:(BOOL)showAirlineOptions
{
    BOOL selected = YES;
    if (showAirlineOptions) {
        NSString *selectedAirline = [self getLabelForRow:row showAirlineOptions:showAirlineOptions];
        NSString *selectedAirportCode = [[self.airlineName allKeysForObject:selectedAirline] lastObject];
        selected = [self.airlineSelection[selectedAirportCode] boolValue];
    } else {
        selected = [self.stopSelection[row] boolValue];
    }
    
    return selected;
}

- (void)updateRow:(int)row value:(BOOL)value showAirlineOptions:(BOOL)showAirlineOptions
{
    if (showAirlineOptions) {
        NSString *selectedAirline = [self getLabelForRow:row showAirlineOptions:showAirlineOptions];
        NSString *selectedAirportCode = [[self.airlineName allKeysForObject:selectedAirline] lastObject];
        self.airlineSelection[selectedAirportCode] = (value ? @YES : @NO);
    } else {
        self.stopSelection[row] = (value ? @YES : @NO);
    }
}

- (void)updateAllWithValue:(BOOL)value airlineOptions:(BOOL)showAirlineOptions
{
    if (showAirlineOptions) {
        for (NSString *airlineCode in [self.airlineName allKeys]) {
            self.airlineSelection[airlineCode] = (value ? @YES : @NO);
        }
    } else {
        for (int i=0; i < [self.stopSelection count]; i++) {
            self.stopSelection[i] = (value ? @YES : @NO);
        }
    }
}

- (void)resetFilterParams
{
    // Set all airlines as selected
    for (NSString *airlineCode in [self.airlineName allKeys]) {
        self.airlineSelection[airlineCode] = @YES;
    }
    
    // Set all stops as selected
    for (int i=0; i < [self.stopSelection count]; i++) {
        self.stopSelection[i] = @YES;
    }
    
    // Set threshold price = max price
    self.thresholdPrice = self.maxPrice;
}

@end
