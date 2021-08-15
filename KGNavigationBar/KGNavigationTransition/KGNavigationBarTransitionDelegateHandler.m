//
//  KGNavigationBarTransitionDelegateHandler.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/30.
//

#import "KGNavigationBarTransitionDelegateHandler.h"
#import "UINavigationController+KGNavigationBar.h"
#import "UIViewController+KGNavigationBar.h"

@interface KGNavigationControllerDelegateHandler ()
/// 是否是push操作
@property (nonatomic, assign) BOOL isGesturePush;
/// push动画交互器
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *pushTransition;
/// pop动画交互器
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *popTransition;
/// push动画
@property (nonatomic, strong) KGNavigationBarPushAnimatedTransition *pushAnimatedTransition;
/// pop动画
@property (nonatomic, strong) KGNavigationBarPopAnimatedTransition *popAnimatedTransition;
@end

@implementation KGNavigationControllerDelegateHandler
#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (self.navigationController.kg_useCustomTransition || (self.navigationController.kg_openScrollLeftPush && self.pushTransition)) {
        if (operation == UINavigationControllerOperationPush) {
            self.pushAnimatedTransition = [KGNavigationBarPushAnimatedTransition transitionWithTransitionRatio:self.navigationController.kg_transitionRatio];
            self.pushAnimatedTransition.transitionRatio = self.navigationController.kg_transitionRatio;
            self.pushAnimatedTransition.navigationController = self.navigationController;
            return self.pushAnimatedTransition;
        } else if (operation == UINavigationControllerOperationPop) {
            self.popAnimatedTransition = [KGNavigationBarPopAnimatedTransition transitionWithTransitionRatio:self.navigationController.kg_transitionRatio];
            self.popAnimatedTransition.transitionRatio = self.navigationController.kg_transitionRatio;
            self.popAnimatedTransition.navigationController = self.navigationController;
            return self.popAnimatedTransition;
        }
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.navigationController.kg_useCustomTransition || (self.navigationController.kg_openScrollLeftPush && self.pushTransition)) {
        if ([animationController isKindOfClass:[KGNavigationBarPushAnimatedTransition class]]) {
            return self.pushTransition;
        } else if ([animationController isKindOfClass:[KGNavigationBarPopAnimatedTransition class]]) {
            return self.popTransition;
        }
    }
    return nil;
}

#pragma mark - 滑动手势处理
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {

    CGFloat criticalVelocityX = KGNavConfigure().criticalVelocityX;

    UIViewController *visibleVC = self.navigationController.visibleViewController;
    // 进度
    CGFloat progress = [gesture translationInView:gesture.view].x / gesture.view.bounds.size.width;
    CGPoint velocity = [gesture velocityInView:gesture.view];
    // 在手势开始的时候判断是 push 操作还是 pop 操作
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (velocity.x >= criticalVelocityX) {
            self.isGesturePush = NO;
        } else {
            self.isGesturePush = velocity.x < 0 ? YES : NO;
        }
    }

    // push 时 progess < 0 需要做处理
    if (self.isGesturePush) {
        progress = -progress;
    }
    progress = MIN(1.0f, MAX(0.0f, progress));

    // NSLog(@"vx:%.2f state:%d isGesturePush:%d progress:%.2f", velocity.x, gesture.state, self.isGesturePush, progress);

    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.isGesturePush) {
            // push
            if (self.navigationController.kg_openScrollLeftPush) {
                if (visibleVC.kg_pushDelegate && [visibleVC.kg_pushDelegate respondsToSelector:@selector(kg_pushToNextViewController)]) {
                    self.pushTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
                    self.pushTransition.completionCurve = UIViewAnimationCurveEaseOut;
                    [self.pushTransition updateInteractiveTransition:0.0];
                    [visibleVC.kg_pushDelegate kg_pushToNextViewController];
                }
            }
        } else {
            // pop
            if (visibleVC.kg_popDelegate) {
                if ([visibleVC.kg_popDelegate respondsToSelector:@selector(kg_viewControllerPopScrollBegan)]) {
                    [visibleVC.kg_popDelegate kg_viewControllerPopScrollBegan];
                }
            } else {
                self.popTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.isGesturePush) {
            if (self.pushTransition) {
                [self.pushTransition updateInteractiveTransition:progress];
            }
        } else {
            if (visibleVC.kg_popDelegate) {
                if ([visibleVC.kg_popDelegate respondsToSelector:@selector(kg_viewControllerPopScrollUpdate:)]) {
                    [visibleVC.kg_popDelegate kg_viewControllerPopScrollUpdate:progress];
                }
            } else {
                [self.popTransition updateInteractiveTransition:progress];
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.isGesturePush) {
            if (self.pushTransition) {
                if (fabs(velocity.x) >= criticalVelocityX || progress > KGNavConfigure().pushTransitionCriticalValue) {
                    [self.pushTransition finishInteractiveTransition];
                } else {
                    [self.pushTransition cancelInteractiveTransition];
                }
            }
        } else {
            if (visibleVC.kg_popDelegate) {
                if ([visibleVC.kg_popDelegate respondsToSelector:@selector(kg_viewControllerPopScrollEnded)]) {
                    [visibleVC.kg_popDelegate kg_viewControllerPopScrollEnded];
                }
            } else {
                if (fabs(velocity.x) >= criticalVelocityX || progress > KGNavConfigure().popTransitionCriticalValue) {
                    [self.popTransition finishInteractiveTransition];
                } else {
                    [self.popTransition cancelInteractiveTransition];
                }
            }
        }
        self.pushTransition = nil;
        self.popTransition = nil;
        self.isGesturePush = NO;
    }
}
@end

@implementation KGGestureRecognizerDelegateHandler

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIViewController *visibleVC = self.navigationController.visibleViewController;
    if (self.navigationController.kg_openScrollLeftPush) {
        // 开启了左滑push功能
    } else if (visibleVC.kg_popDelegate) {
        // 设置了kg_popDelegate
    } else {
        // 忽略根控制器
        if (self.navigationController.viewControllers.count <= 1) return NO;
    }
    // 忽略禁用手势
    if (visibleVC.kg_interactivePopDisabled) return NO;

    CGPoint transition = [gestureRecognizer translationInView:gestureRecognizer.view];
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    if (transition.x < 0) {
        // 左滑处理
        // 开启了左滑push并设置了代理
        if (self.navigationController.kg_openScrollLeftPush && visibleVC.kg_pushDelegate) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        } else {
            return NO;
        }
    } else {
        // 右滑处理
        // 解决根控制器右滑时出现的卡死情况
        if (visibleVC.kg_popDelegate) {
            // 实现了kg_popDelegate，不作处理
        } else {
            if (self.navigationController.viewControllers.count <= 1) return NO;
        }
        // 全屏滑动时起作用
        if (!visibleVC.kg_fullScreenPopDisabled) {
            // 上下滑动
            if (transition.x == 0) return NO;
        }
        // 忽略超出手势区域
        CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat maxAllowDistance = visibleVC.kg_maxPopDistance;
        if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance) {
            return NO;
        } else if (visibleVC.kg_popDelegate) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        } else if (!self.navigationController.kg_useCustomTransition) {
            // 非缩放，系统处理
            [gestureRecognizer removeTarget:self.customTarget action:@selector(panGestureAction:)];
            [gestureRecognizer addTarget:self.systemTarget action:action];
        } else {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        }
    }
    // 忽略导航控制器正在做转场动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;
    return YES;
}

@end
