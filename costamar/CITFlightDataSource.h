//
//  CITFlightDataSource.h
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRAutocompleteItemsSource.h"

@interface CITFlightDataSource : NSObject <TRAutocompleteItemsSource>

- (id)initWithMinimumCharactersToTrigger:(NSUInteger)minimumCharactersToTrigger;

@end
