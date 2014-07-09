//
//  UIWebViewX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import UIKit;

@interface UIColor (X)

/**
 Convert HTML color notation ("#RRGGBB") to UIColor.

 @return UIColor similar to given HTML color.
 */
+ (UIColor *)colorWithHTMLColor:(NSString *)HTMLColor;

@end
