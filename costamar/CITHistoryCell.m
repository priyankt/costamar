//
//  CITHistoryCell.m
//  costamar
//
//  Created by Mahavir Jain on 06/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITHistoryCell.h"
#import "CITUtils.h"

@implementation CITHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        UIView *selectionColor = [[UIView alloc] init];
//        selectionColor.backgroundColor = [CITUtils appDarkBlueColor];
//        self.selectedBackgroundView = selectionColor;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
