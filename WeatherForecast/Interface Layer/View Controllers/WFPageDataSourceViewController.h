//
//  WFPageDataSourceViewController.h
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import UIKit;

@interface WFPageDataSourceViewController : UIViewController

- (void)showViewControllerAtIndex:(NSUInteger)index fromIndex:(NSUInteger)fromIndex completion:(void (^)(BOOL finished))completion;

@end
