//
//  WeatherForecast_Tests.m
//  WeatherForecast Tests
//
//  Created by Iegor Borodai on 7/10/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

@import XCTest;

#import "PHPhoenixBaseTests.h"

#define CITY_VALID_CHECK_NAME @"New "
#define CITY_ERROR_CHECK_NAME @"aa"

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
    [NCNetworkClient getCityNamesForQuery:CITY_VALID_CHECK_NAME successBlock:^(NSArray *cityList) {
        XCTAssertNotNil(cityList, @"City array is nil");
        XCTAssertTrue(cityList.count > 0, @"No city for request, must be more or equal than 1");
        for (NSString* cityObj in cityList) {
            XCTAssertTrue([cityObj isKindOfClass:[NSString class]], @"%@", [NSString stringWithFormat:@"City isn't a string, actually %@", NSStringFromClass(cityObj.class)]);
            XCTAssertTrue(cityObj.length > 0, @"City can't be empty");
        }
        self.blockCompleted = YES;
    } failure:^(NSError *error, BOOL isCanceled) {
        XCTFail("%@",error.localizedDescription);
        self.blockCompleted = YES;
    }];
    [self waitBlockCompletion];

}


- (void)testErrorCitySearch
{
    [NCNetworkClient getCityNamesForQuery:CITY_ERROR_CHECK_NAME successBlock:^(NSArray *cityList) {
        XCTFail(@"Wrong request parameters");
        self.blockCompleted = YES;
    } failure:^(NSError *error, BOOL isCanceled) {
        XCTAssertNotNil(error, @"Error is nil");
        XCTAssertTrue(!isCanceled, @"It's is not a request cancel");
        XCTAssertNotNil(error.localizedDescription, @"LocalizedDescription is nil");
        XCTAssertTrue([error.localizedDescription isKindOfClass:[NSString class]], @"%@", [NSString stringWithFormat:@"LocalizedDescription isn't a string, actually %@", NSStringFromClass(error.localizedDescription.class)]);
        XCTAssertTrue(error.localizedDescription.length > 0, @"LocalizedDescription can't be empty");
        self.blockCompleted = YES;
    }];
    [self waitBlockCompletion];
}

- (void)testCancelCitySearch
{
    NSURLSessionTask* task = [NCNetworkClient getCityNamesForQuery:CITY_VALID_CHECK_NAME successBlock:^(NSArray *cityList) {
        XCTFail(@"Wrong request parameters");
        self.blockCompleted = YES;
    } failure:^(NSError *error, BOOL isCanceled) {
        XCTAssertTrue(isCanceled, @"It's is not a request cancel");
        self.blockCompleted = YES;
    }];
    [task cancel];
    [self waitBlockCompletion];
}

@end
