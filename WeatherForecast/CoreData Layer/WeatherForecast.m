//
//  WeatherForecast.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WeatherForecast.h"


@implementation WeatherForecast

@dynamic humidity;
@dynamic winddir16Point;
@dynamic windspeedKmph;
@dynamic weatherCode;
@dynamic temp_C;
@dynamic pressure;
@dynamic precipMM;
@dynamic date;
@dynamic tempMaxC;
@dynamic tempMinC;
@dynamic weatherDesc;
@dynamic weatherType;


-(void)setWeatherDesc:(NSArray *)weatherDesc
{
    [super setValue:weatherDesc forKeyPath:@"weatherDesc"];
    NSDictionary* val = [weatherDesc firstObject];
    if (val && [val isKindOfClass:[NSDictionary class]] && val[@"value"]) {
        self.weatherType = [weatherDesc firstObject][@"value"];
    }
}

@end
