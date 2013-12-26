//
//  CITNetworkEngine.h
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "MKNetworkEngine.h"

@class CITJourneyData;
@class CITFlightData;
@class CITFlightDetailData;
@class CITMultiDestData;
@class CITBookingPayment;

typedef void (^IDBlock)(id object);

@interface CITNetworkEngine : MKNetworkEngine

// Get Countries list in the InitialViewController
- (MKNetworkOperation *) getCountriesListWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

// Get city suggestions for autocomplete
- (MKNetworkOperation *) getCitySuggestions:(NSString *)keyword CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

// Fetch flight icons
- (MKNetworkOperation *) fetchFlightIconsWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *) searchFlightsForJourney:(CITJourneyData *)journeyParams CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *) searchFlightsForMultiDestJourney:(CITMultiDestData *)multiDestData CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *) getFlightDetialWithData:(CITFlightData *)flightData CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *) getFlightPricingForFlight:(CITFlightDetailData *)flightDetail CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

- (MKNetworkOperation *) getPaymentMethods:(NSString *)flightId affiliateId:(NSNumber *)affiliateId countryCode:(NSString *)countryCode CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;

// path = /BookFlight
- (MKNetworkOperation *) bookFlightWithBookingPayment:(CITBookingPayment *)bookingPayment CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock;


@end
