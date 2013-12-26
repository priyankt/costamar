//
//  CITDatePicker.h
//  costamar
//
//  Created by Mahavir Jain on 30/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CITDatePicker : UIView

@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *monthAndYearLabel;
@property (strong, nonatomic) UILabel *subLabel;
@property (strong, nonatomic) UILabel *headerLabel;

- (void)updateDateLabels:(NSDate *)date;

@end
