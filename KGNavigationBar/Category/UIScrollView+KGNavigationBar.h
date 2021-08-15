//
//  UIScrollView+KGNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (KGNavigationBar)

/// 是否禁用 UIScrollView 左滑返回手势处理，默认NO
@property (nonatomic, assign) BOOL kg_gestureHandleDisabled;

@end

NS_ASSUME_NONNULL_END
