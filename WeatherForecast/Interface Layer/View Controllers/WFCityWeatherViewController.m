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

#define TWO_HOURS 24*60*60
#define ANIMATION_DURATION 0.3

@interface WFCityWeatherViewController ()

@property (weak, nonatomic)   IBOutlet UILabel *cityLabel;
@property (weak, nonatomic)   IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic)   IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic)   IBOutlet UILabel *nightTemperatureLabel;
@property (weak, nonatomic)   IBOutlet UILabel *dateLabel;
@property (weak, nonatomic)   IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic)   IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic)   IBOutlet UILabel *humidityTextLabel;
@property (weak, nonatomic)   IBOutlet UILabel *pressureTextLabel;
@property (weak, nonatomic)   IBOutlet UILabel *precipMMLabel;
@property (weak, nonatomic)   IBOutlet UILabel *windLabel;

@property (weak, nonatomic)   IBOutlet UIButton *addCityButton;
@property (weak, nonatomic)   IBOutlet UIButton *cityListButton;

@property (weak, nonatomic)   IBOutlet UIView *temperatureView;
@property (weak, nonatomic)   IBOutlet UIView *decriptionView;

@property (strong, nonatomic) IBOutletCollection(WFDayForecastView) NSArray *dayForecastView;

@property (strong, nonatomic) City               *city;
@property (strong, nonatomic) NSURLSessionTask   *weatherForecastTask;

@property (nonatomic)         NSUInteger         currentForecast;

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
    [[WFGlobalDataManager sharedManager] addObserver:self forKeyPath:@"fahrenheit" options:NSKeyValueObservingOptionNew context:NULL];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
    weakSelf.city = [WFGlobalDataManager sharedManager].cityList[weakSelf.pageIndex - 1];
    
    weakSelf.dayForecastView = [weakSelf.dayForecastView sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(WFDayForecastView* obj1, WFDayForecastView* obj2) {
        if (obj1.tag > obj2.tag) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    for (WFDayForecastView *view in weakSelf.dayForecastView) {
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(weatherForecastViewGestureRecognizerDidFire:)];
        [view addGestureRecognizer:recognizer];
    }
    if (![weakSelf.city.isComplete boolValue] || ([[NSDate date] compare: [NSDate dateWithTimeInterval:TWO_HOURS sinceDate:weakSelf.city.updatedOn]] == NSOrderedDescending)) {
       weakSelf.weatherForecastTask = [NCNetworkClient getWeatherForecastForQuery:weakSelf.city.name successBlock:^(NSArray<WFWeatherForecastProtocol> *weatherForecast) {
           for (NSDictionary<WFWeatherForecastProtocol> *dict in weatherForecast) {
               WeatherForecast *forecast = (WeatherForecast *)[ACEphemeralObject convertInMemoryObjectToManaged:dict class:[WeatherForecast class]];
               [weakSelf.city addWeatherForecastObject:forecast];
           }
           weakSelf.city.updatedOn = [NSDate date];
           weakSelf.city.isComplete = @YES;
           [WFGlobalDataManager sharedManager].cityList[weakSelf.pageIndex - 1] = weakSelf.city;
           [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:NULL];

               dispatch_async(dispatch_get_main_queue(), ^(void) {
                   [weakSelf displayCityDataWithAlphaAnimation:YES];
               });
       } failure:^(NSError *error, BOOL isCanceled) {
           [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
       }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [weakSelf displayCityDataWithAlphaAnimation:NO];
        });
    }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [self.weatherForecastTask cancel];
    @try {
        [[WFGlobalDataManager sharedManager] removeObserver:self forKeyPath:@"fahrenheit"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - Private methods

- (NSString *)convertTempForStyleFromSetting:(NSString *)temp {
    NSInteger temperature = [temp integerValue];
    if ([WFGlobalDataManager sharedManager].fahrenheit && temperature) {
      temperature = lroundf(temperature*1.8 + 32);
        return [NSString stringWithFormat:@"%d", temperature];
    } else {
        return temp;
    }
}

- (void)changeAlphaOfAllElementsTo:(CGFloat)alpha
{
    self.cityLabel.alpha = alpha;
    self.weatherDescriptionLabel.alpha = alpha;
    self.temperatureView.alpha = self.temperatureView.hidden ? 0.0 : alpha;
    self.decriptionView.alpha = self.decriptionView.hidden ? 0.0 : alpha;
    self.dateLabel.alpha = alpha;
    self.addCityButton.alpha = alpha;
    self.cityListButton.alpha = alpha;
    
    for (WFDayForecastView *view in self.dayForecastView) {
        view.dateLabel.alpha = alpha;
        view.weatherImageView.alpha = alpha;
        view.temperatureLabel.alpha = alpha;
    }
}

- (void)displayCityDataWithAlphaAnimation:(BOOL)animation
{
    self.cityLabel.text = self.city.name;
    WeatherForecast *forecast = self.city.weatherForecast[self.currentForecast];
    
    self.weatherDescriptionLabel.text = forecast.weatherType;
    if (forecast.temp_C) {
        self.temperatureLabel.text = [[self convertTempForStyleFromSetting:forecast.temp_C] stringByAppendingString:@"°"];
        self.nightTemperatureLabel.text = @"";
        
        NSString *dateString = [[WFGlobalDataManager sharedManager].dateToStringFormatter stringFromDate:[NSDate date]];
        
        self.dateLabel.text = dateString;
    } else {
        self.temperatureLabel.text = [[self convertTempForStyleFromSetting:forecast.tempMaxC] stringByAppendingString:@"°"];
        self.nightTemperatureLabel.text = [self convertTempForStyleFromSetting:forecast.tempMinC];
        
        NSDate *resDate = [[WFGlobalDataManager sharedManager].stringToDateFormatter dateFromString:forecast.date];
        NSString *dateString = [[WFGlobalDataManager sharedManager].dateToStringFormatterWithoutTime stringFromDate:resDate];
        self.dateLabel.text = dateString;
    }
    
    self.humidityLabel.text = forecast.humidity;
    self.humidityTextLabel.hidden = !forecast.humidity;
    self.pressureLabel.text = forecast.pressure;
    self.pressureTextLabel.hidden = !forecast.pressure;
    self.precipMMLabel.text = forecast.precipMM;
    self.windLabel.text = [NSString stringWithFormat:@"%@ kmph %@", forecast.windspeedKmph, forecast.winddir16Point];
    
    NSUInteger counter = 0;
    for (WFDayForecastView *view in self.dayForecastView) {
        WeatherForecast *subForecast = self.city.weatherForecast[counter];
        NSString *imageName = self.currentForecast != counter ? subForecast.weatherCode : [subForecast.weatherCode stringByAppendingString:@"_highlighted"];
        view.weatherImageView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (!subForecast.temp_C) {
            NSDate *resDate = [[WFGlobalDataManager sharedManager].stringToDateFormatter dateFromString:subForecast.date];
            
            NSDateComponents *components = [[WFGlobalDataManager sharedManager].calendar components:NSCalendarUnitDay fromDate:resDate];
            NSUInteger day = [components day];
            
            view.dateLabel.text = [NSString stringWithFormat:@"%d",day];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[self convertTempForStyleFromSetting:subForecast.tempMaxC]];
            NSMutableAttributedString * subString = [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:[self convertTempForStyleFromSetting:subForecast.tempMinC]]];
            [subString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0 alpha:0.6] range:NSMakeRange(0, subString.length)];
            [attrStr appendAttributedString:subString];
            
            view.temperatureLabel.attributedText = attrStr;

        } else {
            view.dateLabel.text = @"Now";
            view.temperatureLabel.text = [self convertTempForStyleFromSetting:subForecast.temp_C];
        }
        
        ++counter;
    }
    __weak typeof(self)weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [weakSelf changeAlphaOfAllElementsTo:1.0];
        }];
    } else {
        [self changeAlphaOfAllElementsTo:1.0];
    }
}

#pragma mark - Button Actions

- (IBAction)cityListButtonDidRecieveTap:(id)sender {
    [self.pageViewController showViewControllerAtIndex:0 fromIndex:self.pageIndex animated:YES completion:NULL];
}

- (IBAction)addNewCityButtonDidRecieveTap:(id)sender {
        [self.pageViewController showViewControllerAtIndex:([WFGlobalDataManager sharedManager].cityList.count + 1) fromIndex:self.pageIndex animated:YES completion:NULL];
}

#pragma mark - Gesture recognizer

- (IBAction)temperatureViewGestureRecognizerDidFire:(UITapGestureRecognizer *)sender {
    self.temperatureView.hidden = !self.temperatureView.hidden;
    self.decriptionView.hidden = !self.decriptionView.hidden;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [weakSelf changeAlphaOfAllElementsTo:1.0];
    }];
}

- (void)weatherForecastViewGestureRecognizerDidFire:(UITapGestureRecognizer *)sender {
    NSUInteger index = sender.view.tag;
    
    self.currentForecast = index;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [weakSelf changeAlphaOfAllElementsTo:0.0];
    } completion:^(BOOL finished) {
        [weakSelf displayCityDataWithAlphaAnimation:YES];
    }];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"fahrenheit"]) {
        [self displayCityDataWithAlphaAnimation:NO];
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
