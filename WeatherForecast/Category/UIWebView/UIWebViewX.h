//
//  UIWebViewX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import UIKit;

@interface UIWebView (X)

/**
 Load a piece of HTML into Web View displaying it with a particular font.
 
 @param string A string containing HTML.
 @param baseURL The base URL of the content.
 @param font Font to use for text representation.
 */
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL font:(UIFont *)font;

/**
 Clear all saved web-cookies.
 */
- (void)clearCookies;

@end
