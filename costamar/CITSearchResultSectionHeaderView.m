//
//  CITSearchResultSectionHeaderView.m
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITSearchResultSectionHeaderView.h"

@implementation CITSearchResultSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int leftPadding = 5;
        int topPadding = 5;
        int width = frame.size.width;
        
        self.PriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+leftPadding, 0+topPadding, (int)(width*0.6), 21)];
        [self addSubview:self.PriceLabel];
        
        self.flightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.PriceLabel.frame.origin.x+self.PriceLabel.frame.size.width+leftPadding, self.PriceLabel.frame.origin.y, (int)(width*0.3), 30)];
        self.flightImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.flightImageView.image = [UIImage imageNamed:@"image.jpg"];
        
        [self addSubview:self.flightImageView];        
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
