//
//  CITFilterParams.h
//  costamar
//
//  Created by Mahavir Jain on 23/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITFilterParams : NSObject

@property (nonatomic, strong) NSMutableDictionary *airlineName;
@property (nonatomic, strong) NSMutableDictionary *airlineSelection;
@property (nonatomic, strong) NSMutableArray *stopSelection;
@property (nonatomic, assign) double minPrice;
@property (nonatomic, assign) double maxPrice;
@property (nonatomic, assign) double thresholdPrice;

- (id)initWithFlightResults:(NSArray *)flightResults;
- (NSArray *)getAirlineNames;
- (int)getRowCount:(BOOL)showAirlineOptions;
- (NSString *)getLabelForRow:(int)row showAirlineOptions:(BOOL)showAirlineOptions;
- (BOOL)isSelectedRow:(int)row showAirlineOptions:(BOOL)showAirlineOptions;
- (void)updateRow:(int)row value:(BOOL)value showAirlineOptions:(BOOL)showAirlineOptions;
- (void)updateAllWithValue:(BOOL)value airlineOptions:(BOOL)showAirlineOptions;
- (void)resetFilterParams;

@end
