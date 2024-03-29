//
//  WFRightSideCityLookupViewController.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/8/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import CoreLocation;
#import "WFRightSideCityLookupViewController.h"
#import "NCNetworkClient.h"
#import "CategoriesExtension.h"
#import "WFGlobalDataManager.h"

@interface WFRightSideCityLookupViewController () <CLLocationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField                *searchTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *searchActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton                   *cancelSearchButton;
@property (weak, nonatomic) IBOutlet UITableView                *tableView;

@property (strong, nonatomic)        CLLocationManager          *locationManager;
@property (strong, nonatomic)        NSURLSessionTask           *searchTask;
@property (strong, nonatomic)        NSArray                    *cityList;

@property (nonatomic)                NSUInteger                 processCount;
@property (atomic)                   BOOL                       isLocationProcessing;

@end

@implementation WFRightSideCityLookupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setAccessibilityLabel:@"City List"];
    [self.tableView setIsAccessibilityElement:YES];
    
    [self.searchActivityIndicator stopAnimating];
    
    self.cityList = @[];
    self.processCount = 0;
    
    BOOL hasCurrentLocation = NO;
    for (City *city in [WFGlobalDataManager sharedManager].cityList) {
        if ([city.isCurrentLocation boolValue]) {
            hasCurrentLocation = YES;
        }
    }
    if (!hasCurrentLocation) {
        [self startActivityIndicator];
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0000000000000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //workaround with keyboard and page viewconntroller iOS 6+
        [self.searchTextField becomeFirstResponder];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void)startActivityIndicator
{
    if (0 == self.processCount) {
        [self.searchActivityIndicator startAnimating];
    }
    ++self.processCount;
}

- (void)stopActivityIndicator
{
    --self.processCount;
    if (0 == self.processCount) {
        [self.searchActivityIndicator stopAnimating];
    }
}


- (void)getForecastForCity:(NSString *)city fromCurrentLocation:(BOOL)fromCurrentLocation
{
    ++self.pageIndex;
    
    City *coreDataCity = [City MR_createEntity];
    coreDataCity.name = city;
    
    __weak typeof(self)weakSelf = self;
    if (!fromCurrentLocation) {
        [[WFGlobalDataManager sharedManager].cityList addObject:coreDataCity];
        [self.pageViewController showViewControllerAtIndex:[WFGlobalDataManager sharedManager].cityList.count fromIndex:self.pageIndex animated:YES completion:^(BOOL finished) {
            [weakSelf clearViewControllerData];
        }];
    } else {
        coreDataCity.isCurrentLocation = @(YES);
        [[WFGlobalDataManager sharedManager].cityList insertObject:coreDataCity atIndex:0];
        [self.pageViewController showViewControllerAtIndex:1 fromIndex:self.pageIndex animated:YES completion:^(BOOL finished) {
            [weakSelf clearViewControllerData];
        }];
    }
}

- (void)clearViewControllerData
{
    self.searchTextField.text = @"";
    self.cityList = @[];
    [self.tableView reloadData];
}

#pragma mark - Button Actions

- (IBAction)closeButtonDidRecieveTap:(UIButton *)sender {
    if ([WFGlobalDataManager sharedManager].cityList.count > 0) {
        if (NSNotFound == self.fromPageIndex) {
            self.fromPageIndex = self.pageIndex - 1;
        }
        __weak typeof(self)weakSelf = self;
        [self.pageViewController showViewControllerAtIndex:self.fromPageIndex fromIndex:self.pageIndex animated:YES completion:^(BOOL finished) {
            [weakSelf clearViewControllerData];
        }];
    } else {
        [self clearViewControllerData];
    }
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.searchTask) {
        [self.searchTask cancel];
    }
    [self startActivityIndicator];
    __weak typeof(self)weakSelf = self;
    self.searchTask = [NCNetworkClient getCityNamesForQuery:[textField.text stringByAppendingString:string] successBlock:^(NSArray *cityList) {
        weakSelf.cityList = cityList;
        [weakSelf.tableView reloadData];
        [weakSelf stopActivityIndicator];
    } failure:^(NSError *error, BOOL isCanceled) {
//        if (!isCanceled && error) {  //no need of error processing
//        }
        [weakSelf stopActivityIndicator];
    }];
    return YES;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cityName = self.cityList[indexPath.row];
    NSInteger index = [[WFGlobalDataManager sharedManager].cityList indexOfObjectPassingTest:^BOOL(City *city, NSUInteger idx, BOOL *stop) {
        if ([city.name isEqualToString:cityName]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (NSNotFound == index) {
        [self getForecastForCity:cityName fromCurrentLocation:NO];
    } else {
        __weak typeof(self)weakSelf = self;
        [self.pageViewController showViewControllerAtIndex:(index + LEFT_VC_COUNT_IN_STACK) fromIndex:self.pageIndex animated:YES completion:^(BOOL finished) {
            [weakSelf clearViewControllerData];
        }];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CitySearchTableViewCellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ((self.cityList.count > 0) && (self.cityList.count > (NSUInteger)indexPath.row)) {
        NSString* cityName = self.cityList[indexPath.row];
        if ([cityName isKindOfClass:[NSString class]]) {
            cell.textLabel.text = cityName;
        }
    }
    
#ifdef DEBUG
    [cell setAccessibilityLabel:[NSString stringWithFormat:@"Section %ld Row %ld", (long)indexPath.section, (long)indexPath.row]];
#endif
    
    return cell;
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopActivityIndicator];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!self.isLocationProcessing) {
        self.isLocationProcessing = YES;
        [self.locationManager stopUpdatingLocation];
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        __weak typeof(self)weakSelf = self;
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks firstObject];
            if (placemark) {
                [weakSelf getForecastForCity:placemark.locality fromCurrentLocation:YES];
            }
            [weakSelf stopActivityIndicator];
        }];
    }
}

@end
