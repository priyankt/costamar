//
//  CITSegmentGroupData.h
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITSegmentGroupData : NSObject

@property (nonatomic, strong) NSString *cityFrom;
@property (nonatomic, strong) NSString *cityTo;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *flightSegments;

- (id)initWithDictionary:(NSDictionary *)segmentGroupDict;
- (NSString *)getSectionTitle;
- (UIColor *)getSectionColor;

@end
