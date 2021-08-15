//
//  KGNavigationBarConfigure.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGNavigationBarDefine.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGNavigationBarConfigure : NSObject
/// 导航栏背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 导航栏标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 导航栏标题字体
@property (nonatomic, strong) UIFont *titleFont;
/// 返回按钮样式
@property (nonatomic, strong) UIImage *backButtonImage;
/// 是否禁止导航栏左右item间距调整，默认是 NO
@property (nonatomic, assign) BOOL disableFixSpace;
/// 导航栏左侧按钮距屏幕左边间距，默认是12，可自行调整
@property (nonatomic, assign) CGFloat navItemLeftSpace;
/// 导航栏右侧按钮距屏幕右边间距，默认是12，可自行调整
@property (nonatomic, assign) CGFloat navItemRightSpace;
/// 左滑 push 过渡临界值，默认0.3，大于此值完成push操作
@property (nonatomic, assign) CGFloat pushTransitionCriticalValue;
/// 右滑 pop 过渡临界值，默认0.5，大于此值完成pop操作
@property (nonatomic, assign) CGFloat popTransitionCriticalValue;
/// 如果用户快速滑动界面，触发 pop 的速度临界值，默认 1000.0
@property (nonatomic, assign) CGFloat criticalVelocityX;
/// 转场缩放开启时，盖在上一个页面蒙层的颜色，每个导航控制器实例可单独设置
@property (nonatomic, strong) UIColor *transitionShadowColor;
/// 转场缩放开启时，是否需要盖蒙层，每个导航控制器实例可单独设置
@property (nonatomic, assign) BOOL transitionShadowEnable;
/// 当前 item 修复间距
@property (nonatomic, assign, readonly) CGFloat navItemfixedSpace;
/// 在有 UITabBar 的页面禁用转场缩放，默认 NO
@property (nonatomic, assign) BOOL disableScaleWhenHasTabBar;
/// 单例，设置一次全局使用
+ (instancetype)sharedInstance;
/// 设置默认配置
- (void)setupDefaultConfigure;
/// 设置自定义配置，此方法只需调用一次
/// @param block 配置回调
- (void)setupCustomConfigure:(void (^)(KGNavigationBarConfigure *configure))block;
/// 更新配置
/// @param block 配置回调
- (void)updateConfigure:(void (^)(KGNavigationBarConfigure *configure))block;
@end

// 配置类
KGNavigationBarConfigure *KGNavConfigure(void);

NS_ASSUME_NONNULL_END
