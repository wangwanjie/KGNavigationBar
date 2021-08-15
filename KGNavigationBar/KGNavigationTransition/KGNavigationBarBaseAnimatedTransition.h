//
//  KGNavigationBarBaseAnimatedTransition.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarConfigure.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+KGNavigationBar.h"
#import "UITabBar+KGNavigationBar.h"
#import "UIImage+KGNavigationBar.h"
#import "UINavigationController+KGNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGNavigationBarBaseAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
/// 转场上下文
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
/// 转场容器
@property (nonatomic, weak) UIView *containerView;
/// 转场来源控制器
@property (nonatomic, weak) UIViewController *fromViewController;
/// 转场目标控制器
@property (nonatomic, weak) UIViewController *toViewController;
/// 缩放系数，小于 1 则缩放，否则平移
@property (nonatomic, assign) CGFloat transitionRatio;
/// 当前处理的导航控制器
@property (nonatomic, weak) UINavigationController *navigationController;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 默认初始化方法
/// @param transitionRatio 缩放系数
+ (instancetype)transitionWithTransitionRatio:(CGFloat)transitionRatio;

/// 动画
- (void)animateTransition;

/// 动画完成
- (void)completeTransition;

/// 防止获取到的页面尺寸不对，不正确将返回屏幕尺寸
- (CGRect)safeFrameWithRect:(CGRect)rect;

@end

@interface UIViewController (KGCapture)

/// 容纳 UITabBar 截图的控件
@property (nonatomic, strong) UIImage *kg_tabBarSnapshotImage;

@end

NS_ASSUME_NONNULL_END
