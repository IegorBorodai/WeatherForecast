//
//  Phoenix.m
//  Phoenix
//
//  Created by Boroday on 25.04.13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

#import "NCNetworkClient.h"
#import "User.h"

static dispatch_once_t networkToken;
static NCNetworkManager *sharedNetworkClient = nil;

@implementation NCNetworkClient

- (BOOL)checkReachabilityStatusWithError:(NSError* __autoreleasing*)error
{
    return [sharedNetworkClient checkReachabilityStatusWithError:error];
}

#pragma mark - Sigleton methods

+ (NCNetworkManager *)networkClient
{
    dispatch_once(&networkToken, ^{
        sharedNetworkClient = [[NCNetworkManager alloc] initWithBaseURL:nil];
    });
	
    return sharedNetworkClient;
}

#pragma mark - Lifecycle

+ (void)createNetworkClientWithRootPath:(NSString*)baseURL
{
    dispatch_once(&networkToken, ^{
        sharedNetworkClient = [[NCNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
}

+ (NSURLSessionTask*)getGenderInfoWithSuccessBlock:(void (^)(NSDictionary *genderAttributes))success
                                             failure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    NSURLSessionTask* task = [[NCNetworkClient networkClient] enqueueTaskWithMethod:@"GET" path:@"/info" parameters:@{@"get":@"gender"} customHeaders:nil success:^(id responseObject) {
        if (success) {
            NSDictionary* genderAttributes = nil;
            if (responseObject[@"gender"]) {
                if ([responseObject[@"gender"] isKindOfClass:[NSDictionary class]]) {
                    genderAttributes = [responseObject[@"gender"] copy];
                } else if (([responseObject[@"gender"] isKindOfClass:[NSArray class]]) &&
                           (((NSArray *)responseObject[@"gender"]).count == 2)) {
                    NSMutableDictionary *genderMut = [NSMutableDictionary new];
                    
                    genderMut[@"female"] = [(NSArray *)responseObject[@"gender"] firstObject];
                    genderMut[@"male"] = [(NSArray *)responseObject[@"gender"] lastObject];
                    genderAttributes = genderMut;
                } else if ([responseObject[@"gender"] isKindOfClass:[NSString class]]) {
                    NSMutableDictionary *genderMut = [NSMutableDictionary new];
                    genderMut[@"male"] = responseObject[@"gender"];
                    genderAttributes = genderMut;
                }
            }
            if (genderAttributes) {
            success(genderAttributes);
            } else {
            }
        }
    } failure:failure];
    return task;
}


+ (NSURLSessionTask*)getGrapUserWithSuccessBlock:(void (^)(NSDictionary *genderAttributes))success
                                         failure:(void (^)(NSError *error, BOOL isCanceled))failure
{

    NSDictionary* graphParameters = @{
                                      @"birthday":@"",
                                      @"age":@"",
                                      @"geo":@{
                                              @"country":@"",
                                              @"city":@"",
                                              },
                                      @"chat_up_line":@"",
                                      @"children":@"",
                                      };
    

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:graphParameters
                                                       options:0
                                                         error:nil];
    
    NSDictionary *parameters = @{@"args":[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]};
    
    NSURLSessionTask *task = [[NCNetworkClient networkClient] enqueueTaskWithMethod:@"GET" path:@"/data/fetch" parameters:parameters customHeaders:nil success:^(id jsonResponse) {
        if (success) {
            User* user = nil;
            user = [[User findAll] lastObject];
            if (!user) {
                user = [[User alloc] initWithJsonDictionary:jsonResponse];
                NSLog(@"%@", user.birthday);
                user.birthday = @"Other date";
                NSLog(@"%@", user.birthday);
            
                [user saveWithCompletionBlock:nil];
            }
            NSLog(@"%@", user.geo.city);
        }
    } failure:failure];
    
    return task;
}


+ (NSURLSessionTask*)downloadImageFromPath:(NSString*)path success:(void (^)(UIImage* image))success
                                   failure:(void (^)(NSError *error, BOOL isCanceled))failure
                                  progress:(NSProgress*)progress
{
    NSURLSessionTask* downloadTask = [[NCNetworkClient networkClient] downloadImageFromPath:path success:success failure:failure];
    return downloadTask;
}

+ (NSURLSessionDownloadTask*)downloadFileFromPath:(NSString*)path
                                       toFilePath:(NSString*)filePath
                                          success:(SuccessFileURLBlock)successBlock
                                          failure:(FailureBlock)failureBlock
                                         progress:(NSProgress* __autoreleasing *)progress
{
    NSURLSessionDownloadTask* downloadTask = [[NCNetworkClient networkClient] downloadFileFromPath:path toFilePath:filePath success:successBlock failure:failureBlock progress:progress];
    return downloadTask;
}


@end

