//
//  WFPageDataSourceViewController.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFPageDataSourceViewController.h"
#import "WFCityWeatherViewController.h"

@interface WFPageDataSourceViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray  *cityList;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation WFPageDataSourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityList = @[@"AA", @"BB"];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFPageViewController"];
    self.pageViewController.dataSource = self;
    
    WFCityWeatherViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (WFCityWeatherViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.cityList count] == 0) || (index >= [self.cityList count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WFCityWeatherViewController *cityWeatherContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFCityWeatherViewController"];
    cityWeatherContentViewController.pageIndex = index;
    return cityWeatherContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WFCityWeatherViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WFCityWeatherViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.cityList count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.cityList count];
}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

@end
