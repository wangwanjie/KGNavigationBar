//
//  UINavigationController+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarConfigure.h"
#import "KGNavigationBarTransitionDelegateHandler.h"
#import "UINavigationController+KGNavigationBar.h"
#import "UIViewController+KGNavigationBar.h"
#import <objc/runtime.h>

@interface UINavigationController ()
/// 是否开启左滑push操作，默认是NO，此时不可禁用控制器的滑动返回手势
@property (nonatomic, assign) BOOL kg_openScrollLeftPush;
@end

@implementation UINavigationController (KGNavigationBar)
+ (instancetype)rootVC:(UIViewController *)rootVC {
    return [self rootVC:rootVC transitionRatio:1.0];
}

+ (instancetype)rootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio {
    return [[self alloc] initWithRootVC:rootVC transitionRatio:transitionRatio openScrollLeftPush:NO];
}

+ (instancetype)rootVC:(UIViewController *)rootVC openScrollLeftPush:(BOOL)openScrollLeftPush {
    return [[self alloc] initWithRootVC:rootVC transitionRatio:1.0 openScrollLeftPush:openScrollLeftPush];
}

+ (instancetype)rootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio openScrollLeftPush:(BOOL)openScrollLeftPush {
    return [[self alloc] initWithRootVC:rootVC transitionRatio:transitionRatio openScrollLeftPush:openScrollLeftPush];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)initWithRootVC:(UIViewController *)rootVC transitionRatio:(CGFloat)transitionRatio openScrollLeftPush:(BOOL)openScrollLeftPush {
    if (self = [super init]) {
        if (transitionRatio > 1.0) {
            transitionRatio = 1.0;
        }
        if (transitionRatio < 0.1) {
            transitionRatio = 0.1;
        }
        self.kg_openGestureHandle = true;
        self.kg_useCustomTransition = true;
        self.kg_transitionRatio = transitionRatio;
        self.kg_openScrollLeftPush = openScrollLeftPush;
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = [UIColor clearColor];
        self.navigationBarHidden = true;
        [self pushViewController:rootVC animated:YES];
    }
    return self;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kg_swizzled_instanceMethod(self, @"viewDidLoad", self);
        kg_swizzled_instanceMethod(self, @"dealloc", self);

        if (@available(iOS 12.1, *)) {
            kg_overrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }

                    // call original
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}

- (void)kg_nav_viewDidLoad {
    if (self.kg_openGestureHandle) {
        // 处理特殊控制器
        if ([self isKindOfClass:[UIImagePickerController class]]) return;
        if ([self isKindOfClass:[UIVideoEditorController class]]) return;
        // 设置背景色
        self.view.backgroundColor = [UIColor blackColor];
        // 设置代理
        self.delegate = self.navigationHandler;
        // 注册控制器属性改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(propertyChangeNotification:) name:KGViewControllerPropertyChangedNotification object:nil];
    }
    [self kg_nav_viewDidLoad];
}

- (void)kg_nav_dealloc {
    if (self.kg_openGestureHandle) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:KGViewControllerPropertyChangedNotification object:nil];
    }
    [self kg_nav_dealloc];
}

- (void)setKg_transitionRatio:(CGFloat)kg_transitionRatio {
    objc_setAssociatedObject(self, @selector(kg_transitionRatio), [NSNumber numberWithFloat:kg_transitionRatio], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)kg_transitionRatio {
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if (!value) {
        // 默认为 1.0
        value = [NSNumber numberWithFloat:1.0];
        self.kg_transitionRatio = 1.0;
    }
    return [value floatValue];
}

- (void)setKg_useCustomTransition:(BOOL)kg_useCustomTransition {
    objc_setAssociatedObject(self, @selector(kg_useCustomTransition), [NSNumber numberWithBool:kg_useCustomTransition], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_useCustomTransition {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_openScrollLeftPush:(BOOL)kg_openScrollLeftPush {
    objc_setAssociatedObject(self, @selector(kg_openScrollLeftPush), @(kg_openScrollLeftPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_openScrollLeftPush {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_openGestureHandle:(BOOL)kg_openGestureHandle {
    objc_setAssociatedObject(self, @selector(kg_openGestureHandle), @(kg_openGestureHandle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_openGestureHandle {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - Notifiaction
- (void)propertyChangeNotification:(NSNotification *)notification {
    UIViewController *vc = (UIViewController *)notification.object[@"viewController"];
    BOOL isRootVC = (vc == self.viewControllers.firstObject);
    // 手势处理
    if (vc.kg_interactivePopDisabled) {
        // 禁止滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
    } else if (vc.kg_fullScreenPopDisabled) {
        // 禁止全屏滑动，支持边缘滑动
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
        if (self.kg_useCustomTransition) {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.interactivePopGestureRecognizer.enabled = NO;
            if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.screenPanGesture]) {
                [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.screenPanGesture];
                self.screenPanGesture.delegate = self.gestureHandler;
            }
        } else {
            self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
            self.interactivePopGestureRecognizer.delegate = self.gestureHandler;
            self.interactivePopGestureRecognizer.enabled = !isRootVC;
        }
    } else {
        // 支持全屏滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
        // 给 self.interactivePopGestureRecognizer.view 添加全屏滑动手势
        if (!isRootVC && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
            self.panGesture.delegate = self.gestureHandler;
        }
        // 手势处理
        if (self.kg_useCustomTransition || self.kg_openScrollLeftPush) {
            [self.panGesture addTarget:self.navigationHandler action:@selector(panGestureAction:)];
        } else {
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            if ([self.systemTarget respondsToSelector:internalAction]) {
                [self.panGesture addTarget:self.systemTarget action:internalAction];
            } else {
                [self.panGesture addTarget:self.navigationHandler action:@selector(panGestureAction:)];
            }
        }
    }
}

#pragma mark - getter
static char kAssociatedObjectKey_screenPanGesture;
- (UIScreenEdgePanGestureRecognizer *)screenPanGesture {
    UIScreenEdgePanGestureRecognizer *panGesture = objc_getAssociatedObject(self, &kAssociatedObjectKey_screenPanGesture);
    if (!panGesture) {
        panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.navigationHandler action:@selector(panGestureAction:)];
        panGesture.edges = UIRectEdgeLeft;
        objc_setAssociatedObject(self, &kAssociatedObjectKey_screenPanGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

static char kAssociatedObjectKey_panGesture;
- (UIPanGestureRecognizer *)panGesture {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, &kAssociatedObjectKey_panGesture);
    if (!panGesture) {
        panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, &kAssociatedObjectKey_panGesture, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

static char kAssociatedObjectKey_navigationHandler;
- (KGNavigationControllerDelegateHandler *)navigationHandler {
    KGNavigationControllerDelegateHandler *handler = objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationHandler);
    if (!handler) {
        handler = [KGNavigationControllerDelegateHandler new];
        handler.navigationController = self;
        objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationHandler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handler;
}

static char kAssociatedObjectKey_gestureHandler;
- (KGGestureRecognizerDelegateHandler *)gestureHandler {
    KGGestureRecognizerDelegateHandler *handler = objc_getAssociatedObject(self, &kAssociatedObjectKey_gestureHandler);
    if (!handler) {
        handler = [KGGestureRecognizerDelegateHandler new];
        handler.navigationController = self;
        handler.systemTarget = self.systemTarget;
        handler.customTarget = self.navigationHandler;
        objc_setAssociatedObject(self, &kAssociatedObjectKey_gestureHandler, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handler;
}

- (id)systemTarget {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    return internalTarget;
}

- (void)setKg_transitionShadowColor:(UIColor *)kg_transitionShadowColor {
    objc_setAssociatedObject(self, @selector(kg_transitionShadowColor), kg_transitionShadowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)kg_transitionShadowColor {
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = KGNavConfigure().transitionShadowColor;
        self.kg_transitionShadowColor = color;
    }
    return color;
}

- (void)setKg_transitionShadowEnable:(BOOL)kg_transitionShadowEnable {
    objc_setAssociatedObject(self, @selector(kg_transitionShadowEnable), [NSNumber numberWithBool:kg_transitionShadowEnable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_transitionShadowEnable {
    NSNumber *enable = objc_getAssociatedObject(self, _cmd);
    if (!enable) {
        enable = [NSNumber numberWithBool:KGNavConfigure().transitionShadowEnable];
    }
    return [enable boolValue];
}

@end
