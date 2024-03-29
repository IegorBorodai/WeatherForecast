//
//  NSExceptionX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import Foundation;

@interface NSException (X)

/**
 Get stack backtrace.
 
 @return Application's backtrace at place where exception was thrown.
 */
- (NSArray *)backtrace;

@end