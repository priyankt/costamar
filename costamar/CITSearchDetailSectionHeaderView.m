//
//  CITSearchDetailSectionHeaderView.m
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSearchDetailSectionHeaderView.h"
#import "CITUtils.h"

@implementation CITSearchDetailSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int leftPadding = 9;
        int topPadding = 5;
        int width = frame.size.width;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+leftPadding, 0+topPadding, (int)(width*0.9), 21)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:self.titleLabel];
        
        self.bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, self.frame.size.width, 1)];
        [self addSubview:self.bottomBorder];
    }
    
    return self;
}

- (void)setColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
    self.bottomBorder.backgroundColor = color;
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
