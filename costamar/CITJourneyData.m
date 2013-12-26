//
//  CITJourneyData.m
//  costamar
//
//  Created by Mahavir Jain on 29/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import "CITJourneyData.h"
#import "CITUtils.h"
#import "IBCoreDataStore.h"
#import "NSManagedObject+InnerBand.h"
#import "CITSearchHistory.h"
#import "CITCountryData.h"
#import "CITPax.h"
#import "CITFlightAlert.h"

@implementation CITJourneyData

- (id)initWithOriginCode:(NSString *)originCode originAirport:(NSString *)originAirport destCode:(NSString *)destCode destAirport:(NSString *)destAirport fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate adults:(NSString *)adults children:(NSString *)children infants:(NSString *)infants tariff:(NSString *)tariff journeyType:(int)journeyType;
{
    self = [super init];
    if(self) {
        self.originCode = originCode;
        self.originAirport = originAirport;
        self.destCode = destCode;
        self.destAirport = destAirport;
        self.fromDate = fromDate;
        self.toDate = toDate;
        self.adults = adults;
        self.children = children;
        self.infants = infants;
        self.tariff = tariff;
        self.journeyType = journeyType;
    }
    
    return self;
}

- (NSString *)formattedFromDate
{
    return [[CITUtils dateFormatter] stringFromDate:self.fromDate];
}

- (NSDictionary *)getJourneyParams
{
    CITCountryData *countryData = [CITUtils getCountryPreference];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (self.originCode) {
        [data setObject:self.originCode forKey:@"cityfrom"];
    }
    if (self.destCode) {
        [data setObject:self.destCode forKey:@"cityto"];
    }
    
    NSDateFormatter *formatter = [CITUtils dateFormatter];
    
    if (self.fromDate) {
        [data setObject:[formatter stringFromDate:self.fromDate] forKey:@"datefrom"];
    }
    
    if (TWO_WAY == self.journeyType  && self.toDate) {
        [data setObject:[formatter stringFromDate:self.toDate] forKey:@"dateto"];
    } else {
        // send empty dateto string when one way
        [data setObject:@"" forKey:@"dateto"];
    }
    
    if (self.adults != nil) {
        [data setObject:self.adults forKey:@"adult"];
    }
    if (self.children != nil) {
        [data setObject:self.children forKey:@"child"];
    }
    if (self.infants != nil) {
        [data setObject:self.infants forKey:@"infant"];
    }
    if (self.tariff) {
        [data setObject:[CITUtils getValueForOption:self.tariff type:CABIN] forKey:@"cabin"];
    }
    if (countryData.countryCode) {
        [data setObject:countryData.countryCode forKey:@"countrycode"];
    }
    if (countryData.companyid) {
        [data setObject:countryData.companyid forKey:@"countryid"];
    }
    if (countryData.conglomerateid) {
        [data setObject:countryData.conglomerateid forKey:@"conglomerateid"];
    }
    if (countryData.affiliateid) {
        [data setObject:countryData.affiliateid forKey:@"affiliateid"];
    }
  
    return @{@"flight":data};
}

- (void)saveToHistory
{
    CITSearchHistory *searchHistory = [CITSearchHistory create];
    searchHistory.originCode = self.originCode;
    searchHistory.originAirport = self.originAirport;
    searchHistory.destCode = self.destCode;
    searchHistory.destAirport = self.destAirport;
    searchHistory.fromDate = self.fromDate;
    if (TWO_WAY == self.journeyType) {
        searchHistory.toDate = self.toDate;
    }
    searchHistory.adults = self.adults;
    searchHistory.children = self.children;
    searchHistory.infants = self.infants;
    searchHistory.tariff = self.tariff;
    searchHistory.dttm = [NSDate date];
    
    [[IBCoreDataStore mainStore] save];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:self.adults forKey:@"adults"];
    [encoder encodeObject:self.children forKey:@"children"];
    [encoder encodeObject:self.infants forKey:@"infants"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if(self)
	{
        //decode properties, other class vars
        self.adults = [decoder decodeObjectForKey:@"adults"];
        self.children = [decoder decodeObjectForKey:@"children"];
        self.infants = [decoder decodeObjectForKey:@"infants"];
	}
    
	return self;
}

- (NSArray *)getPaxList
{
    int adults = [self.adults intValue];
    int children = [self.children intValue];
    int infants = [self.infants intValue];
    
    NSMutableArray *paxList = [[NSMutableArray alloc] initWithCapacity:adults+children+infants];
    if (adults > 0) {
        for (int i=0; i < adults; i++) {
            // adult assigned is 0 for adult & children
            [paxList addObject:[[CITPax alloc] initWithType:ADULT adultAssigned:0]];
        }
    }
    if (children > 0) {
        for (int i=0; i < children; i++) {
            // adult assigned is 0 for adult & children
            [paxList addObject:[[CITPax alloc] initWithType:CHILD adultAssigned:0]];
        }
    }
    if (infants > 0) {
        for (int i=0; i < infants; i++) {
            // adult assigned is 0 for adult & children
            [paxList addObject:[[CITPax alloc] initWithType:INFANT adultAssigned:1]];
        }
    }
    
    return paxList;
}

- (NSDate *)getFromDate
{
    NSDate *date = self.fromDate;
    if (!date) {
        date = [CITUtils getDateFromTodayPlus:DAYS_GAP];
    }
    
    return date;
}

- (NSDate *)getToDate
{
    NSDate *date = self.toDate;
    if (!date) {
        if (self.fromDate) {
            date = [CITUtils addDays:1 toDate:self.fromDate];
        }
        else {
            date = [CITUtils getDateFromTodayPlus:DAYS_GAP+1];
        }
    }
    
    return date;
}

- (NSString *)getOriginAirport
{
    NSString *originAirport = self.originAirport;
    if (!originAirport) {
        originAirport = @"";
    }
    
    return originAirport;
}

- (NSString *)getDestAirport
{
    NSString *destAirport = self.destAirport;
    if (!destAirport) {
        destAirport = @"";
    }
    
    return destAirport;
}

- (NSString *)validate
{
    if (!self.originCode) {
        return NSLocalizedString(@"error_no_origin", nil);
    }
    if (!self.destCode) {
        return NSLocalizedString(@"error_no_destination", nil);
    }
    
    return nil;
}

- (void)saveToFlightAlerts
{
    CITFlightAlert *flightAlert = [CITFlightAlert create];
    flightAlert.adults = self.adults;
    flightAlert.children = self.children;
    flightAlert.infants = self.infants;
    flightAlert.tariff = self.tariff;
    flightAlert.originAirport = self.originAirport;
    flightAlert.originCode = self.originCode;
    flightAlert.destAirport = self.destAirport;
    flightAlert.destCode = self.destCode;
    flightAlert.fromDate = self.fromDate;
    flightAlert.toDate = self.toDate;
    flightAlert.type = [NSNumber numberWithInt:self.journeyType];
    flightAlert.dttm = [NSDate date];
    flightAlert.maxPrice = [NSString stringWithFormat:@"%@", self.maxPrice];
    //flightAlert.bestPrice = self.bestPrice;
    flightAlert.alertFrequency = self.alertFrequency;
    flightAlert.alertType = self.alertType;
    
    [[IBCoreDataStore mainStore] save];
    
    // create localnotification
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    NSString *key = @"daily_notification_scheduled";
    if ([[CITUtils getValueForOption:self.alertFrequency type:ALERT_FREQUENCY] isEqualToString:@"D"]) {
        localNotification.repeatInterval = NSDayCalendarUnit;
    } else {
        localNotification.repeatInterval = NSWeekCalendarUnit;
        key = @"weekly_notification_scheduled";
    }
    
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // schedule only when it is not scheduled
    if (!val || ![val boolValue]) {
        NSDateComponents *currentDateComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        [currentDateComps setHour:13];
        [currentDateComps setMinute:00];
        [currentDateComps setSecond:00];
        
        localNotification.fireDate = [[NSCalendar currentCalendar] dateFromComponents:currentDateComps];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = NSLocalizedString(@"notification_body", nil);
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = @"View";
        // Identify each notification using dttm
        localNotification.userInfo = @{@"key":flightAlert.dttm};
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
