//
//  UITabBar+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2021/7/24.
//

#import "UITabBar+KGNavigationBar.h"
#import <objc/runtime.h>
#import "KGNavigationBarConfigure.h"
#import "UIImage+KGNavigationBar.h"

@implementation UITabBar (KGNavigationBar)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kg_swizzled_instanceMethod(self, @"layoutSubviews", self);
    });
}

- (void)kg_nav_layoutSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull view, NSUInteger idx, BOOL *_Nonnull stop) {
        @autoreleasepool {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                if (self.kg_isBgTransparent) {
                    view.hidden = YES;
                } else {
                    view.hidden = false;
                }
            }
        }
    }];

    [self kg_nav_layoutSubviews];
}

- (void)setKg_isBgTransparent:(BOOL)kg_isBgTransparent {
    [self willChangeValueForKey:@"kg_isBgTransparent"];
    objc_setAssociatedObject(self, @selector(kg_isBgTransparent), [NSNumber numberWithBool:kg_isBgTransparent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.translucent = kg_isBgTransparent;

    if (@available(iOS 13, *)) {
        UITabBarAppearance *standardAppearance = [self.standardAppearance copy];
        if (kg_isBgTransparent) {
            [standardAppearance configureWithTransparentBackground];
        } else {
            [standardAppearance configureWithDefaultBackground];
        }
        self.standardAppearance = standardAppearance;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
        if (@available(iOS 15.0, *)) {
            self.scrollEdgeAppearance = standardAppearance;
        }
#endif
    }

    if (!kg_isBgTransparent) {
        UIColor *bgColor = self.kg_bgColor;
        if (!bgColor) {
            self.kg_bgColor = [UIColor whiteColor];
        }
    }
    [self didChangeValueForKey:@"kg_isBgTransparent"];
}

- (BOOL)kg_isBgTransparent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKg_bgColor:(UIColor *)kg_bgColor {
    [self willChangeValueForKey:@"kg_bgColor"];
    objc_setAssociatedObject(self, @selector(kg_bgColor), kg_bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    UIImage *image = [UIImage kg_imagePiexOneWithColor:kg_bgColor];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [self.standardAppearance copy];
        appearance.backgroundImage = image;
        appearance.backgroundImageContentMode = UIViewContentModeScaleToFill;
        self.standardAppearance = appearance;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
        if (@available(iOS 15.0, *)) {
            self.scrollEdgeAppearance = appearance;
        }
#endif
    } else {
        [self setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }

    [self didChangeValueForKey:@"kg_bgColor"];
}

- (UIColor *)kg_bgColor {
    return objc_getAssociatedObject(self, _cmd);
}
@end
