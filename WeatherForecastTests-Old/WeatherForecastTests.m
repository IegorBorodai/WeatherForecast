//
//  WeatherForecastTests.m
//  WeatherForecastTests
//
//  Created by Iegor Borodai on 7/8/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import XCTest;
#import "PHPhoenixBaseTests.h"

#define CITY_CHECK_NAME @"New "

@interface WeatherForecastTests : PHPhoenixBaseTests

@end

@implementation WeatherForecastTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSuccessCitySearch
{
    [NCNetworkClient getCityNamesForQuery:CITY_CHECK_NAME successBlock:^(NSArray *cityList) {
        XCTAssertNotNil(cityList, @"City array is nil");
        XCTAssertTrue(0 == cityList.count, @"No city for request, must be more or equal than 1");
        for (NSString* cityObj in cityList) {
            NSString *errorString = [NSString stringWithFormat:@"City isn't a string, actually %@", NSStringFromClass(cityObj.class)];
        }
        self.blockCompleted = YES;
    } failure:^(NSError *error, BOOL isCanceled) {
        self.blockCompleted = YES;
    }];
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
