//
//  WFGlobalDataManager.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFGlobalDataManager.h"

@interface WFGlobalDataManager ()

@property (strong, nonatomic, readwrite) NSDateFormatter *dateToStringFormatter;
@property (strong, nonatomic, readwrite) NSDateFormatter *stringToDateFormatter;
@property (strong, nonatomic, readwrite) NSCalendar      *calendar;

@end

@implementation WFGlobalDataManager

+ (WFGlobalDataManager *)sharedManager
{
    static WFGlobalDataManager *globalDataManager = nil;
        static dispatch_once_t onceTokenGlobalDataManager;
        dispatch_once(&onceTokenGlobalDataManager, ^{
            if (!globalDataManager)
            {
                globalDataManager = [WFGlobalDataManager new];
            }
        });
        return globalDataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cityList = [[City MR_findAll] mutableCopy];
        
        self.dateToStringFormatter = [NSDateFormatter new];
        [self.dateToStringFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateToStringFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateToStringFormatter setDoesRelativeDateFormatting:NO];
        
        self.stringToDateFormatter = [[NSDateFormatter alloc] init];
        [self.stringToDateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        
        self.calendar = [NSCalendar currentCalendar];
        
        _fahrenheit = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFahrenheit"];
    }
    return self;
}

#pragma mark - Setters

-(void)setFahrenheit:(BOOL)fahrenheit
{
    @synchronized(self) {
        [self willChangeValueForKey:@"fahrenheit"];
        _fahrenheit = fahrenheit;
        [[NSUserDefaults standardUserDefaults] setBool:_fahrenheit forKey:@"isFahrenheit"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self didChangeValueForKey:@"fahrenheit"];
    }
}

@end
