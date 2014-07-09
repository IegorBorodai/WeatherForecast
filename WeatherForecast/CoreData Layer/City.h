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

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) WeatherForecast *weatherForecast;
@property (nonatomic, retain) NSNumber *isCurrentLocation;
@property (nonatomic, retain) NSDate *updatedOn;

@end
