//
//  CITMultiDestHeaderCell.m
//  costamar
//
//  Created by Mahavir Jain on 09/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITMultiDestHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CITMultiDestHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.contentView.layer setBorderWidth:1.0f];
        [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
