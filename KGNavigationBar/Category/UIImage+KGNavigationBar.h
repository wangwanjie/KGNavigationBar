//
//  UIImage+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KGNavigationBar)

/// 根据颜色生成size为(1, 1)的纯色图片
/// @param color 图片颜色
+ (UIImage *)kg_imagePiexOneWithColor:(UIColor *)color;

/// 根据颜色生成指定size的纯色图片
/// @param color 图片颜色
/// @param size 图片大小
+ (UIImage *)kg_nav_imageWithColor:(UIColor *)color size:(CGSize)size;

/// 修改指定图片颜色生成新的图片
/// @param image 原图片
/// @param color 图片颜色
+ (UIImage *)kg_changeImage:(UIImage *)image color:(UIColor *)color;

/// 获取某个 view 的截图，支持透明背景
/// @param view 目标 view
/// @param isBgTransparent 背景是否透明
+ (UIImage *)captureImageWithView:(UIView *)view isBgTransparent:(BOOL)isBgTransparent;

@end

NS_ASSUME_NONNULL_END
