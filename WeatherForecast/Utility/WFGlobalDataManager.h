//
//  WFGlobalDataManager.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#define LEFT_VC_COUNT_IN_STACK 1

@import Foundation;
#import "City.h"

@interface WFGlobalDataManager : NSObject

@property (strong, atomic)                 NSMutableArray  *cityList;
@property (strong, nonatomic, readonly)    NSDateFormatter *dateToStringFormatter;
@property (strong, nonatomic, readonly)    NSDateFormatter *dateToStringFormatterWithoutTime;
@property (strong, nonatomic, readonly)    NSDateFormatter *stringToDateFormatter;
@property (strong, nonatomic, readonly)    NSCalendar      *calendar;

@property (nonatomic)                      BOOL            fahrenheit;

+ (WFGlobalDataManager *)sharedManager;

@end
