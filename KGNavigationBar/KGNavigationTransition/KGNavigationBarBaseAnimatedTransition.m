//
//  KGNavigationBarBaseAnimatedTransition.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarBaseAnimatedTransition.h"
#import <objc/runtime.h>
#import "KGNavigationBarDefine.h"

@implementation KGNavigationBarBaseAnimatedTransition

+ (instancetype)transitionWithTransitionRatio:(CGFloat)transitionRatio {
    return [[self alloc] initWithTransitionRatio:transitionRatio];
}

- (instancetype)initWithTransitionRatio:(CGFloat)transitionRatio {
    if (self = [super init]) {
        self.transitionRatio = transitionRatio;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 转场动画需要的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return KGUINavigationControllerHideShowBarDuration;
}

// 转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取容器
    UIView *containerView = [transitionContext containerView];
    // 获取转场前后的控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.containerView = containerView;
    self.fromViewController = fromVC;
    self.toViewController = toVC;
    self.transitionContext = transitionContext;
    // 开始动画
    [self animateTransition];
}

// 子类实现
- (void)animateTransition {
}

- (void)completeTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    [self.transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}

- (CGRect)safeFrameWithRect:(CGRect)rect {
    CGRect frame = kg_CGRectToSafe(rect);
    if (CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, kg_navigationBarScreenWidth(), kg_navigationBarScreenHeight());
    }
    return frame;
}
@end

@implementation UIViewController (KGCapture)

- (void)setKg_tabBarSnapshotImage:(UIImageView *)kg_tabBarSnapshotImage {
    objc_setAssociatedObject(self, @selector(kg_tabBarSnapshotImage), kg_tabBarSnapshotImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)kg_tabBarSnapshotImage {
    return objc_getAssociatedObject(self, _cmd);
}
@end
