//
//  UIView+Geometry.m
//  CupidDatingHD
//
//  Created by Zinetz Victor on 18.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "UIView+Geometry.h"

CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@implementation UIView (Geometry)

#pragma mark - origin

-(CGPoint)origin {
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)newOrigin {
    CGRect f = self.frame;
    f.origin = newOrigin;
    self.frame = f;
}

-(CGFloat)left {
    return self.frame.origin.x;
}

-(void)setLeft:(CGFloat)left {
    CGRect f = self.frame;
    f.origin.x = left;
    self.frame = f;
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setRight:(CGFloat)right {
    CGRect f = self.frame;
    f.origin.x = right - f.size.width;
    self.frame = f;
}

-(CGFloat)top {
    return self.frame.origin.y;
}

-(void)setTop:(CGFloat)top {
    CGRect f = self.frame;
    f.origin.y = top;
    self.frame = f;
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setBottom:(CGFloat)bottom {
    CGRect f = self.frame;
    f.origin.y = bottom - f.size.height;
    self.frame = f;
}

#pragma mark - size

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)newSize {
    CGRect f = self.frame;
    f.size = newSize;
    self.frame = f;
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height {
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}

-(CGPoint)leftBottom {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}

-(void)setLeftBottom:(CGPoint)leftBottom {
    CGRect f = self.frame;
    f.origin.x = leftBottom.x;
    f.origin.y = leftBottom.y - f.size.height;
    self.frame = f;
}

@end
