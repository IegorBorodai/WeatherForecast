//
//  PHPhoenixBaseTests.h
//  Phoenix
//
//  Created by Iegor Borodai on 11/25/13.
//  Copyright (c) 2013 massinteractiveserviceslimited. All rights reserved.
//

@import UIKit;
@import XCTest;
#import "NCNetworkClient.h"


@interface PHPhoenixBaseTests : XCTestCase

@property (nonatomic, assign) __block BOOL blockCompleted;

- (void)initPHPhoenixWithDelayAndBlockCompletion;
- (void)waitBlockCompletion;

@end
