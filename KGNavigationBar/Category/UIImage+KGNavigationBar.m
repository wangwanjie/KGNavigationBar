//
//  UIImage+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/11/1.
//

#import "UIImage+KGNavigationBar.h"

@implementation UIImage (KGNavigationBar)

+ (UIImage *)kg_imagePiexOneWithColor:(UIColor *)color {
    return [self kg_nav_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)kg_nav_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)kg_changeImage:(UIImage *)image color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)captureImageWithView:(UIView *)view isBgTransparent:(BOOL)isBgTransparent {
    if (isBgTransparent) {
        CGRect rect = view.bounds;
        CGFloat scale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [view.layer renderInContext:context];

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // 把像素 rect 转化为点rect
        CGFloat x = rect.origin.x * scale, y = rect.origin.y * scale, w = rect.size.width * scale, h = rect.size.height * scale;
        CGRect dianRect = CGRectMake(x, y, w, h);
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(newImageRef);
        return newImage;
    }

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:false];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
