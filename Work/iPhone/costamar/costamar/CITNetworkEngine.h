//
//  CITNetworkEngine.h
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^IDBlock)(id object);

@interface CITNetworkEngine : MKNetworkEngine

// Get Countries list in the InitialViewController
- (MKNetworkOperation *) getCountriesListWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

// Get city suggestions for autocomplete
- (MKNetworkOperation *) getCitySuggestions:(NSString *)keyword CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;


@end
