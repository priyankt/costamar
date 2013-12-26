//
//  CITDatePicker.m
//  costamar
//
//  Created by Mahavir Jain on 30/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITDatePicker.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+InnerBand.h"
#import "CITUtils.h"

@implementation CITDatePicker {
    NSDateFormatter *formatter;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        int padding = 3;
        
        self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 90)];
        [self addSubview:self.btn];
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+padding, 0+padding, 140-padding-padding, 21)];
        self.headerLabel.textAlignment = NSTextAlignmentCenter;
        self.headerLabel.font = [UIFont systemFontOfSize:12];
        self.headerLabel.text = NSLocalizedString(@"departure_date", nil);
        [self addSubview:self.headerLabel];
        
        UIImageView *calendar = [[UIImageView alloc] initWithFrame:CGRectMake(0+padding, self.headerLabel.frame.origin.y+self.headerLabel.frame.size.height+padding, 30, 30)];
        calendar.image = [UIImage imageNamed:@"calendar.png"];
        calendar.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:calendar];
        
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(calendar.frame.origin.x+calendar.frame.size.width+padding, calendar.frame.origin.y, 30, 30)];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:self.dayLabel];
        
        self.monthAndYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.dayLabel.frame.origin.x+self.dayLabel.frame.size.width+padding, self.dayLabel.frame.origin.y, 60, 21) ];
        self.monthAndYearLabel.textAlignment = NSTextAlignmentLeft;
        self.monthAndYearLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.monthAndYearLabel];
        
        self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.monthAndYearLabel.frame.origin.x, self.monthAndYearLabel.frame.origin.y+self.monthAndYearLabel.frame.size.height, self.monthAndYearLabel.bounds.size.width, self.monthAndYearLabel.bounds.size.height)];
        self.subLabel.textAlignment = NSTextAlignmentLeft;
        self.subLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.subLabel];
        
        self.layer.masksToBounds=YES;
        self.layer.borderWidth= 1.0f;
        self.layer.borderColor = [[CITUtils borderColor] CGColor];
        
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es"];
    }
    
    return self;
}

- (NSString *)getDayFromDate:(NSDate *)date
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    return [NSString stringWithFormat:@"%ld", (long)[components day]];
}

- (NSString *)getMonthAndYearStringFromDate:(NSDate *)date
{
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MMM ''yy"];
    
    return [[formatter stringFromDate:date] capitalizedString];
}

- (NSString *)getWeekdayStringFromDate:(NSDate *)date
{
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"EEE"];
    
    return [[formatter stringFromDate:date] capitalizedString];
}

- (void)updateDateLabels:(NSDate *)date
{
    self.dayLabel.text = [self getDayFromDate:date];
    self.monthAndYearLabel.text = [self getMonthAndYearStringFromDate:date];
    self.subLabel.text = [self getWeekdayStringFromDate:date];
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
