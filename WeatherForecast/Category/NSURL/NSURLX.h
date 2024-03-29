//
//  NSURLX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import Foundation;

@interface NSURL (X)

/**
 Get a host URL.
 
 @return A new URL which represents host.
 */
- (NSURL *)hostURL;

@end
