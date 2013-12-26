//
//  CITSegmentGroupData.m
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSegmentGroupData.h"
#import "CITUtils.h"
#import "CITFlightSegmentData.h"

@implementation CITSegmentGroupData

- (id)initWithDictionary:(NSDictionary *)segmentGroupDict
{
    self = [super init];
    if (self) {
        self.cityFrom = segmentGroupDict[@"CityFrom"];
        self.cityTo = segmentGroupDict[@"CityTo"];
        
        self.date = [[CITUtils dateFormatter] dateFromString:segmentGroupDict[@"Date"]];
        
        self.flightSegments = [[NSMutableArray alloc] init];
        for (NSDictionary *segment in segmentGroupDict[@"FlightSegment"]) {
            [self.flightSegments addObject:[[CITFlightSegmentData alloc] initWithDictionary:segment]];
        }
    }
    
    return self;
}

- (NSString *)getSectionTitle
{
    return [NSString stringWithFormat:@"%@ - %@", self.cityFrom, self.cityTo];
}

- (UIColor *)getSectionColor
{
    return [UIColor blueColor];
}

@end
