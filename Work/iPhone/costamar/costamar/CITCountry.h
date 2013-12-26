//
//  CITCountry.h
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CITCountry : NSManagedObject

@property (nonatomic, retain) NSNumber *affiliateId;
@property (nonatomic, retain) NSNumber *companyId;
@property (nonatomic, retain) NSNumber *conglomerateId;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *countryName;

//- (id)initWithDictionary:(NSDictionary *)data;

@end
