//
//  KGNavigationBarDefine.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import <UIKit/UIKit.h>

extern const NSTimeInterval KGUINavigationControllerHideShowBarDuration;

/// 导航栏间距，用于不同控制器之间的间距
extern const CGFloat KGNavigationBarItemSpace;

/// 使用static inline 创建静态内联函数，方便调用，新方法默认自带前缀 kg_
void kg_swizzled_instanceMethod(Class _Nonnull oldClass, NSString *_Nonnull oldSelector, Class _Nonnull newClass);

BOOL kg_overrideImplementation(Class _Nonnull targetClass, SEL _Nonnull targetSelector, id _Nonnull (^_Nonnull implementationBlock)(Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull originIMP));

/// 设备版本号，只获取到第二级的版本号，例如 10.3.1 只会获取到10.3
CG_INLINE double kg_navigationBarDeviceVersion(void) {
    return [UIDevice currentDevice].systemVersion.doubleValue;
}

CG_INLINE CGFloat kg_navigationBarScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

CG_INLINE CGFloat kg_navigationBarScreenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

/// 导航栏高度
CG_INLINE CGFloat kg_navigationBarNavBarHeight(void) { return 44.0; }

/// 状态栏高度
CG_INLINE CGFloat kg_statusBarHeight(void) {
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    if (height <= 0) {
        height = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    if (height <= 0) {
        height = 20;
    }
    return height;
}

/// 是否 iPhone X 系列屏幕
CG_INLINE BOOL ks_isIphoneXSeries(void) { return kg_statusBarHeight() > 20; }

CG_INLINE CGFloat kg_safeAreaBottomHeight(void) {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return bottom;
}

/// 检测某个 CGRect 如果存在数值为 NaN 或者 inf 的则将其转换为 0，避免布局中出现 crash
CG_INLINE CGRect kg_CGRectToSafe(CGRect rect) {
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);

    if (isnan(x) || isinf(x)) {
        x = 0;
    }
    if (isnan(y) || isinf(y)) {
        y = 0;
    }
    if (isnan(width) || isinf(width)) {
        width = 0;
    }
    if (isnan(height) || isinf(height)) {
        height = 0;
    }

    return CGRectMake(x, y, width, height);
}

/// 状态栏加导航栏高度
CG_INLINE CGFloat kg_statusNavBarHeight(void) {
    return kg_statusBarHeight() + kg_navigationBarNavBarHeight();
}
