//
//  Phoenix.h
//  localsgowild
//
//  Created by Artem Rizhov on 28.01.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//


#import "NCNetworkManager.h"

@interface NCNetworkClient : NSObject

- (id)init __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (id)new __AVAILABILITY_INTERNAL_UNAVAILABLE;

// Public
+ (void)createNetworkClientWithRootPath:(NSString*)baseURL;

// Singletons
+ (NCNetworkManager *)networkClient;

// Network status
- (BOOL)checkReachabilityStatusWithError:(NSError* __autoreleasing*)error;

//Requests
+ (NSURLSessionTask*)getGenderInfoWithSuccessBlock:(void (^)(NSDictionary *genderAttributes))success
                                           failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (NSURLSessionTask*)getGrapUserWithSuccessBlock:(void (^)(NSDictionary *genderAttributes))success
                                           failure:(void (^)(NSError *error, BOOL isCanceled))failure;

+ (NSURLSessionTask*)downloadImageFromPath:(NSString*)path
                                   success:(void (^)(UIImage* image))success
                                   failure:(void (^)(NSError *error, BOOL isCanceled))failure
                                  progress:(NSProgress*)progress;

+ (NSURLSessionDownloadTask*)downloadFileFromPath:(NSString*)path
                                       toFilePath:(NSString*)filePath
                                          success:(SuccessFileURLBlock)successBlock
                                          failure:(FailureBlock)failureBlock
                                         progress:(NSProgress* __autoreleasing *)progress;

@end
