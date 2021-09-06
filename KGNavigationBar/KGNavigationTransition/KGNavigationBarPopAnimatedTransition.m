//
//  KGNavigationBarPopAnimatedTransition.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarPopAnimatedTransition.h"

@implementation KGNavigationBarPopAnimatedTransition

- (void)animateTransition {
    [self.containerView insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];

    BOOL isFromVCShowTabbar = !self.fromViewController.hidesBottomBarWhenPushed;
    BOOL isToVCShowTabbar = !self.toViewController.hidesBottomBarWhenPushed;
    BOOL addCaptureView = isToVCShowTabbar && !isFromVCShowTabbar;
    BOOL isScale = self.transitionRatio < 1;
    if (KGNavConfigure().disableScaleWhenHasTabBar && addCaptureView) {
        isScale = false;
    }
    UIView *fromView = nil;
    if ([self.transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    } else {
        fromView = self.fromViewController.view;
    }

    UIView *toView = nil;
    if ([self.transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        toView = self.toViewController.view;
    }
    UIImageView *toVcCaptureView = nil;
    if (addCaptureView) {
        // 对 UITabBar 截图
        UITabBar *tabBar = self.toViewController.tabBarController.tabBar;

        CGRect toViewFrame = [self safeFrameWithRect:toView.frame];
        CGFloat captureViewHeight = CGRectGetHeight(tabBar.frame);
        CGFloat captureViewTop = CGRectGetHeight(toViewFrame);
        if (tabBar.kg_isBgTransparent) {
            captureViewTop -= captureViewHeight;
        }
        UIImageView *captureView = [[UIImageView alloc] initWithImage:self.toViewController.kg_tabBarSnapshotImage];
        captureView.frame = CGRectMake(0, captureViewTop, CGRectGetWidth(toViewFrame), captureViewHeight);
        [toView addSubview:captureView];
        toVcCaptureView = captureView;

        // 隐藏真实 UITabBar
        tabBar.hidden = YES;
    }

    if (isScale) {
        toView.transform = CGAffineTransformIdentity;
        float transitionRatio = self.transitionRatio;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(transitionRatio, transitionRatio);
        toView.transform = scaleTransform;
    } else {
        CGRect toViewFrame = [self safeFrameWithRect:toView.frame];
        if (self.fromViewController.kg_isPresentStylePush) {
            toViewFrame.origin.y = -0.3 * CGRectGetHeight(toViewFrame);
        } else {
            toViewFrame.origin.x = -0.3 * CGRectGetWidth(toViewFrame);
        }
        toView.frame = toViewFrame;
    }
    fromView.layer.shadowColor = [UIColor blackColor].CGColor;
    fromView.layer.shadowOpacity = 0.6f;
    fromView.layer.shadowRadius = 8.0f;

    BOOL shouldAddShadow = self.navigationController.kg_transitionShadowEnable;
    UIView *shadowView = nil;
    if (shouldAddShadow) {
        CGRect shadowFrame = [self safeFrameWithRect:toView.bounds];
        UITabBar *tabBar = self.toViewController.tabBarController.tabBar;
        if (isToVCShowTabbar && !tabBar.isTranslucent) {
            shadowFrame.size.height += CGRectGetHeight(tabBar.frame);
        }
        shadowView = [[UIView alloc] initWithFrame:shadowFrame];
        shadowView.backgroundColor = self.navigationController.kg_transitionShadowColor;
        [toView addSubview:shadowView];
    }

    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
        animations:^{
            CGRect fromViewFrame = [self safeFrameWithRect:fromView.frame];
            if (self.fromViewController.kg_isPresentStylePush) {
                fromViewFrame.origin.y = CGRectGetHeight(fromViewFrame);
            } else {
                fromViewFrame.origin.x = CGRectGetWidth(fromViewFrame);
            }
            fromView.frame = fromViewFrame;

            if (shadowView) {
                shadowView.alpha = 0;
            }
            if (isScale) {
                toView.transform = CGAffineTransformIdentity;
            } else {
                CGRect toViewFrame = [self safeFrameWithRect:toView.frame];
                if (self.fromViewController.kg_isPresentStylePush) {
                    toViewFrame.origin.y = 0;
                } else {
                    toViewFrame.origin.x = 0;
                }
                toView.frame = toViewFrame;
            }
        }
        completion:^(BOOL finished) {
            [self completeTransition];
            if (shadowView) {
                [shadowView removeFromSuperview];
            }
            if (toVcCaptureView) {
                [toVcCaptureView removeFromSuperview];
            }
            if (isToVCShowTabbar) {
                self.toViewController.tabBarController.tabBar.hidden = false;
            }
            if (isScale) {
                toView.transform = CGAffineTransformIdentity;
            }
        }];
}
@end
