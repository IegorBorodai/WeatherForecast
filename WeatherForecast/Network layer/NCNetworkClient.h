//
//  Phoenix.h
//  localsgowild
//
//  Created by Artem Rizhov on 28.01.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//


#import "NCNetworkManager.h"
#import "WFWeatherForecastProtocol.h"

@interface NCNetworkClient : NSObject

- (id)init __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (id)new __AVAILABILITY_INTERNAL_UNAVAILABLE;

#pragma mark - Public
+ (void)createNetworkClientWithRootPath:(NSString*)baseURL specialFields:(NSDictionary *)specialFields;

#pragma mark - Sigleton methods
+ (NCNetworkManager *)networkClient;

#pragma mark - Network status
+ (BOOL)checkReachabilityStatusWithError:(NSError* __autoreleasing*)error;

#pragma mark - Requests
+ (NSURLSessionTask*)getCityNamesForQuery:(NSString*)query successBlock:(void (^)(NSArray *cityList))success
                                  failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (NSURLSessionTask*)getWeatherForecastForQuery:(NSString*)query successBlock:(void (^)(NSArray<WFWeatherForecastProtocol> *weatherForecast))success
                                  failure:(void (^)(NSError *error, BOOL isCanceled))failure;


@end
