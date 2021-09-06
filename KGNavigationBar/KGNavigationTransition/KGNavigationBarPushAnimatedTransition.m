//
//  KGNavigationBarPushAnimatedTransition.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarPushAnimatedTransition.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation KGNavigationBarPushAnimatedTransition
- (void)animateTransition {

    BOOL isFromVCShowTabbar = !self.fromViewController.hidesBottomBarWhenPushed;
    BOOL isToVCShowTabbar = !self.toViewController.hidesBottomBarWhenPushed;
    BOOL addCaptureView = isFromVCShowTabbar && !isToVCShowTabbar;
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
    UIImageView *fromVcCaptureView = nil;
    if (addCaptureView) {
        // 对 UITabBar 截图
        UITabBar *tabBar = self.fromViewController.tabBarController.tabBar;
        UIImage *captureImage = [UIImage captureImageWithView:tabBar isBgTransparent:tabBar.kg_isBgTransparent];
        CGFloat captureViewHeight = CGRectGetHeight(tabBar.frame);
        CGRect fromViewFrame = [self safeFrameWithRect:fromView.frame];
        CGFloat captureViewTop = CGRectGetHeight(fromViewFrame);
        if (tabBar.kg_isBgTransparent) {
            captureViewTop -= captureViewHeight;
        }
        UIImageView *captureView = [[UIImageView alloc] initWithImage:captureImage];
        self.fromViewController.kg_tabBarSnapshotImage = captureImage;
        captureView.frame = CGRectMake(0, captureViewTop, CGRectGetWidth(fromViewFrame), captureViewHeight);
        [fromView addSubview:captureView];
        fromVcCaptureView = captureView;

        tabBar.hidden = YES;
    }

    UIView *toView = nil;
    if ([self.transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        toView = self.toViewController.view;
    }
    [self.containerView addSubview:toView];
    BOOL shouldAddShadow = self.navigationController.kg_transitionShadowEnable;
    UIView *shadowView = nil;
    if (shouldAddShadow) {
        CGRect shadowFrame = [self safeFrameWithRect:fromView.bounds];
        UITabBar *tabBar = self.fromViewController.tabBarController.tabBar;
        if (isFromVCShowTabbar && !tabBar.isTranslucent) {
            shadowFrame.size.height += CGRectGetHeight(tabBar.frame);
        }
        shadowView = [[UIView alloc] initWithFrame:shadowFrame];
        shadowView.backgroundColor = self.navigationController.kg_transitionShadowColor;
        shadowView.alpha = 0;
        [fromView addSubview:shadowView];
    }
    // 设置toViewController
    CGRect toViewFrame = [self safeFrameWithRect:toView.frame];
    if (self.toViewController.kg_isPresentStylePush) {
        toViewFrame.origin.y = CGRectGetHeight(toViewFrame);
    } else {
        toViewFrame.origin.x = CGRectGetWidth(toViewFrame);
    }
    toView.frame = toViewFrame;
    toView.layer.shadowColor = [UIColor blackColor].CGColor;
    toView.layer.shadowOpacity = 0.6f;
    toView.layer.shadowRadius = 8.0f;

    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
        animations:^{
            if (shadowView) {
                shadowView.alpha = 1;
            }
            if (isScale) {
                float transitionRatio = self.transitionRatio;
                CGAffineTransform transform = CGAffineTransformMakeScale(transitionRatio, transitionRatio);
                fromView.transform = transform;
            } else {
                CGRect fromViewFrame = [self safeFrameWithRect:fromView.frame];
                if (self.toViewController.kg_isPresentStylePush) {
                    fromViewFrame.origin.y = -0.3 * CGRectGetHeight(fromViewFrame);
                } else {
                    fromViewFrame.origin.x = -0.3 * CGRectGetWidth(fromViewFrame);
                }
                fromView.frame = fromViewFrame;
            }
            CGRect toViewFrame = [self safeFrameWithRect:toView.frame];
            toViewFrame = kg_CGRectToSafe(toViewFrame);
            if (CGRectIsEmpty(toViewFrame)) {
                toViewFrame = CGRectMake(0, 0, kg_navigationBarScreenWidth(), kg_navigationBarScreenHeight());
            }
            if (self.toViewController.kg_isPresentStylePush) {
                toViewFrame.origin.y = 0;
            } else {
                toViewFrame.origin.x = 0;
            }
            toView.frame = toViewFrame;
        }
        completion:^(BOOL finished) {
            [self completeTransition];
            if (fromVcCaptureView) {
                [fromVcCaptureView removeFromSuperview];
            }
            if (shadowView) {
                [shadowView removeFromSuperview];
            }
            if (isToVCShowTabbar) {
                self.fromViewController.tabBarController.tabBar.hidden = false;
            }
            if (isScale) {
                fromView.transform = CGAffineTransformIdentity;
            }
        }];
}
@end
