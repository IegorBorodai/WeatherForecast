//
//  WFDayForecastView.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import UIKit;

@interface WFDayForecastView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightTemperatureLabel;

@end
