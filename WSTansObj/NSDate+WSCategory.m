//
//  NSDate+WSCategory.m
//  WSFouncDesign
//
//  Created by wangsen on 14-7-28.
//  Copyright (c) 2014年 wangsen. All rights reserved.
//

#import "NSDate+WSCategory.h"

@implementation NSDate (Category)

/**
 *  返回中国时间 格式：yyyy-MM-dd HH:mm:ss
 *
 *  @return 时间字符串
 */
+ (NSString *)ws_current_DateTime
{
    //用[NSDate date]可以获取系统当前时间
    NSDate *date = [NSDate date];
    return [date ws_convertDateToStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
/**
 *  返回中国时间 格式：yyyy-MM-dd
 *
 *  @return 时间字符串
 */
+ (NSString *)ws_current_Date
{
    //用[NSDate date]可以获取系统当前时间
    NSDate *date = [NSDate date];
    return [date ws_convertDateToStringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)ws_convertDateToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}
/**
 *  @brief 时间转字符串
 *
 *  @param format 时间格式
 *
 *  @return 时间字符串
 */
- (NSString *)ws_stringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return dateString;
}
- (NSDate *)ws_convertStringToDate:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

- (NSDate *)dateStartOfWeek
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday]) + 7 ) % 7)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
    
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}

// ================================ 扩展 ===========================
// 判断是否是昨天或更早
- (BOOL)isYesterdayOrEarlier
{
    NSDate *yesterdayDefintionDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24];
    NSDate *definitionDate = [self convertDefinitionToDate];
    if ([yesterdayDefintionDate isEqualToDate:definitionDate]) {
        return YES;
    }
    
    NSDate *earlierDate = [definitionDate earlierDate:[NSDate date]];
    if (earlierDate == self) {
        return YES;
    }
    return NO;
}

// 判断是否是明天或更晚
- (BOOL)isTomorrowOrLater
{
    NSDate *tomorrowDefintionDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    NSDate *definitionDate = [self convertDefinitionToDate];
    if ([tomorrowDefintionDate isEqualToDate:definitionDate]) {
        return YES;
    }
    
    NSDate *laterDate = [definitionDate laterDate:tomorrowDefintionDate];
    if (laterDate == self) {
        return YES;
    }
    return NO;
}
// =================================================================

// 判断是否是下一周或者更远
- (BOOL)isNextWeekOrLater
{
    if (![self isThisWeek]) {
        NSDate *laterDate = [self laterDate:[NSDate date]];
        if (laterDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是上一周或者更早
- (BOOL)isLastWeekOrEarlier
{
    if (![self isThisWeek]) {
        NSDate *earlierDate = [self earlierDate:[NSDate date]];
        if (earlierDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是本周
- (BOOL)isThisWeek
{
    NSDate *thisWeekStartDay = [[NSDate date] dateStartOfWeek];
    if ([thisWeekStartDay isEqualToDate:[self dateStartOfWeek]]) {
        return YES;
    }
    return NO;
}

// 判断是否是本周更早
- (BOOL)isThisWeekEarlier
{
    if ([self isThisWeek]) {
        NSDate *earlierDate = [self earlierDate:[NSDate date]];
        if (earlierDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是本周晚些
- (BOOL)isThisWeekLater
{
    if ([self isThisWeek]) {
        NSDate *laterDate = [self laterDate:[NSDate date]];
        if (laterDate == self) {
            return YES;
        }
    }
    return NO;
}

// 判断是否是前天
- (BOOL)isTheDayBeforeYesterday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 2]];
    NSDate *dayAfterTomorrow = [cal dateFromComponents:components];
    
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([dayAfterTomorrow isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是昨天
- (BOOL)isYesterDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是今天
- (BOOL)isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是明天
- (BOOL)isTomorrow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]];
    NSDate *tomorrow = [cal dateFromComponents:components];
    
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([tomorrow isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

// 判断是否是后天
- (BOOL)isTheDayAfterTomorrow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 2]];
    NSDate *dayAfterTomorrow = [cal dateFromComponents:components];
    
    components = [cal components:calendarUnit fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([dayAfterTomorrow isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}


// 转换成年月日（其他补0）
- (NSDate *)convertDefinitionToDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSDate *dateConverted = [cal dateFromComponents:components];
    return dateConverted;
}

// 转换标准时间
- (NSString *)convertToStandardDateFormat
{
    // eg: 2014-01-03 19:36 星期五
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger weekday = [components weekday];
    
    NSString *weekdayStr = nil;
    switch (weekday) {
        case 1:
            weekdayStr = @"星期日";
            break;
        case 2:
            weekdayStr = @"星期一";
            break;
        case 3:
            weekdayStr = @"星期二";
            break;
        case 4:
            weekdayStr = @"星期三";
            break;
        case 5:
            weekdayStr = @"星期四";
            break;
        case 6:
            weekdayStr = @"星期五";
            break;
        case 7:
            weekdayStr = @"星期六";
            break;
        default:
            break;
    }
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d %@", (int)year, (int)month, (int)day, (int)hour, (int)minute, weekdayStr];
    return standardDateFormatStr;
}

// 转换本星期标准时间
- (NSString *)convertToStandardThisWeekDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger weekday = [components weekday];
    
    NSString *weekdayStr = nil;
    switch (weekday) {
        case 1:
            weekdayStr = @"星期日";
            break;
        case 2:
            weekdayStr = @"星期一";
            break;
        case 3:
            weekdayStr = @"星期二";
            break;
        case 4:
            weekdayStr = @"星期三";
            break;
        case 5:
            weekdayStr = @"星期四";
            break;
        case 6:
            weekdayStr = @"星期五";
            break;
        case 7:
            weekdayStr = @"星期六";
            break;
        default:
            return nil;
            break;
    }
    
    NSString *standardThisWeekDateFormatStr = [NSString stringWithFormat:@"%@ %02d:%02d", weekdayStr, (int)hour, (int)minute];
    return standardThisWeekDateFormatStr;
}

- (NSString *)convertToStandardTimeDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSCalendarUnitHour
                                   | NSCalendarUnitMinute);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *timeDateFormatStr = [NSString stringWithFormat:@"%02d:%02d", (int)hour, (int)minute];
    return timeDateFormatStr;
}

- (NSString *)convertToStandardNormalDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *dateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute];
    return dateFormatStr;
}

// 转换成YYYY-MM-DD HH:MM:SS格式时间
- (NSString *)convertToStandardYYYYMMDDHHMMSSDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];
    return standardDateFormatStr;
}

- (NSString *)convertToYYYYMMDDHHMMSSDateFormat {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];
    return standardDateFormatStr;
}

// 转换成YYYY-MM-DD
- (NSString *)convertToStandardYYYYMMDDDateFormat
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *standardDateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)day];
    return standardDateFormatStr;
}

// 转换成标准前天、昨天、今天、明天、后天时间  今天 19:36
- (NSString *)convertToStandardRecentlyDateFormat
{
    NSString *dateStr = nil;
    if ([self isToday]) {
        dateStr = @"今天";
    } else if ([self isTomorrow]) {
        dateStr = @"明天";
    } else if ([self isTheDayAfterTomorrow]) {
        dateStr = @"后天";
    } else if ([self isYesterDay]) {
        dateStr = @"昨天";
    } else if ([self isTheDayBeforeYesterday]) {
        dateStr = @"前天";
    } else {
        NSLog(@"类型错误:%s", __FUNCTION__);
        return nil;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSCalendarUnitHour
                                   | NSCalendarUnitMinute);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:self];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *todayDateFormatStr = [NSString stringWithFormat:@"%@ %02d:%02d", dateStr, (int)hour, (int)minute];
    return todayDateFormatStr;
}

+ (NSDateComponents *)dateComponentsByDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfYearCalendarUnit;
    return [calendar components:calendarUnit fromDate:date];
}

+ (NSInteger)weekdayByDate:(NSDate *)date {
    return [[self dateComponentsByDate:date] weekday];
}

+ (NSString *)weekdayInChineseByDate:(NSDate *)date {
    NSString *name = nil;
    NSInteger weekday = [NSDate weekdayByDate:date];
    switch (weekday) {
        case 1:
            name = @"周日";
            break;
        case 2:
            name = @"周一";
            break;
        case 3:
            name = @"周二";
            break;
        case 4:
            name = @"周三";
            break;
        case 5:
            name = @"周四";
            break;
        case 6:
            name = @"周五";
            break;
        case 7:
            name = @"周六";
            break;
        default:
            break;
    }
    return name;
}

+ (NSDate *)dateWithDays:(NSUInteger)days beforDate:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate] - 86400 * days;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
}

+ (NSDate *)dateWithDays:(NSUInteger)days afterDate:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSinceReferenceDate] + 86400 * days;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
}

+ (NSArray *)dayNamesAtDays:(NSInteger)days beforDate:(NSDate *)date {
    NSMutableArray *names = [NSMutableArray array];
    NSInteger currentMonthDay = [NSDate dayByDate:date];
    
    for (int i = (int)days - 1; i >= currentMonthDay ; i--) {
        NSDate *date = [NSDate dateWithDays:i beforDate:[NSDate date]];
        NSInteger day = [NSDate dayByDate:date];
        [names addObject:[NSString stringWithFormat:@"%d", (int)day]];
    }
    
    for (int i = (int)currentMonthDay - 1; i >= 0; i--) {
        NSDate *date = [NSDate dateWithDays:i beforDate:[NSDate date]];
        NSInteger day = [NSDate dayByDate:date];
        [names addObject:[NSString stringWithFormat:@"%d", (int)day]];
    }
    return names;
}

+ (NSInteger)yearByDate:(NSDate *)date {
    return [[self dateComponentsByDate:date] year];
}

+ (NSInteger)monthByDate:(NSDate *)date {
    return [[self dateComponentsByDate:date] month];
}

+ (NSInteger)dayByDate:(NSDate *)date {
    return [[self dateComponentsByDate:date] day];
}

+ (NSInteger)weekOfYearByDate:(NSDate *)date {
    return [[self dateComponentsByDate:date] weekOfYear];
}

+(NSString *)getCurrentDateHHMM
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSUInteger)daysInMonthByDate:(NSDate *)date {
    NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return dayRange.length;
}

+ (NSString *)convertToyyyMMddHHmmssString:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = (  NSEraCalendarUnit
                                   | NSYearCalendarUnit
                                   | NSMonthCalendarUnit
                                   | NSDayCalendarUnit
                                   | NSCalendarUnitWeekday
                                   | NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond);
    
    NSDateComponents *components = [cal components:calendarUnit fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *dateFormatStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)year, (int)month, (int)day, (int)hour, (int)minute, (int)second];
    return dateFormatStr;
}
/**
 *  @brief 日期相隔多少天
 */
- (NSInteger)daysSinceDate:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags
                                                   fromDate:self
                                                     toDate:anotherDate
                                                    options:0];
    return [dateComponents day];
}
@end
