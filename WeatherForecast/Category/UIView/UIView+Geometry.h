//
//  UIView+Geometry.h
//  CupidDatingHD
//
//  Created by Zinetz Victor on 18.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

@import UIKit;

CGPoint CGRectGetCenter(CGRect rect);

@interface UIView (Geometry)

@property CGPoint origin;
@property CGSize size;

@property CGFloat left;
@property CGFloat right;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat width;
@property CGFloat height;

@property CGPoint leftBottom;

@end
