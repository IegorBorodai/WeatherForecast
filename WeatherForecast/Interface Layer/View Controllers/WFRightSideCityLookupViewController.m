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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cityList = @[];
    self.processCount = 0;
    
    BOOL hasCurrentLocation = NO;
    for (City *city in [WFGlobalDataManager sharedManager].cityList) {
        if ([city.isCurrentLocation boolValue]) {
            hasCurrentLocation = YES;
        }
    }
    if (!hasCurrentLocation) {
        [self.searchActivityIndicator stopAnimating];
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchTextField becomeFirstResponder];
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.pageViewController showViewControllerAtIndex:[WFGlobalDataManager sharedManager].cityList.count fromIndex:self.pageIndex completion:^(BOOL finished) {
            [weakSelf clearViewControllerData];
        }];
    } else {
        coreDataCity.isCurrentLocation = @(YES);
        [[WFGlobalDataManager sharedManager].cityList insertObject:coreDataCity atIndex:0];
        [self.pageViewController showViewControllerAtIndex:1 fromIndex:self.pageIndex completion:^(BOOL finished) {
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

- (IBAction)closeButtonDidRecieveTap:(id)sender {
    if (NSNotFound == self.fromPageIndex) {
        self.fromPageIndex = self.pageIndex - 1;
    }
    __weak typeof(self)weakSelf = self;
    [self.pageViewController showViewControllerAtIndex:self.fromPageIndex fromIndex:self.pageIndex completion:^(BOOL finished) {
        [weakSelf clearViewControllerData];
    }];
}


#pragma mark - Text Field Delegate

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
        if (!isCanceled && error) {
            [[UIAlertView completionAlertViewWithTitle:error.localizedDescription withMessage:nil] show];
        }
        [weakSelf stopActivityIndicator];
    }];
    return YES;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cityName = self.cityList[indexPath.row];
    [self getForecastForCity:cityName fromCurrentLocation:NO];
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
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ((self.cityList.count > 0) && (self.cityList.count > (NSUInteger)indexPath.row)) {
        NSString* cityName = self.cityList[indexPath.row];
        if ([cityName isKindOfClass:[NSString class]]) {
            cell.textLabel.text = cityName;
        }
    }
    
    return cell;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
#warning remove this
    //    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    //    CLLocation *currentLocation = newLocation;
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
        }];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
