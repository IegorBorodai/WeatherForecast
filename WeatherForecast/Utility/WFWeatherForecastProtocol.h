//
//  WFWeatherForecastProtocol.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "PHGraphObject.h"
#import "WFWeatherForecastDescriptionProtocol.h"

@protocol WFWeatherForecastProtocol <PHGraphObject>

@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * winddir16Point;
@property (nonatomic, retain) NSString * windspeedKmph;
@property (nonatomic, retain) NSString * weatherCode;
@property (nonatomic, retain) NSString * temp_C;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * precipMM;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * tempMaxC;
@property (nonatomic, retain) NSString * tempMinC;
@property (nonatomic, retain) NSArray<WFWeatherForecastDescriptionProtocol> * weatherDesc;

@end
