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

@implementation WFUIWorkAroundKIFTests

- (void)testWorkAround
{
    if([[[UIApplication sharedApplication] keyWindow] accessibilityElementWithLabel:@"City Weather Image"] != nil) {
        [self removeElementsFromList];
    }
    
    [tester enterText:SEARCH_TEXT intoViewWithAccessibilityLabel:@"Search Field"];
    UITextField *tf = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"Search Field"];
    XCTAssertTrue([tf.text isEqualToString:SEARCH_TEXT], @"Wrong text or no search textfield");

    [tester tapViewWithAccessibilityLabel:@"Section 0 Row 0"];

    [tester tapViewWithAccessibilityLabel:@"City List Button"];
    
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"City List"];
    NSInteger originalCityCount = [tableView numberOfRowsInSection:0];
    XCTAssertTrue(originalCityCount > 0, @"There should be at least 1 city item!");
    
    [tester tapViewWithAccessibilityLabel:@"Section 0 Row 0"];
    
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
    
    [tester swipeViewWithAccessibilityLabel:@"Section 0 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
}


- (void)removeElementsFromList
{
    [tester swipeViewWithAccessibilityLabel:@"City Weather Image" inDirection:KIFSwipeDirectionRight];
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"City List"];
    NSInteger originalCityCount = [tableView numberOfRowsInSection:0];
    [tester swipeViewWithAccessibilityLabel:@"Section 0 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    if (originalCityCount > 1) {
        [self removeElementsFromList];
    }
}

@end
