//
//  UIBarButtonItem+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (KGNavigationBar)

+ (instancetype)kg_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)kg_itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)kg_itemWithTitle:(nullable NSString *)title image:(nullable UIImage *)image target:(id)target action:(SEL)action;

+ (instancetype)kg_itemWithImage:(nullable UIImage *)image highLightImage:(nullable UIImage *)highLightImage target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
