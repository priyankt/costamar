//
//  CITNetworkEngine.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITNetworkEngine.h"
#import "CITCountry.h"
#import "CITFlightSuggestion.h"

@implementation CITNetworkEngine

- (MKNetworkOperation *) getCountriesListWithCompletionHandler:(IDBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:@"FlightService/Rest/CountryAffiliate" params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSArray *countriesResponse = [completedOperation responseJSON];
//        NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:[countriesResponse count]];
//        for (NSDictionary *countryData in countriesResponse) {
//            CITCountry *country = [[CITCountry alloc] initWithDictionary:countryData];
//            [countries insertObject:country atIndex:[countriesResponse indexOfObject:countryData]];
//        }
        completionBlock(countriesResponse);
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



@end
