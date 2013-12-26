//
//  CITUtils.h
//  costamar
//
//  Created by Mahavir Jain on 14/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CITNetworkEngine;
@class CITCountryData;
@class CITJourneyData;

#define ADULTS @"adult"
#define INFANTS @"infant"
#define CHILDREN @"children"
#define CABIN @"cabin_type"
#define ALERT_FREQUENCY @"alert_frequency"
#define ALERT_TYPE @"alert_type"
#define ALERT_ACTION @"alert_action"
#define TITLES @"title"
#define DOC_TYPES @"doc_type"
#define COUNTRIES @"country"
#define STOPS @"stop"

#define ONE_WAY 1
#define TWO_WAY 2
#define MULTI_DEST 3

#define DAYS_GAP 2

#define DATE_FORMAT @"dd/MM/yyyy"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface CITUtils : NSObject

+ (NSDateFormatter *) dateFormatter;
+ (CITNetworkEngine *) networkEngine;
+ (UIAlertView *) alertView;

+ (CITCountryData *)getCountryPreference;
+ (void)setCountryPreference:(CITCountryData *)countryData;

+ (NSString *)getIconFilename;
+ (void)setIconFilename:(NSString *)filename;

+ (NSArray *)getOptionsForType:(NSString *)type;
+ (NSString *)getValueForOption:(NSString *)option type:(NSString *)type;
+ (NSString *)getOptionForValue:(NSString *)value type:(NSString *)type;

+ (NSString *)prependSpace:(NSString *)text;

+ (NSString *)getIconFilePath:(NSString *)filename;
+ (NSString *)unzip:(NSString *)filepath;
+ (void)removeFile:(NSString *)filepath;

+ (NSDate *)getDateFromTodayPlus:(int)days;
+ (NSDate *)addDays:(int)days toDate:(NSDate *)date;

+ (UIImage *)getFlightImageForAirline:(NSString *)airline;
+ (NSAttributedString *)getAttributedStringWithPrefix:(NSString *)prefix value:(NSString *)value;

// Colors
+ (UIColor *)borderColor;
+ (UIColor *)appOrangeColor;
+ (UIColor *)appBlueColor;
+ (UIColor *)appDarkBlueColor;
+ (UIColor *)calendarRedColor;

// Save and retrieve journey params. Used when obtaining passenger info
+ (void)saveJourneyParams:(CITJourneyData *)journeyParams;
+ (CITJourneyData *)retrieveJourneyParams;

+ (NSComparisonResult)compareDate1:(NSDate *)date1 Date2:(NSDate *)date2;

@end
