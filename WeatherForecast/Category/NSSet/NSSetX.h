//
//  NSSetX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import Foundation;

@interface NSSet (X)

/**
 Convert a set into indexed dictionary.
 
 @return A dictionary with integer keys and all objects in set as values.
 */
- (NSDictionary *)indexedDictionary;

@end
