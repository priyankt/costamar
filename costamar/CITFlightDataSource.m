//
//  CITFlightDataSource.m
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightDataSource.h"
#import "CITUtils.h"
#import "MKNetworkOperation.h"
#import "CITNetworkEngine.h"

@implementation CITFlightDataSource {
    NSUInteger minChars;
    BOOL _requestToReload;
    BOOL _loading;
}

- (id)initWithMinimumCharactersToTrigger:(NSUInteger)minimumCharactersToTrigger
{
    self = [super init];
    if (self)
    {
        minChars = minimumCharactersToTrigger;
    }
    
    return self;
}

- (NSUInteger)minimumCharactersToTrigger
{
    return minChars;
}

- (void)itemsFor:(NSString *)query whenReady:(void (^)(NSArray *))suggestionsReady
{
    @synchronized (self)
    {
        if (_loading)
        {
            _requestToReload = YES;
            return;
        }
        
        _loading = YES;
        [self requestSuggestionsFor:query whenReady:suggestionsReady];
    }
}

- (void)requestSuggestionsFor:(NSString *)query whenReady:(void (^)(NSArray *))suggestionsReady
{
    MKNetworkOperation *getCitySuggestionsOperation = [ [CITUtils networkEngine] getCitySuggestions:query CompletionHandler:^(NSArray *suggestions) {
        
        if (suggestionsReady)
            suggestionsReady(suggestions);
        
        @synchronized (self)
        {
            _loading = NO;
            
            if (_requestToReload)
            {
                _requestToReload = NO;
                [self itemsFor:query whenReady:suggestionsReady];
            }
        }
    } errorHandler:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
        
    }];
    
    [[CITUtils networkEngine] enqueueOperation:getCitySuggestionsOperation];
}


@end
