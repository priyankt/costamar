//
//  CITUtils.m
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITUtils.h"
#import "CITAppDelegate.h"
#import "SSZipArchive.h"
#import "UIColor+InnerBand.h"

@implementation CITUtils

+ (NSDateFormatter *)dateFormatter
{
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.formatter;
}

+ (CITNetworkEngine *) networkEngine
{
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.networkEngine;
}

+ (UIAlertView *)alertView
{
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.alertView;
}

+ (void)setCountryPreference:(CITCountryData *)countryData
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:countryData];
	[[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"country"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CITCountryData *)getCountryPreference
{
    CITCountryData *countryData = nil;
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"country"];
    if (encodedObject) {
        countryData = (CITCountryData *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
    }
    
    return countryData;
}

+ (NSString *)getIconFilename
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"filename"];
}

+ (void)setIconFilename:(NSString *)filename
{
    [[NSUserDefaults standardUserDefaults] setObject:filename forKey:@"filename"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeFile:(NSString *)filepath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:filepath error:&error];
}

// GETTING AND SETTING OPTION VALUES FROM PLIST FILE
+ (NSArray *)getOptionsForType:(NSString *)type
{
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *optionsArray = [appDelegate.optionsDictionary objectForKey:[NSString stringWithFormat:@"%@_labels", type]];
    
    return optionsArray;
}

+ (NSString *)getValueForOption:(NSString *)option type:(NSString *)type
{
    NSString *value = option;
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *valuesArray = [appDelegate.optionsDictionary objectForKey:[NSString stringWithFormat:@"%@_values", type]];
    if (valuesArray) {
        NSArray *optionsArray = [appDelegate.optionsDictionary objectForKey:[NSString stringWithFormat:@"%@_labels", type]];
        int optionIndex = [optionsArray indexOfObject:option];
        if (optionIndex != NSNotFound) {
            value = [valuesArray objectAtIndex:optionIndex];
        }
    }
    
    return value;
}

+ (NSString *)getOptionForValue:(NSString *)value type:(NSString *)type
{
    NSString *option = value;
    CITAppDelegate *appDelegate = (CITAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *optionsArray = [appDelegate.optionsDictionary objectForKey:[NSString stringWithFormat:@"%@_labels", type]];
    NSArray *valuesArray = [appDelegate.optionsDictionary objectForKey:[NSString stringWithFormat:@"%@_values", type]];
    int valueIndex = [valuesArray indexOfObject:option];
    if (valueIndex != NSNotFound) {
        option = [optionsArray objectAtIndex:valueIndex];
    }
    
    return option;
}

+ (NSString *)prependSpace:(NSString *)text
{
    return [NSString stringWithFormat:@" %@",text];
}

// GET FILEPATH FROM FILENAME
+ (NSString *)getIconFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    if ([filename length] <= 0) {
        filename = @"icons.zip";
    }
    
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory,filename];
}

+ (NSString *)unzip:(NSString *)filepath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *destPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"icons"];
    
    [SSZipArchive unzipFileAtPath:filepath toDestination:destPath delegate:nil];
    
    return destPath;
}

+ (NSDate *)getDateFromTodayPlus:(int)days
{
    return [self addDays:days toDate:[NSDate date]];
}

+ (NSDate *)addDays:(int)days toDate:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:days];

    return [[NSCalendar currentCalendar]
            dateByAddingComponents:dateComponents
            toDate:date options:0];
}

+ (NSString *)getTariffValueFor:(NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"options" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *data = [dictionary objectForKey:CABIN];
    
    return [data objectForKey:key];
}

+ (UIImage *)getFlightImageForAirline:(NSString *)airline
{
    UIImage *flightImage = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [airline lowercaseString]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory, @"icons", imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        flightImage = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return flightImage;
}

+ (NSAttributedString *)getAttributedStringWithPrefix:(NSString *)prefix value:(NSString *)value
{
    NSString *fullString = [NSString stringWithFormat:@"%@%@", prefix, value];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:[fullString rangeOfString:prefix]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[fullString rangeOfString:prefix]];
    if (value) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[fullString rangeOfString:value]];        
    }
    
    return attributedString;
    
}

+ (UIColor *)borderColor
{
    return [UIColor colorWithHexString:@"#c6c6c6"];
}

+ (UIColor *)appOrangeColor
{
    return [UIColor colorWithHexString:@"#f39200"];
}

+ (UIColor *)appBlueColor
{
    return [UIColor colorWithHexString:@"#36a9e1"];
}

+ (UIColor *)appDarkBlueColor
{
    return [UIColor colorWithHexString:@"#08558c"];
}

+ (UIColor *)calendarRedColor
{
    return [UIColor colorWithHexString:@"#F26B74"];
}

+ (void)saveJourneyParams:(CITJourneyData *)journeyParams
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:journeyParams];
	[[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"journey_params"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CITJourneyData *)retrieveJourneyParams
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"journey_params"];
    CITJourneyData *journeyParams = (CITJourneyData *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedObject];
    
    return journeyParams;
}

+ (NSComparisonResult)compareDate1:(NSDate *)date1 Date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: date1];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: date2];
    
    date1 = [calendar dateFromComponents:date1Components];
    date2 = [calendar dateFromComponents:date2Components];

    return [date1 compare:date2];
}

@end
