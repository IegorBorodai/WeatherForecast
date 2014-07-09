//
//  WFPageDataSourceViewController.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFPageDataSourceViewController.h"
#import "WFPageBaseContentViewController.h"
#import "WFGlobalDataManager.h"
#import "CategoriesExtension.h"

#define LEFT_VC_WITH_CITY_LIST 0
#define LEFT_VC_IN_STACK 1

@interface WFPageDataSourceViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController            *pageViewController;
@property (strong, nonatomic) WFPageBaseContentViewController *currentViewController;

@end

@implementation WFPageDataSourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFPageViewController"];
    self.pageViewController.dataSource = self;
    
    WFPageBaseContentViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
//    [self observeObject:[WFGlobalDataManager sharedManager] property:@"cityList" withBlock:^(__weak id self, __weak id object, id old, id new) {
//    
//    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
#warning Почините это бля!
    return UIStatusBarStyleLightContent;
}

#pragma mark - Public methods

- (void)showViewControllerAtIndex:(NSUInteger)index fromIndex:(NSUInteger)fromIndex completion:(void (^)(BOOL finished))completion
{
    UIPageViewControllerNavigationDirection direction = fromIndex > index ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    
    WFPageBaseContentViewController *newViewController = [self viewControllerAtIndex:index];
    newViewController.fromPageIndex = fromIndex;
    
    NSArray *viewControllers = @[newViewController];
    
    __weak UIPageViewController* weakPageVC = self.pageViewController;
    [self.pageViewController setViewControllers:viewControllers
                  direction:direction
                   animated:YES completion:^(BOOL finished) {
                       UIPageViewController* strongPageVC = weakPageVC;
                       if (!strongPageVC) return;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [strongPageVC setViewControllers:viewControllers
                                          direction:direction
                                           animated:NO completion:nil];
                       });
                   }];
}

#pragma mark - Private methods

- (WFPageBaseContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
//    if (index > [WFGlobalDataManager sharedManager].cityList.count) {
//        return nil;
//    }
    
    WFPageBaseContentViewController *viewController;
    if (LEFT_VC_WITH_CITY_LIST == index) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFLeftSideCityListViewController"];
    } else if (([WFGlobalDataManager sharedManager].cityList.count + LEFT_VC_IN_STACK) == index) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFRightSideCityLookupViewController"];
    } else {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFCityWeatherViewController"];
    }
    viewController.pageIndex = index;
    viewController.fromPageIndex = NSNotFound;
    viewController.pageViewController = self;
    return viewController;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WFPageBaseContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WFPageBaseContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index > [WFGlobalDataManager sharedManager].cityList.count + LEFT_VC_IN_STACK) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [[WFGlobalDataManager sharedManager].cityList count];
}

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}
@end
