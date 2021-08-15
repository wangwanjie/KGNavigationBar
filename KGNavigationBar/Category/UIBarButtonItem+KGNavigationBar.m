//
//  UIBarButtonItem+KGNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/28.
//

#import "UIBarButtonItem+KGNavigationBar.h"

@implementation UIBarButtonItem (KGNavigationBar)

+ (instancetype)kg_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self kg_itemWithTitle:title image:nil target:target action:action];
}

+ (instancetype)kg_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self kg_itemWithTitle:nil image:image target:target action:action];
}

+ (instancetype)kg_itemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action {
    return [self kg_itemWithTitle:title image:image highLightImage:nil target:target action:action];
}

+ (instancetype)kg_itemWithImage:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    return [self kg_itemWithTitle:nil image:image highLightImage:highLightImage target:target action:action];
}

+ (instancetype)kg_itemWithTitle:(NSString *)title image:(UIImage *)image highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (highLightImage) {
        [button setImage:highLightImage forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (button.bounds.size.width < 44.0f) {
        button.bounds = CGRectMake(0, 0, 44.0f, 44.0f);
    }
    return [[self alloc] initWithCustomView:button];
}

@end
