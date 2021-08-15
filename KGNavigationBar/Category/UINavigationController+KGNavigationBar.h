//
//  UINavigationController+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 提供便利方法初始化导航控制器，可控制是否需要缩放效果
/// 在有 UITabBar 的页面，转场时隐藏真实 UITabBar，对其截图加到目标页面
/// 注意：如果 UITabBar 背景是透明的，请主动设置 UITabBar().kg_isBgTransparent 为 true
/// 建议设置 UITabBar translucent 属性为 NO
/// 如果不需要转场时阴影蒙层和缩放效果，可设置 kg_useCustomTransition 为 false
@interface UINavigationController (KGNavigationBar)

/// 创建导航控制器并开启手势控制（无缩放）
/// @param rootVC 根控制器
+ (instancetype)rootVC:(UIViewController *)rootVC;

/// 创建导航控制器并开启手势控制
/// @param rootVC 根控制器
/// @param transitionRatio 缩放系数，默认 1.0，即不缩放
+ (instancetype)rootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio;

/// 创建导航控制器并开启手势控制
/// @param rootVC 根控制器
/// @param openScrollLeftPush 是否开启左滑push操作
+ (instancetype)rootVC:(UIViewController *)rootVC openScrollLeftPush:(BOOL)openScrollLeftPush;

/// 创建导航控制器并开启手势控制
/// @param rootVC 根控制器
/// @param transitionRatio 缩放系数，默认 1.0，即不缩放
/// @param openScrollLeftPush 是否开启左滑push操作
+ (instancetype)rootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio openScrollLeftPush:(BOOL)openScrollLeftPush;

///  创建导航控制器并开启手势控制
/// @param rootVC 根控制器
/// @param transitionRatio 缩放系数，默认 1.0，即不缩放
/// @param openScrollLeftPush 是否开启左滑push操作
- (instancetype)initWithRootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio openScrollLeftPush:(BOOL)openScrollLeftPush;

/// 导航栏转场是否使用自定义转场，默认 YES
/// 使用自定义转场才能进行转场缩放和添加阴影
@property (nonatomic, assign) BOOL kg_useCustomTransition;
/// 是否开启左滑 push 操作，默认是 NO，此时不可禁用控制器的滑动返回手势
@property (nonatomic, assign, readonly) BOOL kg_openScrollLeftPush;
/// 是否开启 KGNavigationBar 的手势处理，默认为 YES
@property (nonatomic, assign) BOOL kg_openGestureHandle;
/// 缩放系数
@property (nonatomic, assign) CGFloat kg_transitionRatio;
/// 滑动手势识别器，用于外部获取
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;
/// 转场缩放开启时，盖在上一个页面蒙层的颜色
@property (nonatomic, strong) UIColor *kg_transitionShadowColor;
/// 转场缩放开启时，是否需要盖蒙层
@property (nonatomic, assign) BOOL kg_transitionShadowEnable;
@end

NS_ASSUME_NONNULL_END
