//
//  CITFlightSuggestion.h
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRAutocompleteItemsSource.h"

@interface CITFlightSuggestion : NSObject <TRSuggestionItem>

@property(nonatomic) NSString *code;
@property(nonatomic) NSString *cityLabel;

- (id)initWith:(NSString *)cityLabel code:(NSString *)code;

@end
