//
//  NSDate+Day.h
//  NSDate+Calendar
//
//  Created by Belkevich Alexey on 3/16/12.
//  Copyright (c) 2012 okolodev. All rights reserved.
//

@import Foundation;

@interface NSDate (Day)

@property (nonatomic, readonly) NSInteger day;

- (NSDate *)dateToday;
- (NSDate *)dateYesterday;
- (NSDate *)dateTomorrow;
- (NSDate *)dateBySettingDay:(NSInteger)day;
- (NSDate *)dateByAddingDays:(NSInteger)days;

@end
