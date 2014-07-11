//
//  WFCitySearchKIFTests.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/10/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import CoreLocation;
#import "WFUIWorkAroundKIFTests.h"

#define SEARCH_TEXT @"New "
#define CURRENT_LOCATION_IN_LIST 1

@interface WFUIWorkAroundKIFTests ()

@property (nonatomic) NSInteger offsetBecauseOfCurrentLocation;

@end

@implementation WFUIWorkAroundKIFTests

- (void)testWorkAround
{
    self.offsetBecauseOfCurrentLocation = 0;
    if([[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"City Weather Image"] != nil) {
        [tester swipeViewWithAccessibilityLabel:@"City Weather Image" inDirection:KIFSwipeDirectionRight];
        [self removeElementsFromList];
    }
    
    [tester enterText:SEARCH_TEXT intoViewWithAccessibilityLabel:@"Search Field"];
    UITextField *tf = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"Search Field"];
    XCTAssertTrue([tf.text isEqualToString:SEARCH_TEXT], @"Wrong text or no search textfield");
    
    [tester tapViewWithAccessibilityLabel:@"Section 0 Row 0"];

    [tester tapViewWithAccessibilityLabel:@"City List Button"];
    
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"City List"];
    NSInteger originalCityCount = [tableView numberOfRowsInSection:0];
    XCTAssertTrue(originalCityCount > self.offsetBecauseOfCurrentLocation, @"There should be at least 1 new city item!");
    
    if([[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"Location Mark"] != nil) {
        self.offsetBecauseOfCurrentLocation = CURRENT_LOCATION_IN_LIST;
    }
    
    [tester tapViewWithAccessibilityLabel:[NSString stringWithFormat:@"Section 0 Row %ld", self.offsetBecauseOfCurrentLocation]];
    
    UILabel *dayTemperatureLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Day Temperature Label"];
    XCTAssertTrue(!dayTemperatureLabel.hidden, @"Day temperature must be on screen");
    XCTAssertTrue(dayTemperatureLabel.alpha > 0, @"Day temperature must be visible");
    XCTAssertTrue(dayTemperatureLabel.text.length > 0, @"Day temperature must have a text");
    
    [tester tapViewWithAccessibilityLabel:@"Day Temperature"];
    
    [tester waitForTimeInterval:1.0];
    
    UILabel *humidityTemperatureLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Humidity Value Label"];
    XCTAssertTrue(!humidityTemperatureLabel.hidden, @"Humidity must be on screen");
    XCTAssertTrue(humidityTemperatureLabel.alpha > 0, @"Humidity must be visible");
    XCTAssertTrue(humidityTemperatureLabel.text.length > 0, @"Humidity must have a text");
    
    [tester swipeViewWithAccessibilityLabel:@"City Weather Image" inDirection:KIFSwipeDirectionRight];
    
    [tester swipeViewWithAccessibilityLabel:[NSString stringWithFormat:@"Section 0 Row %ld", self.offsetBecauseOfCurrentLocation] inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    if (CURRENT_LOCATION_IN_LIST == self.offsetBecauseOfCurrentLocation) {
        UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"City List"];
        NSInteger originalCityCount = [tableView numberOfRowsInSection:0];
        XCTAssertTrue(CURRENT_LOCATION_IN_LIST == originalCityCount, @"Only current location must exist");
    } else {
        [tester waitForViewWithAccessibilityLabel:@"Search Field"];
    }
    
    
}


- (void)removeElementsFromList
{
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"City List"];
    NSInteger originalCityCount = [tableView numberOfRowsInSection:0];
    
    if([[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"Location Mark"] != nil) {
        self.offsetBecauseOfCurrentLocation = CURRENT_LOCATION_IN_LIST;
    }
    
    if ((1 == originalCityCount) && (CURRENT_LOCATION_IN_LIST == self.offsetBecauseOfCurrentLocation)) {
        [tester tapViewWithAccessibilityLabel:@"Section 0 Row 0"];
        [tester tapViewWithAccessibilityLabel:@"Add City Button"];
        return;
    }
    [tester swipeViewWithAccessibilityLabel:[NSString stringWithFormat:@"Section 0 Row %ld", self.offsetBecauseOfCurrentLocation] inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    [tester waitForTimeInterval:1.0];
    
    if (originalCityCount > 1) {
        [self removeElementsFromList];
    }
}

@end
