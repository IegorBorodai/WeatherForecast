//
//  City.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "City.h"
#import "WeatherForecast.h"


@implementation City

@dynamic isCurrentLocation;
@dynamic name;
@dynamic updatedOn;
@dynamic weatherForecast;


- (void)addWeatherForecastObject:(WeatherForecast *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.weatherForecast];
    [tempSet addObject:value];
    self.weatherForecast = tempSet;
}

@end
