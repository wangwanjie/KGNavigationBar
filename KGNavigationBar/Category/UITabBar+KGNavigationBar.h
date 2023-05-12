//
//  UITabBar+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2021/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (KGNavigationBar)
/// 是否背景透明
@property (nonatomic, assign) BOOL kg_isBgTransparent;
/// 如果不是透明，默认是白色背景，需要设置其他颜色请设置
@property (nonatomic, strong) UIColor *kg_bgColor;
@end

NS_ASSUME_NONNULL_END
