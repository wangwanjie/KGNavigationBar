//
//  UIViewController+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGCustomNavigationBar.h"
#import "KGNavigationBarConfigure.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const KGViewControllerPropertyChangedNotification;

// 左滑push代理
@protocol KGViewControllerPushDelegate <NSObject>

@optional
- (void)kg_pushToNextViewController;

@end

// 右滑pop代理
@protocol KGViewControllerPopDelegate <NSObject>

@optional
- (void)kg_viewControllerPopScrollBegan;
- (void)kg_viewControllerPopScrollUpdate:(float)progress;
- (void)kg_viewControllerPopScrollEnded;

@end

@interface UIViewController (KGNavigationBarCategory)

/// 是否禁止当前控制器的滑动返回（包括全屏滑动返回和边缘滑动返回）
@property (nonatomic, assign) BOOL kg_interactivePopDisabled;

/// 是否禁止当前控制器的全屏滑动返回
@property (nonatomic, assign) BOOL kg_fullScreenPopDisabled;

/// 全屏滑动时，滑动区域距离屏幕左侧的最大位置，默认是0：表示全屏可滑动
@property (nonatomic, assign) CGFloat kg_maxPopDistance;

/// 设置导航栏透明度
@property (nonatomic, assign) CGFloat kg_navBarAlpha;

/// 设置状态栏是否隐藏，默认NO：不隐藏
@property (nonatomic, assign) BOOL kg_statusBarHidden;

/// 设置状态栏样式类型，需要在 info.plist 中设置
/// UIViewControllerBasedStatusBarAppearance 为 true
@property (nonatomic, assign) UIStatusBarStyle kg_statusBarStyle;

/// 标志位，是否手动设置过状态栏样式
@property (nonatomic, assign) BOOL kg_hasManuallySetStatusBarStyle;

/// 返回按钮图片
@property (nonatomic, strong) UIImage *kg_backButtonImage;

/// 左滑push代理
@property (nonatomic, weak) id<KGViewControllerPushDelegate> kg_pushDelegate;

/// 右滑pop代理，如果设置了kg_popDelegate，原来的滑动返回手势将失效
@property (nonatomic, weak) id<KGViewControllerPopDelegate> kg_popDelegate;

/// 是否 Present 样式入栈、出栈
@property (nonatomic, assign) BOOL kg_isPresentStylePush;

/// 用于根据导航栏样式自动设置状态栏风格
- (void)kg_autoUpdateStatusBarStyle:(UIStatusBarStyle)style;

/// 返回按钮点击方法
/// @param sender sender
- (void)kg_backItemClick:(UIBarButtonItem *)sender;

/// 处理枚举兼容 iOS 13
/// @param style 状态栏样式
- (UIStatusBarStyle)kg_fixedStatusBarStyle:(UIStatusBarStyle)style;

@end

@interface UIViewController (KGNavigationBar)

@property (nonatomic, strong) KGCustomNavigationBar *kg_navigationBar;

@property (nonatomic, strong) UINavigationItem *kg_navigationItem;

/// 是否创建了kg_navigationBar
/// 返回YES表面当前控制器使用了自定义的kg_navigationBar，默认为NO
@property (nonatomic, assign) BOOL kg_NavBarInit;

#pragma mark - 常用属性快速设置
@property (nonatomic, strong) UIColor *kg_navBackgroundColor;
@property (nonatomic, strong) UIImage *kg_navBackgroundImage;

@property (nonatomic, strong) UIColor *kg_navShadowColor;
@property (nonatomic, strong) UIImage *kg_navShadowImage;
@property (nonatomic, assign) BOOL kg_navLineHidden;

@property (nullable, nonatomic, strong) UIView *kg_navTitleView;
@property (nonatomic, strong) UIColor *kg_navTitleColor;
@property (nonatomic, strong) UIFont *kg_navTitleFont;

@property (nullable, nonatomic, strong) UIBarButtonItem *kg_navLeftBarButtonItem;
@property (nullable, nonatomic, strong) NSArray<UIBarButtonItem *> *kg_navLeftBarButtonItems;
@property (nullable, nonatomic, strong) UIBarButtonItem *kg_navRightBarButtonItem;
@property (nullable, nonatomic, strong) NSArray<UIBarButtonItem *> *kg_navRightBarButtonItems;

@property (nonatomic, assign) CGFloat kg_navItemLeftSpace;
@property (nonatomic, assign) CGFloat kg_navItemRightSpace;

/// 如果在导航栏第一个是否仍添加返回按钮，默认为 NO
@property (nonatomic, assign) BOOL shouldAddLeftNavItemOnFirstOfNavChildVCS;

/// 导航栏加状态栏高度
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;

/// 显示导航栏分割线
- (void)showNavLine;

/// 隐藏导航栏分割线
- (void)hideNavLine;

/// 刷新导航栏frame
- (void)refreshNavBarFrame;

/// 获取当前controller里的最高层可见的viewController
- (nullable UIViewController *)kg_visibleViewControllerIfExist;

@end

NS_ASSUME_NONNULL_END
