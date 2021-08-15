//
//  UIScrollView+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "UIScrollView+KGNavigationBar.h"
#import <objc/runtime.h>

@implementation UIScrollView (KGNavigationBar)

static char kAssociatedObjectKey_gestureHandleDisabled;
- (void)setKg_gestureHandleDisabled:(BOOL)kg_gestureHandleDisabled {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_gestureHandleDisabled, @(kg_gestureHandleDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kg_gestureHandleDisabled {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_gestureHandleDisabled) boolValue];
}

#pragma mark - 解决全屏滑动返回时的手势冲突
// 当UIScrollView在水平方向滑动到第一个时，默认是不能全屏滑动返回的，通过下面的方法可实现其滑动返回。
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.kg_gestureHandleDisabled) return YES;
    if ([self panBack:gestureRecognizer]) return NO;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.kg_gestureHandleDisabled) return NO;
    if ([self panBack:gestureRecognizer]) return YES;
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        // 设置手势滑动的位置距屏幕左边的区域
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
