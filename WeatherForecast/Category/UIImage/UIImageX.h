//
//  UIImageX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import UIKit;

@interface UIImage (X)

/**
 Download an image with URL.
 
 @return A new image with contents of URL.
 */
- (id)initWithContentsOfURL:(NSURL *)URL;
+ (UIImage *)imageWithContentsOfURL:(NSURL *)URL;

@end
