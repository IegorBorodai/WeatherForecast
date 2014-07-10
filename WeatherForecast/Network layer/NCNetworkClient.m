//
//  Phoenix.m
//  Phoenix
//
//  Created by Boroday on 25.04.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

#import "NCNetworkClient.h"
#import "WeatherForecast.h"
#import "PHGraphObject.h"

static dispatch_once_t networkToken;
static NCNetworkManager *sharedNetworkClient = nil;

@implementation NCNetworkClient

+ (BOOL)checkReachabilityStatusWithError:(NSError* __autoreleasing*)error
{
    return [sharedNetworkClient checkReachabilityStatusWithError:error];
}

#pragma mark - Sigleton methods

+ (NCNetworkManager *)networkClient
{
    dispatch_once(&networkToken, ^{
        sharedNetworkClient = [[NCNetworkManager alloc] initWithBaseURL:nil specialFields:nil];
    });
	
    return sharedNetworkClient;
}

#pragma mark - Lifecycle

+ (void)createNetworkClientWithRootPath:(NSString*)baseURL specialFields:(NSDictionary *)specialFields
{
    dispatch_once(&networkToken, ^{
        sharedNetworkClient = [[NCNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL] specialFields:specialFields];
    });
}


#pragma mark - Requests

+ (NSURLSessionTask *)getCityNamesForQuery:(NSString *)query successBlock:(void (^)(NSArray *cityList))success
                                   failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    NSURLSessionTask *task = [[NCNetworkClient networkClient] enqueueTaskWithMethod:@"GET" path:@"/search.ashx" parameters:@{@"q":query} customHeaders:nil success:^(id responseObject) {
        if (success && responseObject) {
            NSMutableArray *cityList = [@[] mutableCopy];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *data = responseObject[@"data"];
                    if (data[@"error"] && [data[@"error"] isKindOfClass:[NSArray class]]) { // failure
                        NSArray* errors = data[@"error"];
                        NSDictionary* error = [errors firstObject];
                        if (error && [error isKindOfClass:[NSDictionary class]]) {
                            NSString* msg = error[@"msg"];
                            if (msg && [msg isKindOfClass:[NSString class]]) {
                                NSError* error = [NSError errorWithDomain:@"Bad request" code:400 userInfo:@{NSLocalizedDescriptionKey: msg}];
                                failure(error, NO);
                                return;
                            }
                        }
                    }
                }

                if (responseObject[@"search_api"] && [responseObject[@"search_api"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *searchApi = responseObject[@"search_api"];
                    if (searchApi[@"result"] && [searchApi[@"result"] isKindOfClass:[NSArray class]]) {
                        NSArray *result = searchApi[@"result"];
                        for (NSDictionary *obj in result) {
                            if ([obj isKindOfClass:[NSDictionary class]]) {
                                if (obj[@"areaName"] && [obj[@"areaName"] isKindOfClass:[NSArray class]]) {
                                    NSArray *areaName = obj[@"areaName"];
                                    NSDictionary* subObj = [areaName firstObject];
                                    if (subObj && [subObj isKindOfClass:[NSDictionary class]]) {
                                        if (subObj[@"value"] && [subObj[@"value"] isKindOfClass:[NSString class]]) {
                                            [cityList addObject:subObj[@"value"]];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            success(cityList);
        }
    } failure:failure];
    
    return task;
}

+ (NSURLSessionTask*)getWeatherForecastForQuery:(NSString*)query successBlock:(void (^)(NSArray<WFWeatherForecastProtocol> *weatherForecast))success
                                        failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    NSURLSessionTask *task = [[NCNetworkClient networkClient] enqueueTaskWithMethod:@"GET" path:@"/weather.ashx" parameters:@{@"q":query,@"num_of_days":@"5"} customHeaders:nil success:^(id responseObject) {
        if (success && responseObject) {
            NSMutableArray *weatherForecast = [@[] mutableCopy];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *data = responseObject[@"data"];
                    if (data[@"error"] && [data[@"error"] isKindOfClass:[NSArray class]]) { // failure
                        NSArray* errors = data[@"error"];
                        NSDictionary* error = [errors firstObject];
                        if (error && [error isKindOfClass:[NSDictionary class]]) {
                            NSString* msg = error[@"msg"];
                            if (msg && [msg isKindOfClass:[NSString class]]) {
                                NSError* error = [NSError errorWithDomain:@"Bad request" code:400 userInfo:@{NSLocalizedDescriptionKey: msg}];
                                failure(error, NO);
                                return;
                            }
                        }
                    }
                    
                    if (data[@"current_condition"] && [data[@"current_condition"] isKindOfClass:[NSArray class]]) {
                        NSDictionary *currentCondition = [data[@"current_condition"] firstObject];
                        if (currentCondition && [currentCondition isKindOfClass:[NSDictionary class]]) {
                            [weatherForecast addObject:currentCondition];
                        }
                    }
                    
                    if (data[@"weather"] && [data[@"weather"] isKindOfClass:[NSArray class]]) {
                        NSArray *weatherList = data[@"weather"];
                        for (NSDictionary* weather in weatherList) {
                            if (weather && [weather isKindOfClass:[NSDictionary class]]) {
                                [weatherForecast addObject:weather];
                            }
                        }
                    }
                }
            }
            NSError* error = nil;
            NSArray<WFWeatherForecastProtocol> *protocolArray = ((NSArray<WFWeatherForecastProtocol>*)[PHGraphObject graphObjectWrappingArray:weatherForecast withProtocolConversion:@protocol(WFWeatherForecastProtocol) subProtocols:@[@protocol(WFWeatherForecastDescriptionProtocol)] error:&error]);
            if (error) {
                NSLog(@"Protocol mapping error = %@",error.localizedDescription);
            }
            success(protocolArray);
        }
    } failure:failure];
    
    return task;
}

@end

