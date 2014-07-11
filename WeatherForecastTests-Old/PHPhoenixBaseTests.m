//
//  PHPhoenixBaseTests.m
//  Phoenix
//
//  Created by Iegor Borodai on 11/25/13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

#import "PHPhoenixBaseTests.h"
#define SECRET_APP_KEY @"d4fee4b27b1b16bb2a13c3aef452415954b7ed6b"


@implementation PHPhoenixBaseTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.className = [[self class] description];
    
    [self initPHPhoenixWithDelayAndBlockCompletion];
    [self checkInternetConnection];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testInternetConnection
- (void)checkInternetConnection
{
    XCTAssertTrue([NCNetworkClient checkReachabilityStatusWithError:nil], @"Internet connection must be online for other tests");
}

#pragma mark - Methods for async tests

- (void)initPHPhoenixWithDelayAndBlockCompletion
{
    self.blockCompleted = NO;
    [NCNetworkClient createNetworkClientWithRootPath:@"http://api.worldweatheronline.com/free/v1" specialFields:@{@"key":SECRET_APP_KEY, @"format":@"json"}];
    if (![NCNetworkClient checkReachabilityStatusWithError:nil]) {
        [[NCNetworkClient networkClient] addObserver:self forKeyPath:@"reachabilityStatus" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    [self waitBlockCompletion];
}

- (void)waitBlockCompletion
{
    while (!self.blockCompleted)
    {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:0.05];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
    }
    
    self.blockCompleted = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    AFNetworkReachabilityStatus newValue = [change[NSKeyValueChangeNewKey] integerValue];
    
    if (newValue != AFNetworkReachabilityStatusNotReachable)
    {
        self.blockCompleted = YES;
    }
}

@end
