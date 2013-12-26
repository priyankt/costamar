//
//  CITTextField.m
//  costamar
//
//  Created by Mahavir Jain on 28/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "TRAutocompleteView.h"
#import "CITFlightDataSource.h"
#import "CITFlightAutocompleteCellFactory.h"
#import "CITFlightSuggestion.h"
#import "CITUtils.h"

@implementation CITTextField {
    TRAutocompleteView *autocompleteView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.layer.masksToBounds=YES;
        self.layer.borderWidth= 1.0f;
        self.layer.borderColor = [[CITUtils borderColor] CGColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_location.png"]];
        CALayer *sublayer = [CALayer layer];
        sublayer.backgroundColor = [[CITUtils borderColor] CGColor];
        sublayer.frame = CGRectMake(0, 0, 1, imageView.frame.size.height);
        [imageView.layer addSublayer:sublayer];
        //[rightView addSubview:imageView];
        
        self.rightView = imageView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
