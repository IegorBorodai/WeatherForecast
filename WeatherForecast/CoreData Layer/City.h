//
//  City.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import Foundation;
@import CoreData;

@class WeatherForecast;

@interface City : NSManagedObject

@property (nonatomic, retain) NSNumber * isCurrentLocation;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedOn;
@property (nonatomic, retain) NSOrderedSet *weatherForecast;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)insertObject:(WeatherForecast *)value inWeatherForecastAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWeatherForecastAtIndex:(NSUInteger)idx;
- (void)insertWeatherForecast:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWeatherForecastAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWeatherForecastAtIndex:(NSUInteger)idx withObject:(WeatherForecast *)value;
- (void)replaceWeatherForecastAtIndexes:(NSIndexSet *)indexes withWeatherForecast:(NSArray *)values;
- (void)addWeatherForecastObject:(WeatherForecast *)value;
- (void)removeWeatherForecastObject:(WeatherForecast *)value;
- (void)addWeatherForecast:(NSOrderedSet *)values;
- (void)removeWeatherForecast:(NSOrderedSet *)values;
@end
