//
//  UIColor+Modify.h
//  UIColorCategory
//
//  Created by David Keegan on 9/24/13.
//  Copyright (c) 2013 1kLabs, Inc. All rights reserved.
//

@import UIKit;

@interface UIColor(Modify)

- (UIColor *)invertedColor;
- (UIColor *)colorForTranslucency;

- (UIColor *)lightenColor:(CGFloat)lighten;
- (UIColor *)darkenColor:(CGFloat)darken;

@end
