//
//  WFGlobalDataManager.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import Foundation;
#import "City.h"

@interface WFGlobalDataManager : NSObject

@property (strong, atomic)    NSMutableArray  *cityList;
@property (strong, nonatomic) NSDateFormatter *dateToStringFormatter;
@property (strong, nonatomic) NSDateFormatter *stringToDateFormatter;
@property (strong, nonatomic) NSCalendar      *calendar;

+ (WFGlobalDataManager *)sharedManager;

- (NSDateFormatter *)dateToStringFormatter;

@end
