//
//  ExampleItem.h
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExampleItem : NSObject
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 导航栏转场是否使用自定义转场，默认 YES
/// 使用自定义转场才能进行转场缩放和添加阴影
@property (nonatomic, assign) BOOL useCustomTransition;
/// 缩放系数
@property (nonatomic, assign) CGFloat transitionRatio;
/// 转场时非第一个页面是否隐藏 TabBar
@property (nonatomic, assign) BOOL hideTabBarIfNoFirstVc;
/// 转场缩放开启时，盖在上一个页面蒙层的颜色
@property (nonatomic, strong) UIColor *transitionShadowColor;
/// 转场缩放开启时，是否需要盖蒙层
@property (nonatomic, assign) BOOL transitionShadowEnable;
/// 嵌套
@property (nonatomic, strong) ExampleItem *nestedItem;
/// UITabBar 高度，默认 0，不设置
@property (nonatomic, assign) CGFloat tabBarHeight;
/// UITabBar 是否背景透明
@property (nonatomic, assign) BOOL isTabBarBgTransparent;
/// 是否开启左滑 push 操作，默认是 NO，此时不可禁用控制器的滑动返回手势
@property (nonatomic, assign) BOOL openScrollLeftPush;

+ (instancetype)itemWithDesc:(NSString *)desc transitionRatio:(CGFloat)transitionRatio hideTabBarIfNoFirstVc:(BOOL)hideTabBarIfNoFirstVc;
@end

NS_ASSUME_NONNULL_END
