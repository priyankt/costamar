//
//  CITSegmentedControl.m
//  costamar
//
//  Created by Mahavir Jain on 30/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSegmentedControl.h"

@implementation CITSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithSectionTitles:@[NSLocalizedString(@"btn_one_way", nil),NSLocalizedString(@"btn_multi_way", nil), NSLocalizedString(@"btn_multi_destination", nil)]];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setSelectedSegmentIndex:0];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_pressed.png"]]];
        [self setFont:[UIFont systemFontOfSize:15]];
        [self setTextColor:[UIColor whiteColor]];
        [self setSelectedTextColor:[UIColor whiteColor]];
        [self setSelectionStyle:HMSegmentedControlSelectionStyleBox];
        [self setSelectionLocation:HMSegmentedControlSelectionLocationDown];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.bounds.size.width, 50);
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
