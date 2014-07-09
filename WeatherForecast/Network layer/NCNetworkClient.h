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

// Public
+ (void)createNetworkClientWithRootPath:(NSString*)baseURL specialFields:(NSDictionary *)specialFields;

// Singletons
+ (NCNetworkManager *)networkClient;

// Network status
- (BOOL)checkReachabilityStatusWithError:(NSError* __autoreleasing*)error;

//Requests

+ (NSURLSessionTask*)getCityNamesForQuery:(NSString*)query successBlock:(void (^)(NSArray *cityList))success
                                  failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (NSURLSessionTask*)getWeatherForecastForQuery:(NSString*)query successBlock:(void (^)(NSArray<WFWeatherForecastProtocol> *weatherForecast))success
                                  failure:(void (^)(NSError *error, BOOL isCanceled))failure;


@end
