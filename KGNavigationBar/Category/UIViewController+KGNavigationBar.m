//
//  UIViewController+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGNavigationBarTransitionDelegateHandler.h"
#import "UIBarButtonItem+KGNavigationBar.h"
#import "UIImage+KGNavigationBar.h"
#import "UIViewController+KGNavigationBar.h"
#import <objc/runtime.h>

NSString *const KGViewControllerPropertyChangedNotification = @"KGViewControllerPropertyChangedNotification";

@interface UIViewController ()
/// 内部记录状态栏样式（根据导航栏样式自动设置的）
@property (nonatomic, assign) UIStatusBarStyle p_kg_statusBarStyle;
@end

@implementation UIViewController (KGNavigationBarCategory)
#pragma mark - 状态栏相关
- (BOOL)prefersStatusBarHidden {
    return self.kg_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self kg_fixedStatusBarStyle:self.kg_statusBarStyle];
}

- (void)kg_autoUpdateStatusBarStyle:(UIStatusBarStyle)style {
    self.p_kg_statusBarStyle = style;

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [UIApplication sharedApplication].statusBarStyle = [self kg_fixedStatusBarStyle:style];
    }
}

- (void)setP_kg_statusBarStyle:(UIStatusBarStyle)p_kg_statusBarStyle {
    objc_setAssociatedObject(self, @selector(p_kg_statusBarStyle), @(p_kg_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIStatusBarStyle)p_kg_statusBarStyle {
    id value = objc_getAssociatedObject(self, _cmd);
    // 默认白色
    return (value != nil) ? [value integerValue] : UIStatusBarStyleLightContent;
}

- (void)setKg_statusBarHidden:(BOOL)kg_statusBarHidden {
    objc_setAssociatedObject(self, @selector(kg_statusBarHidden), @(kg_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [UIApplication sharedApplication].statusBarHidden = kg_statusBarHidden;
    }
}

- (BOOL)kg_statusBarHidden {
    id hidden = objc_getAssociatedObject(self, _cmd);
    return (hidden != nil) ? [hidden boolValue] : false;
}

- (void)setKg_hasManuallySetStatusBarStyle:(BOOL)kg_hasManuallySetStatusBarStyle {
    objc_setAssociatedObject(self, @selector(kg_hasManuallySetStatusBarStyle), @(kg_hasManuallySetStatusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_hasManuallySetStatusBarStyle {
    id hidden = objc_getAssociatedObject(self, _cmd);
    return (hidden != nil) ? [hidden boolValue] : NO;
}

- (void)setKg_statusBarStyle:(UIStatusBarStyle)kg_statusBarStyle {
    objc_setAssociatedObject(self, @selector(kg_statusBarStyle), @(kg_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_hasManuallySetStatusBarStyle = true;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [UIApplication sharedApplication].statusBarStyle = [self kg_fixedStatusBarStyle:kg_statusBarStyle];
    }
}

- (UIStatusBarStyle)kg_statusBarStyle {
    id style = objc_getAssociatedObject(self, _cmd);
    // 手动设置为空，就返回自动设置的
    if (!style) {
        return self.p_kg_statusBarStyle;
    }
    return [style integerValue];
}

- (void)setKg_interactivePopDisabled:(BOOL)kg_interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(kg_interactivePopDisabled), @(kg_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self postPropertyChangeNotification];
}

- (BOOL)kg_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_fullScreenPopDisabled:(BOOL)kg_fullScreenPopDisabled {
    objc_setAssociatedObject(self, @selector(kg_fullScreenPopDisabled), @(kg_fullScreenPopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self postPropertyChangeNotification];
}

- (BOOL)kg_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)kg_isPresentStylePush {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_isPresentStylePush:(BOOL)kg_isPresentStylePush {
    objc_setAssociatedObject(self, @selector(kg_isPresentStylePush), @(kg_isPresentStylePush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setKg_maxPopDistance:(CGFloat)kg_maxPopDistance {
    objc_setAssociatedObject(self, @selector(kg_maxPopDistance), @(kg_maxPopDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self postPropertyChangeNotification];
}

- (CGFloat)kg_maxPopDistance {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setKg_navBarAlpha:(CGFloat)kg_navBarAlpha {
    objc_setAssociatedObject(self, @selector(kg_navBarAlpha), @(kg_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.kg_navBarBackgroundAlpha = kg_navBarAlpha;
}

- (CGFloat)kg_navBarAlpha {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setKg_backButtonImage:(UIImage *)kg_backButtonImage {
    objc_setAssociatedObject(self, @selector(kg_backButtonImage), kg_backButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.presentingViewController && (self.navigationController.childViewControllers.count <= 1 && !self.shouldAddLeftNavItemOnFirstOfNavChildVCS)) return;
    if (self.kg_backButtonImage != nil && !self.kg_navigationItem.hidesBackButton) {
        if (self.kg_NavBarInit) {
            self.kg_navigationItem.leftBarButtonItem = [UIBarButtonItem kg_itemWithImage:self.kg_backButtonImage target:self action:@selector(kg_backItemClick:)];
        }
    } else {
        self.kg_navigationItem.leftBarButtonItem = nil;
    }
}

- (UIImage *)kg_backButtonImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_pushDelegate:(id<KGViewControllerPushDelegate>)kg_pushDelegate {
    objc_setAssociatedObject(self, @selector(kg_pushDelegate), kg_pushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<KGViewControllerPushDelegate>)kg_pushDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_popDelegate:(id<KGViewControllerPopDelegate>)kg_popDelegate {
    objc_setAssociatedObject(self, @selector(kg_popDelegate), kg_popDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<KGViewControllerPopDelegate>)kg_popDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Private Methods
// 发送属性改变通知
- (void)postPropertyChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KGViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (void)kg_backItemClick:(UIBarButtonItem *)sender {
    if (self.presentingViewController) {
        if (self.presentingViewController.presentedViewController == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // 判断有没有导航控制器
            UINavigationController *navigationController = self.navigationController;
            if (navigationController) {
                // 判断是不是只有一个
                if (navigationController.viewControllers.count <= 1) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        // 判断有没有导航控制器
        UINavigationController *navigationController = self.navigationController;
        if (navigationController) {
            if (navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {  // 到顶
                UITabBarController *tabBarController = navigationController.tabBarController;
                if (tabBarController && tabBarController.navigationController) {
                    if (tabBarController.navigationController.viewControllers.count > 1) {
                        [tabBarController.navigationController popViewControllerAnimated:YES];
                    } else {
                        [tabBarController.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                } else {
                    [tabBarController dismissViewControllerAnimated:YES completion:nil];
                }
            }
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - public methods
- (UIStatusBarStyle)kg_fixedStatusBarStyle:(UIStatusBarStyle)style {
    if (@available(iOS 13.0, *)) {
        if (style == UIStatusBarStyleDefault) {
            style = UIStatusBarStyleDarkContent;
        }
    }
    return style;
}

@end

@implementation UIViewController (KGNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSString *> *oriSels = @[
            @"viewWillAppear:",
            @"viewDidAppear:",
            @"viewWillDisappear:",
            @"viewWillLayoutSubviews",
        ];
        [oriSels enumerateObjectsUsingBlock:^(NSString *_Nonnull oriSel, NSUInteger idx, BOOL *_Nonnull stop) {
            kg_swizzled_instanceMethod(self, oriSel, self);
        }];
    });
}

- (void)kg_nav_viewWillAppear:(BOOL)animated {
    if (self.kg_NavBarInit) {
        // 隐藏系统导航栏
        self.navigationController.navigationBarHidden = true;

        if (self.kg_navItemLeftSpace == KGNavigationBarItemSpace) {
            self.kg_navItemLeftSpace = KGNavConfigure().navItemLeftSpace;
        }
        if (self.kg_navItemRightSpace == KGNavigationBarItemSpace) {
            self.kg_navItemRightSpace = KGNavConfigure().navItemRightSpace;
        }
        if (self.kg_navigationItem.leftBarButtonItems.count <= 0 && !self.kg_navigationItem.leftBarButtonItem && self.kg_backButtonImage == nil) {
            self.kg_backButtonImage = KGNavConfigure().backButtonImage;
        }
        // 重置navItem_space
        [KGNavConfigure() updateConfigure:^(KGNavigationBarConfigure *_Nonnull configure) {
            configure.navItemLeftSpace = self.kg_navItemLeftSpace;
            configure.navItemRightSpace = self.kg_navItemRightSpace;
        }];
        // 状态栏是否隐藏
        self.kg_navigationBar.kg_statusBarHidden = self.kg_statusBarHidden;
    }
    [self kg_nav_viewWillAppear:animated];
}

- (void)kg_nav_viewDidAppear:(BOOL)animated {
    // 每次视图出现是重新设置当前控制器的手势
    [[NSNotificationCenter defaultCenter] postNotificationName:KGViewControllerPropertyChangedNotification object:@{@"viewController": self}];
    [self kg_nav_viewDidAppear:animated];
}

- (void)kg_nav_viewWillDisappear:(BOOL)animated {
    [KGNavConfigure() updateConfigure:^(KGNavigationBarConfigure *_Nonnull configure) {
        configure.navItemLeftSpace = configure.navItemLeftSpace;
        configure.navItemRightSpace = configure.navItemRightSpace;
    }];
    [self kg_nav_viewWillDisappear:animated];
}

- (void)kg_nav_viewWillLayoutSubviews {
    if (self.kg_NavBarInit) {
        [self setupNavBarFrame];
    }

    [self kg_nav_viewWillLayoutSubviews];
}

#pragma mark - 添加自定义导航栏
- (void)setKg_navigationBar:(KGCustomNavigationBar *)kg_navigationBar {
    objc_setAssociatedObject(self, @selector(kg_navigationBar), kg_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupNavBarFrame];
}

- (KGCustomNavigationBar *)kg_navigationBar {
    KGCustomNavigationBar *navigationBar = objc_getAssociatedObject(self, _cmd);
    if (!navigationBar) {
        navigationBar = [[KGCustomNavigationBar alloc] init];

        [self.view addSubview:navigationBar];
        self.kg_NavBarInit = YES;
        self.kg_navigationBar = navigationBar;

        // 设置默认 UI
        [self setKg_navBackgroundColor:self.kg_navBackgroundColor];
        [self setKg_navTitleFont:self.kg_navTitleFont];
        [self setKg_navTitleColor:self.kg_navTitleColor];

        // 设置默认导航栏间距
        self.kg_navItemLeftSpace = KGNavigationBarItemSpace;
        self.kg_navItemRightSpace = KGNavigationBarItemSpace;
    }
    return navigationBar;
}

- (void)setKg_navigationItem:(UINavigationItem *)kg_navigationItem {
    objc_setAssociatedObject(self, @selector(kg_navigationItem), kg_navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.items = @[kg_navigationItem];
}

- (UINavigationItem *)kg_navigationItem {
    UINavigationItem *navigationItem = objc_getAssociatedObject(self, _cmd);
    if (!navigationItem) {
        navigationItem = [[UINavigationItem alloc] init];
        self.kg_navigationItem = navigationItem;
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_NavBarInit:(BOOL)kg_NavBarInit {
    objc_setAssociatedObject(self, @selector(kg_NavBarInit), @(kg_NavBarInit), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_NavBarInit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)navigationBarHeight {
    return kg_statusNavBarHeight() + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

#pragma mark - 常用属性快速设置
- (void)setKg_navBackgroundColor:(UIColor *)kg_navBackgroundColor {
    objc_setAssociatedObject(self, @selector(kg_navBackgroundColor), kg_navBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.kg_navigationBar setBackgroundImage:[UIImage kg_imagePiexOneWithColor:kg_navBackgroundColor] forBarMetrics:UIBarMetricsDefault];
}

- (UIColor *)kg_navBackgroundColor {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : KGNavConfigure().backgroundColor;
}

- (void)setKg_navBackgroundImage:(UIImage *)kg_navBackgroundImage {
    objc_setAssociatedObject(self, @selector(kg_navBackgroundImage), kg_navBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.kg_navigationBar setBackgroundImage:kg_navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)kg_navBackgroundImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navShadowColor:(UIColor *)kg_navShadowColor {
    objc_setAssociatedObject(self, @selector(kg_navShadowColor), kg_navShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.shadowImage = [UIImage kg_changeImage:[UIImage kg_imagePiexOneWithColor:UIColor.whiteColor] color:kg_navShadowColor];
}

- (UIColor *)kg_navShadowColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navShadowImage:(UIImage *)kg_navShadowImage {
    objc_setAssociatedObject(self, @selector(kg_navShadowImage), kg_navShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.shadowImage = kg_navShadowImage;
}

- (UIImage *)kg_navShadowImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navLineHidden:(BOOL)kg_navLineHidden {
    objc_setAssociatedObject(self, @selector(kg_navLineHidden), @(kg_navLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.kg_navLineHidden = kg_navLineHidden;
    if (kg_navigationBarDeviceVersion() >= 11.0f) {
        self.kg_navShadowImage = kg_navLineHidden ? [UIImage new] : self.kg_navShadowImage;
    }
    [self.kg_navigationBar layoutSubviews];
}

- (BOOL)kg_navLineHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_navTitleView:(UIView *)kg_navTitleView {
    objc_setAssociatedObject(self, @selector(kg_navTitleView), kg_navTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationItem.titleView = kg_navTitleView;
}

- (UIView *)kg_navTitleView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navTitleColor:(UIColor *)kg_navTitleColor {
    objc_setAssociatedObject(self, @selector(kg_navTitleColor), kg_navTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kg_navTitleColor, NSFontAttributeName: self.kg_navTitleFont};
}

- (UIColor *)kg_navTitleColor {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : KGNavConfigure().titleColor;
}

- (void)setKg_navTitleFont:(UIFont *)kg_navTitleFont {
    objc_setAssociatedObject(self, @selector(kg_navTitleFont), kg_navTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.kg_navTitleColor, NSFontAttributeName: kg_navTitleFont};
}

- (UIFont *)kg_navTitleFont {
    id objc = objc_getAssociatedObject(self, _cmd);
    return (objc != nil) ? objc : KGNavConfigure().titleFont;
}

- (void)setKg_navLeftBarButtonItem:(UIBarButtonItem *)kg_navLeftBarButtonItem {
    objc_setAssociatedObject(self, @selector(kg_navLeftBarButtonItem), kg_navLeftBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationItem.leftBarButtonItem = kg_navLeftBarButtonItem;
}

- (UIBarButtonItem *)kg_navLeftBarButtonItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)kg_navLeftBarButtonItems {
    objc_setAssociatedObject(self, @selector(kg_navLeftBarButtonItems), kg_navLeftBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationItem.leftBarButtonItems = kg_navLeftBarButtonItems;
}

- (NSArray<UIBarButtonItem *> *)kg_navLeftBarButtonItems {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navRightBarButtonItem:(UIBarButtonItem *)kg_navRightBarButtonItem {
    objc_setAssociatedObject(self, @selector(kg_navRightBarButtonItem), kg_navRightBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationItem.rightBarButtonItem = kg_navRightBarButtonItem;
}

- (UIBarButtonItem *)kg_navRightBarButtonItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navRightBarButtonItems:(NSArray<UIBarButtonItem *> *)kg_navRightBarButtonItems {
    objc_setAssociatedObject(self, @selector(kg_navRightBarButtonItems), kg_navRightBarButtonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.kg_navigationItem.rightBarButtonItems = kg_navRightBarButtonItems;
}

- (NSArray<UIBarButtonItem *> *)kg_navRightBarButtonItems {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKg_navItemLeftSpace:(CGFloat)kg_navItemLeftSpace {
    objc_setAssociatedObject(self, @selector(kg_navItemLeftSpace), [NSNumber numberWithFloat:kg_navItemLeftSpace], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (kg_navItemLeftSpace == KGNavigationBarItemSpace) return;
    [KGNavConfigure() updateConfigure:^(KGNavigationBarConfigure *_Nonnull configure) {
        configure.navItemLeftSpace = kg_navItemLeftSpace;
    }];
}

- (CGFloat)kg_navItemLeftSpace {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = [NSNumber numberWithFloat:KGNavigationBarItemSpace];
        self.kg_navItemLeftSpace = KGNavigationBarItemSpace;
    }
    return [number floatValue];
}

- (void)setKg_navItemRightSpace:(CGFloat)kg_navItemRightSpace {
    objc_setAssociatedObject(self, @selector(kg_navItemRightSpace), [NSNumber numberWithFloat:kg_navItemRightSpace], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (kg_navItemRightSpace == KGNavigationBarItemSpace) return;
    [KGNavConfigure() updateConfigure:^(KGNavigationBarConfigure *_Nonnull configure) {
        configure.navItemRightSpace = kg_navItemRightSpace;
    }];
}

- (CGFloat)kg_navItemRightSpace {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = [NSNumber numberWithFloat:KGNavigationBarItemSpace];
        self.kg_navItemRightSpace = KGNavigationBarItemSpace;
    }
    return [number floatValue];
}

- (void)setShouldAddLeftNavItemOnFirstOfNavChildVCS:(BOOL)shouldAddLeftNavItemOnFirstOfNavChildVCS {
    objc_setAssociatedObject(self, @selector(shouldAddLeftNavItemOnFirstOfNavChildVCS), @(shouldAddLeftNavItemOnFirstOfNavChildVCS), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldAddLeftNavItemOnFirstOfNavChildVCS {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - Public Methods
- (void)showNavLine {
    self.kg_navLineHidden = NO;
}

- (void)hideNavLine {
    self.kg_navLineHidden = YES;
}

- (void)refreshNavBarFrame {
    [self setupNavBarFrame];
}

- (UIViewController *)kg_visibleViewControllerIfExist {
    if (self.presentedViewController) {
        return [self.presentedViewController kg_visibleViewControllerIfExist];
    }
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).visibleViewController kg_visibleViewControllerIfExist];
    }
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController kg_visibleViewControllerIfExist];
    }
    if (self.isViewLoaded && self.view.window) {
        return self;
    } else {
        NSLog(@"找不到可见的控制器，viewController.self = %@，self.view.window = %@", self, self.view.window);
        return nil;
    }
}

#pragma mark - Private Methods
- (void)setupNavBarFrame {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat navBarH = 0.0f;
    if (width > height) {
        // 横屏
        if (ks_isIphoneXSeries()) {
            navBarH = kg_navigationBarNavBarHeight();
        } else {
            if (width == 736.0f && height == 414.0f) {
                // plus横屏
                navBarH = self.kg_statusBarHidden ? kg_navigationBarNavBarHeight() : kg_statusNavBarHeight();
            } else {
                // 其他机型横屏
                navBarH = self.kg_statusBarHidden ? 32.0f : 52.0f;
            }
        }
    } else {
        // 竖屏
        navBarH = self.kg_statusBarHidden ? (kg_statusBarHeight() + kg_navigationBarNavBarHeight()) : kg_statusNavBarHeight();
    }
    self.kg_navigationBar.frame = CGRectMake(0, 0, width, navBarH);
    self.kg_navigationBar.kg_statusBarHidden = self.kg_statusBarHidden;
    [self.kg_navigationBar setNeedsLayout];
    [self.kg_navigationBar layoutIfNeeded];
}

@end
