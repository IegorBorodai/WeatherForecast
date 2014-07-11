//
//  WFDayForecastView.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFDayForecastView.h"

@implementation WFDayForecastView

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"WFDayForecastView" owner:self options:nil] objectAtIndex:0]];
    }
    return self;
}

@end
