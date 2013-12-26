//
//  CITFlightAutocompleteCellFactory.m
//  costamar
//
//  Created by Mahavir Jain on 19/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightAutocompleteCellFactory.h"
#import "TRAutocompleteItemsSource.h"

@interface CITFlightAutocompletionCell : UITableViewCell <TRAutocompletionCell>
@end

@implementation CITFlightAutocompletionCell

- (void)updateWith:(id <TRSuggestionItem>)item
{
    self.textLabel.text = item.completionText;
}

@end


@implementation CITFlightAutocompleteCellFactory {
    UIColor *_foregroundColor;
    CGFloat _fontSize;
}

- (id)initWithCellForegroundColor:(UIColor *)foregroundColor fontSize:(CGFloat)fontSize
{
    self = [super init];
    if (self)
    {
        _foregroundColor = foregroundColor;
        _fontSize = fontSize;
    }
    
    return self;
}

- (id <TRAutocompletionCell>)createReusableCellWithIdentifier:(NSString *)identifier
{
    CITFlightAutocompletionCell *cell = [[CITFlightAutocompletionCell alloc]
                                            initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:identifier];
    
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.textColor = _foregroundColor;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
