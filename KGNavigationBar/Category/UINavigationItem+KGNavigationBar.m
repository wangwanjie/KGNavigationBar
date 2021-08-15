//
//  UINavigationItem+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/29.
//

#import "KGNavigationBarConfigure.h"
#import "UINavigationItem+KGNavigationBar.h"

@implementation UINavigationItem (KGNavigationBar)

// iOS 11之前，通过添加空UIBarButtonItem调整间距
+ (void)load {
    if (@available(iOS 11.0, *)) {
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray<NSString *> *oriSels = @[@"setLeftBarButtonItem:",
                                             @"setLeftBarButtonItem:animated:",
                                             @"setLeftBarButtonItems:",
                                             @"setLeftBarButtonItems:animated:",
                                             @"setRightBarButtonItem:",
                                             @"setRightBarButtonItem:animated:",
                                             @"setRightBarButtonItems:",
                                             @"setRightBarButtonItems:animated:"];
            [oriSels enumerateObjectsUsingBlock:^(NSString *_Nonnull oriSel, NSUInteger idx, BOOL *_Nonnull stop) {
                kg_swizzled_instanceMethod(self, oriSel, self);
            }];
        });
    }
}

- (void)kg_nav_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

- (void)kg_nav_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated {
    if (!KGNavConfigure().disableFixSpace && leftBarButtonItem) {
        // 存在按钮且需要调节
        [self setLeftBarButtonItems:@[leftBarButtonItem] animated:animated];
    } else {
        // 不存在按钮,或者不需要调节
        [self setLeftBarButtonItems:nil];
        [self kg_nav_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}

- (void)kg_nav_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

- (void)kg_nav_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated {
    if (!KGNavConfigure().disableFixSpace && leftBarButtonItems.count) {
        // 存在按钮且需要调节
        UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
        CGFloat width = KGNavConfigure().navItemLeftSpace - KGNavConfigure().navItemfixedSpace;
        if (firstItem.width == width) {
            // 已经存在space
            [self kg_nav_setLeftBarButtonItems:leftBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self kg_nav_setLeftBarButtonItems:items animated:animated];
        }
    } else {
        // 不存在按钮,或者不需要调节
        [self kg_nav_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

- (void)kg_nav_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    [self setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (void)kg_nav_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated {
    if (!KGNavConfigure().disableFixSpace && rightBarButtonItem) {
        // 存在按钮且需要调节
        [self setRightBarButtonItems:@[rightBarButtonItem] animated:animated];
    } else {
        // 不存在按钮,或者不需要调节
        [self setRightBarButtonItems:nil];
        [self kg_nav_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }
}

- (void)kg_nav_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    [self setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (void)kg_nav_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems animated:(BOOL)animated {
    if (!KGNavConfigure().disableFixSpace && rightBarButtonItems.count) {
        // 存在按钮且需要调节
        UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
        CGFloat width = KGNavConfigure().navItemRightSpace - KGNavConfigure().navItemfixedSpace;
        if (firstItem.width == width) {
            // 已经存在space
            [self kg_nav_setRightBarButtonItems:rightBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self kg_nav_setRightBarButtonItems:items animated:animated];
        }
    } else {
        // 不存在按钮,或者不需要调节
        [self kg_nav_setRightBarButtonItems:rightBarButtonItems animated:animated];
    }
}

- (UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end

@implementation NSObject (KGNavigationBar)

// iOS11之后，通过修改约束跳转导航栏item的间距
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            NSDictionary *oriSels = @{@"_UINavigationBarContentView": @"layoutSubviews",
                                      @"_UINavigationBarContentViewLayout": @"_updateMarginConstraints"};
            [oriSels enumerateKeysAndObjectsUsingBlock:^(NSString *cls, NSString *oriSel, BOOL *_Nonnull stop) {
                kg_swizzled_instanceMethod(NSClassFromString(cls), oriSel, self);
            }];
        }
    });
}

- (void)kg_nav_layoutSubviews {
    [self kg_nav_layoutSubviews];
    if (KGNavConfigure().disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentView")]) return;
    id layout = [self valueForKey:@"_layout"];
    if (!layout) return;
    SEL selector = NSSelectorFromString(@"_updateMarginConstraints");
    if ([layout respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [layout performSelector:selector];
#pragma clang diagnostic pop
    }
}

- (void)kg_nav__updateMarginConstraints {
    [self kg_nav__updateMarginConstraints];
    if (KGNavConfigure().disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentViewLayout")]) return;
    [self kg_adjustLeadingBarConstraints];
    [self kg_adjustTrailingBarConstraints];
}

- (void)kg_adjustLeadingBarConstraints {
    if (KGNavConfigure().disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *leadingBarConstraints = [self valueForKey:@"_leadingBarConstraints"];
    if (!leadingBarConstraints) return;
    CGFloat constant = KGNavConfigure().navItemLeftSpace - KGNavConfigure().navItemfixedSpace;
    for (NSLayoutConstraint *constraint in leadingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeLeading) {
            constraint.constant = constant;
        }
    }
}

- (void)kg_adjustTrailingBarConstraints {
    if (KGNavConfigure().disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *trailingBarConstraints = [self valueForKey:@"_trailingBarConstraints"];
    if (!trailingBarConstraints) return;
    CGFloat constant = KGNavConfigure().navItemfixedSpace - KGNavConfigure().navItemRightSpace;
    for (NSLayoutConstraint *constraint in trailingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.constant = constant;
        }
    }
}

@end
