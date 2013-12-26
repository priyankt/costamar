//
//  CITFlightJourney.h
//  costamar
//
//  Created by Mahavir Jain on 22/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CITFlightJourney : NSManagedObject

@property (nonatomic, retain) NSString * adults;
@property (nonatomic, retain) NSString * children;
@property (nonatomic, retain) NSString * destAirport;
@property (nonatomic, retain) NSString * destCode;
@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSString * infants;
@property (nonatomic, retain) NSString * originAirport;
@property (nonatomic, retain) NSString * originCode;
@property (nonatomic, retain) NSString * tariff;
@property (nonatomic, retain) NSDate * toDate;
@property (nonatomic, retain) NSNumber * type;

@end
