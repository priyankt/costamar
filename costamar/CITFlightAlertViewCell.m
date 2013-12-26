//
//  CITFlightAlertViewCell.m
//  costamar
//
//  Created by Mahavir Jain on 21/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITFlightAlertViewCell.h"
#import "CITUtils.h"

@implementation CITFlightAlertViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.headerLabel.textColor = [CITUtils appDarkBlueColor];
    self.dateLabel.textColor = [CITUtils appDarkBlueColor];
    self.passengerLabel.textColor = [CITUtils appDarkBlueColor];
    self.maxPriceLabel.textColor = [CITUtils appDarkBlueColor];
    self.bestPriceLabel.textColor = [CITUtils appDarkBlueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
