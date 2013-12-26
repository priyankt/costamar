//
//  CITNetworkEngine.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITNetworkEngine.h"
#import "CITFlightSuggestion.h"
#import "CITUtils.h"
#import "CITFlightData.h"
#import "CITFlightDetailData.h"
#import "CITPaymentOption.h"
#import "CITBookingResponse.h"
#import "CITCountryData.h"
#import "CITJourneyData.h"
#import "CITMultiDestData.h"
#import "CITBookingPayment.h"

@implementation CITNetworkEngine

- (MKNetworkOperation *) getCountriesListWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/CountryAffiliate" params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *countriesResponse = [completedOperation responseJSON];
        NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:[countriesResponse count]];
        for (NSDictionary *countryDict in countriesResponse) {
            [countries addObject:[[CITCountryData alloc] initWithDictionary:countryDict]];
        }
        completionBlock(countries);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) getCitySuggestions:(NSString *)keyword CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"FlightService/Rest/CityAirport/%@", keyword] params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *countriesSuggestions = [completedOperation responseJSON];
        NSMutableArray *suggestions = [[NSMutableArray alloc] init];
        for (NSDictionary *city in countriesSuggestions)
        {
            CITFlightSuggestion
            *suggestion = [[CITFlightSuggestion alloc] initWith:[city objectForKey:@"label"] code:[city objectForKey:@"code"]];
            [suggestions addObject:suggestion];
        }
        completionBlock(suggestions);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) fetchFlightIconsWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    NSString *currentFilename = [CITUtils getIconFilename];
    if (!currentFilename)
        currentFilename = @"";
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"FlightService/Rest/DownloadAirlineIcon/%@", currentFilename] params:nil httpMethod:@"GET"];
    
    NSString *filepath = [CITUtils getIconFilePath:currentFilename];
    
    [op addDownloadStream:[NSOutputStream
                                  outputStreamToFileAtPath:filepath
                                  append:YES]];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *outputFilePath = nil;
        NSString *newFilename = completedOperation.readonlyResponse.allHeaderFields[@"filename"];
        if (newFilename && ![newFilename isEqualToString:currentFilename]) {
            [CITUtils setIconFilename:newFilename];
            outputFilePath = [CITUtils unzip:filepath];
        }
        [CITUtils removeFile:filepath];
        completionBlock(outputFilePath);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) searchFlightsForJourney:(CITJourneyData *)journeyParams CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/Flights" params:[journeyParams getJourneyParams] httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *responseArray = [completedOperation responseJSON];
        NSMutableArray *flights = [[NSMutableArray alloc] init];
        for (NSDictionary *flightDict in responseArray) {
            [flights addObject:[[CITFlightData alloc] initWithDictionary:flightDict]];
        }
        completionBlock(flights);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) searchFlightsForMultiDestJourney:(CITMultiDestData *)multiDestData CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/MultiFlights" params:[multiDestData getMultiDestParams] httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *responseArray = [completedOperation responseJSON];
        NSLog(@"%@", responseArray);
        NSMutableArray *flights = [[NSMutableArray alloc] init];
        for (NSDictionary *flightDict in responseArray) {
            [flights addObject:[[CITFlightData alloc] initWithDictionary:flightDict]];
        }
        completionBlock(flights);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) getFlightDetialWithData:(CITFlightData *)flightData CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/FlightDetail" params:[flightData getFlightDetailParams] httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseDict = [completedOperation responseJSON];
        NSLog(@"%@", responseDict);
        CITFlightDetailData *flightDetailData = [[CITFlightDetailData alloc] initWithDictionary:responseDict];
        completionBlock(flightDetailData);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) getFlightPricingForFlight:(CITFlightDetailData *)flightDetail CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/FlightPricing" params:[flightDetail getParamsForFlightPricing] httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseDict = [completedOperation responseJSON];
        NSLog(@"%@", responseDict);
        CITFlightDetailData *flightDetailData = [[CITFlightDetailData alloc] initWithDictionary:responseDict];
        completionBlock(flightDetailData);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) getPaymentMethods:(NSString *)flightId affiliateId:(NSNumber *)affiliateId countryCode:(NSString *)countryCode CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@", @"FlightService/Rest/PaymentMethod", flightId, [affiliateId stringValue], countryCode];
    
    MKNetworkOperation *op = [self operationWithPath:requestUrl params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSArray *responseArray = [completedOperation responseJSON];
        NSLog(@"%@", responseArray);
        NSMutableArray *paymentOptionsArray = [[NSMutableArray alloc] initWithCapacity:[responseArray count]];
        for (NSDictionary *paymentData in responseArray) {
            [paymentOptionsArray addObject:[[CITPaymentOption alloc] initWithDict:paymentData]];
        }
        completionBlock(paymentOptionsArray);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}

- (MKNetworkOperation *) bookFlightWithBookingPayment:(CITBookingPayment *)bookingPayment CompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/BookFlight" params:[bookingPayment toDict] httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseDict = [completedOperation responseJSON];
        NSLog(@"%@", responseDict);
        CITBookingResponse *bookingResponse = [[CITBookingResponse alloc] initWithDictionary:responseDict];
        completionBlock(bookingResponse);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){
        
        NSLog(@"%@", error);
        errorBlock(error);
        
    }];
    
    return op;
}


@end
