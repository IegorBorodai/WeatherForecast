//
//  MUIImage.m
//  MUIControls
//
//  Created by Kozharin on 18.11.11.
//  Copyright (c) 2011 iCupid. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage(Scale)
+(UIImage*)image4InchNamed:(NSString*)name
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
        [UIScreen mainScreen].bounds.size.height>=568) {
        NSString*ext = [name pathExtension];
        NSString*filename = [name stringByDeletingPathExtension];
        filename = [filename stringByAppendingString:@"-568h"];
        if (ext.length>0) {
            filename = [filename stringByAppendingPathExtension:ext];
        }
        UIImage*ret = [UIImage imageNamed:filename];
        if (ret) {
            return ret;
        }
    }
    return [UIImage imageNamed:name];
}

- (UIImage*)tiledImageForSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM (context, 1, -1);
    CGContextDrawTiledImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
-(UIImage*)resizedImageForMaxSize:(CGSize)max
{
    if (self.size.width>max.width || self.size.height>max.height) {
        float w = max.width/self.size.width;
        float h = max.height/self.size.height;
        float mult = MIN(w,h);
        return [self resizedImage:CGSizeMake(self.size.width*mult, self.size.height*mult)
                         transform:CGAffineTransformIdentity
                    drawTransposed:NO
              interpolationQuality:4];
    }
    return self;
}

- (UIImage*)generateImageWithSize:(CGSize)newSize tilePos:(CGFloat)tilePosition tileWidth:(CGFloat)tileWidth
{
    tilePosition = roundf(tilePosition*self.scale);
    tileWidth = roundf(tileWidth*self.scale);
    newSize = CGSizeMake(newSize.width*self.scale, newSize.height*self.scale);
    CGSize oldSize = CGSizeMake(self.size.width*self.scale, self.size.height*self.scale);
    CGRect tRectTile;
    CGRect tRectClip;  
    CGRect tRectImage;
    // generate Image
    UIGraphicsBeginImageContext(newSize);
    UIImage* imageCopy = nil;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != NULL)
    {
        CGContextTranslateCTM(context, 0, newSize.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        // left
        CGContextSaveGState(context);
        tRectClip = CGRectMake(0, 0, tilePosition, oldSize.height);
        tRectImage = CGRectMake(0, 0, oldSize.width, oldSize.height);
        CGContextClipToRect(context, tRectClip);
        CGContextDrawImage(context, tRectImage, self.CGImage);
        CGContextRestoreGState(context);
        // tiled
        CGContextSaveGState(context);
        tRectTile = CGRectMake(CGRectGetMaxX(tRectClip), 0, tileWidth, oldSize.height); 
        CGImageRef imageTileRef = CGImageCreateWithImageInRect(self.CGImage, tRectTile);
        tRectClip = CGRectMake(CGRectGetMaxX(tRectClip), 0, newSize.width - oldSize.width + tileWidth, oldSize.height);
        tRectImage = (CGRect){CGPointZero, tRectTile.size};
        CGContextClipToRect(context, tRectClip);
        CGContextDrawTiledImage(context, tRectImage, imageTileRef);
        CGImageRelease(imageTileRef);
        CGContextRestoreGState(context);
        // right
        CGContextSaveGState(context);
        tRectClip = CGRectMake(CGRectGetMaxX(tRectClip), 0, newSize.width - CGRectGetMaxX(tRectClip), oldSize.height);
        tRectImage = CGRectMake(newSize.width - oldSize.width, 0, oldSize.width, oldSize.height);
        CGContextClipToRect(context, tRectClip);
        CGContextDrawImage(context, tRectImage, self.CGImage);
        CGContextRestoreGState(context);
        //
        CGImageRef cgImage = CGBitmapContextCreateImage(context);
        imageCopy = [[UIImage alloc] initWithCGImage:cgImage scale:self.scale orientation:UIImageOrientationUp];
        CFRelease(cgImage);
    }
    UIGraphicsEndImageContext();

    return imageCopy;
}
- (UIImage *)generateImageWithSize:(CGSize)newSize andVerticalTile:(CGFloat)tileWidth {
    return [self generateImageWithSize:newSize tilePos:(self.size.width - tileWidth)/2 tileWidth:tileWidth];
}
- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality 
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}
- (UIImage *)discardOrientation {
    
    CGImageRef tImage = self.CGImage;
    CGRect tRect=CGRectMake(0,0,CGImageGetWidth(tImage),CGImageGetHeight(tImage));
    CGSize tSize;
    CGAffineTransform tTransform = CGAffineTransformIdentity;
    CGBitmapInfo tBitbapInfo=CGImageGetBitmapInfo(tImage);
//    switch (tBitbapInfo) {
//        case kCGImageAlphaNone:
//        case kCGImageAlphaLast:
//        case kCGImageAlphaPremultipliedLast:
//            tBitbapInfo = kCGImageAlphaNoneSkipLast;
//            break;
//        default:
//            tBitbapInfo=kCGImageAlphaPremultipliedFirst;
//            break;
//    }
    switch (self.imageOrientation) {
        case UIImageOrientationUp:            // default orientation
            tTransform = CGAffineTransformRotate(tTransform, 0);
            tTransform = CGAffineTransformTranslate(tTransform, 0, 0);
            tSize = CGSizeMake(tRect.size.width, tRect.size.height);
            break;
        case UIImageOrientationDown:          // 180 deg rotation
            tTransform = CGAffineTransformRotate(tTransform, M_PI);
            tTransform = CGAffineTransformTranslate(tTransform, -tRect.size.width, -tRect.size.height);
            tSize = CGSizeMake(tRect.size.width, tRect.size.height);
            break;
        case UIImageOrientationLeft:          // 90 deg CCW
            tTransform = CGAffineTransformRotate(tTransform, +M_PI_2);
            tTransform = CGAffineTransformTranslate(tTransform, 0, -tRect.size.height);
            tSize = CGSizeMake(tRect.size.height, tRect.size.width);
            break;
        case UIImageOrientationRight:         // 90 deg CW
            tTransform = CGAffineTransformRotate(tTransform, -M_PI_2);
            tTransform = CGAffineTransformTranslate(tTransform, -tRect.size.width, 0);
            tSize = CGSizeMake(tRect.size.height, tRect.size.width);
            break;
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
            tTransform = CGAffineTransformRotate(tTransform, 0);
            tTransform = CGAffineTransformTranslate(tTransform, 0, 0);
            tTransform = CGAffineTransformScale(tTransform, -1, 1);
            tSize = CGSizeMake(tRect.size.width, tRect.size.height);
            break;
        case UIImageOrientationDownMirrored:  // horizontal flip
            tTransform = CGAffineTransformRotate(tTransform, M_PI);
            tTransform = CGAffineTransformTranslate(tTransform, -tRect.size.width, -tRect.size.height);
            tTransform = CGAffineTransformScale(tTransform, -1, 1);
            tSize = CGSizeMake(tRect.size.width, tRect.size.height);
            break;
        case UIImageOrientationLeftMirrored:  // vertical flip
            tTransform = CGAffineTransformRotate(tTransform, +M_PI_2);
            tTransform = CGAffineTransformTranslate(tTransform, 0, -tRect.size.height);
            tTransform = CGAffineTransformScale(tTransform, -1, 1);
            tSize = CGSizeMake(tRect.size.height, tRect.size.width);
            break;
        case UIImageOrientationRightMirrored: // vertical flip
            tTransform = CGAffineTransformRotate(tTransform, -M_PI_2);
            tTransform = CGAffineTransformScale(tTransform, -1, 1);
            tTransform = CGAffineTransformTranslate(tTransform, -tRect.size.width, 0);
            tSize = CGSizeMake(tRect.size.height, tRect.size.width);
            break;
            
    }
    CGColorSpaceRef tColorCpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef tContext = CGBitmapContextCreate(NULL,
                                                  tSize.width,
                                                  tSize.height,
                                                  8,4*tSize.width,
                                                  tColorCpace,
                                                  tBitbapInfo);
    CGColorSpaceRelease(tColorCpace);
    CGContextConcatCTM(tContext, tTransform);
    CGContextDrawImage(tContext, tRect, tImage);
    
    CGImageRef tNewImage = CGBitmapContextCreateImage(tContext);
    CGContextRelease(tContext);
    UIImage *tReturnImage = [UIImage imageWithCGImage:tNewImage];
    CGImageRelease(tNewImage);
    
    return tReturnImage;
}

@end
