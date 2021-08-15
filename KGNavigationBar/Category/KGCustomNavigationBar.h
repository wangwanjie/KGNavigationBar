//
//  KGCustomNavigationBar.h
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGCustomNavigationBar : UINavigationBar
/// 当前所在的控制器是否隐藏状态栏
@property (nonatomic, assign) BOOL kg_statusBarHidden;
/// 导航栏透明度
@property (nonatomic, assign) CGFloat kg_navBarBackgroundAlpha;
/// 导航栏分割线是否隐藏
@property (nonatomic, assign) BOOL kg_navLineHidden;
@end

NS_ASSUME_NONNULL_END
