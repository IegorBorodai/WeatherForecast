//
//  WFCityWeatherViewController.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/8/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFCityWeatherViewController.h"
#import "WFGlobalDataManager.h"
#import "WFDayForecastView.h"
#import "NCNetworkClient.h"
#import "ACEphemeralObject.h"
#import "WeatherForecast.h"
#import "CategoriesExtension.h"

@interface WFCityWeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutletCollection(WFDayForecastView) NSArray *dayForecastView;

@property (strong, nonatomic)        City                       *city;
@property (strong, nonatomic)        NSURLSessionTask           *weatherForecastTask;

@property (nonatomic)                NSUInteger                 currentForecast;

@end

@implementation WFCityWeatherViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentForecast = 0;
    self.city = [WFGlobalDataManager sharedManager].cityList[self.pageIndex - 1];
    
    self.dayForecastView = [self.dayForecastView sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(WFDayForecastView* obj1, WFDayForecastView* obj2) {
        if (obj1.tag > obj2.tag) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    if (!self.city.weatherForecast || ([[NSDate date] compare: self.city.updatedOn] == NSOrderedDescending)) {
        __weak typeof(self)weakSelf = self;
       self.weatherForecastTask = [NCNetworkClient getWeatherForecastForQuery:self.city.name successBlock:^(NSArray<WFWeatherForecastProtocol> *weatherForecast) {
           for (NSDictionary<WFWeatherForecastProtocol> *dict in weatherForecast) {
               WeatherForecast *forecast = (WeatherForecast *)[ACEphemeralObject convertInMemoryObjectToManaged:dict class:[WeatherForecast class]];
               [weakSelf.city addWeatherForecastObject:forecast];
           }
           weakSelf.city.updatedOn = [NSDate date];
           [WFGlobalDataManager sharedManager].cityList[weakSelf.pageIndex - 1] = weakSelf.city;
           [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:NULL];
           [weakSelf displayCityData];
       } failure:^(NSError *error, BOOL isCanceled) {
           
       }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [self.weatherForecastTask cancel];
}

#pragma mark - Private methods

- (void)displayCityData
{
    self.cityLabel.text = self.city.name;
    WeatherForecast *forecast = self.city.weatherForecast[self.currentForecast];
    
    self.weatherDescriptionLabel.text = forecast.weatherType;
    if (forecast.temp_C) {
        self.temperatureLabel.text = [forecast.temp_C stringByAppendingString:@"°"]; 
        self.nightTemperatureLabel.text = @"";
#warning refactor
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setDoesRelativeDateFormatting:NO];
        
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        self.dateLabel.text = dateString;
    } else {
        self.temperatureLabel.text = [forecast.tempMaxC stringByAppendingString:@"°"];
        self.nightTemperatureLabel.text = forecast.tempMinC;
        
        NSDateFormatter * formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"'yyyy'-'MM'-'dd'"];
        NSDate *resDate = [formater dateFromString:forecast.date];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setDoesRelativeDateFormatting:NO];
        
        NSString *dateString = [dateFormatter stringFromDate:resDate];
        
        self.dateLabel.text = dateString;
    }
    
    NSUInteger counter = 0;
    for (WFDayForecastView *view in self.dayForecastView) {
        WeatherForecast *subForecast = self.city.weatherForecast[counter];
        view.weatherImageView.image = [[UIImage imageNamed:subForecast.weatherCode] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (!subForecast.temp_C) {
            NSDateFormatter * formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy'-'MM'-'dd"];
            NSDate *resDate = [formater dateFromString:subForecast.date];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:resDate];
            NSUInteger day = [components day];
            
            view.dateLabel.text = [NSString stringWithFormat:@"%d",day];
            
            view.dayTemperatureLabel.text = subForecast.tempMaxC;
            view.nightTemperatureLabel.text = subForecast.tempMinC;
        } else {
            view.dateLabel.text = @"Now";
            view.dayTemperatureLabel.text = subForecast.temp_C;
        }
        
        ++counter;
    }
}

#pragma mark - Button Actions

- (IBAction)cityListButtonDidRecieveTap:(id)sender {
    [self.pageViewController showViewControllerAtIndex:0 fromIndex:self.pageIndex completion:NULL];
}

- (IBAction)addNewCityButtonDidRecieveTap:(id)sender {
        [self.pageViewController showViewControllerAtIndex:([WFGlobalDataManager sharedManager].cityList.count + 1) fromIndex:self.pageIndex completion:NULL];
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
