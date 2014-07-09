//
//  WFPageBaseContentViewController.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import UIKit;
#import "WFPageDataSourceViewController.h"

@interface WFPageBaseContentViewController : UIViewController

@property (nonatomic)               NSUInteger                      pageIndex;
@property (nonatomic)               NSUInteger                      fromPageIndex;
@property (nonatomic, weak)         WFPageDataSourceViewController  *pageViewController;

@end
