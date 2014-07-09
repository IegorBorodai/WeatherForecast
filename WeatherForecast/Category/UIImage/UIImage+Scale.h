//
//  MUIImage.h
//  MUIControls
//
//  Created by Kozharin on 18.11.11.
//  Copyright (c) 2011 iCupid. All rights reserved.
//

@import UIKit;

@interface UIImage(Scale)
- (UIImage*)generateImageWithSize:(CGSize)newSize andVerticalTile:(CGFloat)tileWidth;
- (UIImage*)generateImageWithSize:(CGSize)newSize tilePos:(CGFloat)pos tileWidth:(CGFloat)width;
- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)discardOrientation;
- (UIImage*)tiledImageForSize:(CGSize)newSize;
-(UIImage*)resizedImageForMaxSize:(CGSize)max;
+(UIImage*)image4InchNamed:(NSString*)name;
@end
