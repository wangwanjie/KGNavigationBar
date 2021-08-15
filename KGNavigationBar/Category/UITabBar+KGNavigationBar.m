//
//  UITabBar+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2021/7/24.
//

#import "UITabBar+KGNavigationBar.h"
#import <objc/runtime.h>
#import "KGNavigationBarConfigure.h"

@implementation UITabBar (KGNavigationBar)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kg_swizzled_instanceMethod(self, @"layoutSubviews", self);
    });
}

- (void)kg_nav_layoutSubviews {
    if (self.kg_isBgTransparent) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull view, NSUInteger idx, BOOL *_Nonnull stop) {
            @autoreleasepool {
                if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                    view.hidden = YES;
                }
            }
        }];
    }
    [self kg_nav_layoutSubviews];
}

- (void)setKg_isBgTransparent:(BOOL)kg_isBgTransparent {

    objc_setAssociatedObject(self, @selector(kg_isBgTransparent), [NSNumber numberWithBool:kg_isBgTransparent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.translucent = kg_isBgTransparent;

    if (kg_isBgTransparent) {
        if (@available(iOS 13, *)) {
            UITabBarAppearance *standardAppearance = [self.standardAppearance copy];
            [standardAppearance configureWithTransparentBackground];
            self.standardAppearance = standardAppearance;
        }
    }
}

- (BOOL)kg_isBgTransparent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end
