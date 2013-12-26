//
//  CITSearchDetailSectionHeaderView.h
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CITSearchDetailSectionHeaderView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *bottomBorder;

- (void)setColor:(UIColor *)color;

@end
