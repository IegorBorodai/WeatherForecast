//
//  WFGlobalDataManager.m
//  WeatherForecast
//
//  Created by Iegor Borodai on 7/9/14.
//  Copyright (c) 2014 Iegor Borodai. All rights reserved.
//

#import "WFGlobalDataManager.h"

@implementation WFGlobalDataManager

+ (WFGlobalDataManager *)sharedManager
{
    static WFGlobalDataManager *globalDataManager = nil;
        static dispatch_once_t onceTokenGlobalDataManager;
        dispatch_once(&onceTokenGlobalDataManager, ^{
            if (!globalDataManager)
            {
                globalDataManager = [WFGlobalDataManager new];
            }
        });
        return globalDataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cityList = [[City MR_findAll] mutableCopy];
    }
    return self;
}

@end
