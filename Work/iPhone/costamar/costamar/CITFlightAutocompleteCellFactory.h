//
//  CITFlightAutocompleteCellFactory.h
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRAutocompletionCellFactory.h"

@interface CITFlightAutocompleteCellFactory : NSObject <TRAutocompletionCellFactory>

- (id)initWithCellForegroundColor:(UIColor *)foregroundColor fontSize:(CGFloat)fontSize;

@end
