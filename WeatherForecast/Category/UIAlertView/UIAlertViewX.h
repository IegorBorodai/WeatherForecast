//
//  UIAlertViewX.h
//
//  Copyright (c) 2013 Anthony Shoumikhin. All rights reserved under MIT license.
//  mailto:anthony@shoumikh.in
//

@import UIKit;

typedef void (^UIAlertViewCompletionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (X)

/**
 Display an alert and execute a completion block when any button is tapped.

 @param completionBlock A block to execute when alert is dismissed.
 */
- (void)completionShowWithBlock:(UIAlertViewCompletionBlock)completionBlock;

@end
