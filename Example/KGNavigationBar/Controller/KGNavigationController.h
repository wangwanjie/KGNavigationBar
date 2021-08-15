//
//  KGNavigationController.h
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/7/23.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGNavigationController : UINavigationController
/// 转场时非第一个页面是否隐藏 TabBar
@property (nonatomic, assign) BOOL hideTabBarIfNoFirstVc;
@end

NS_ASSUME_NONNULL_END
