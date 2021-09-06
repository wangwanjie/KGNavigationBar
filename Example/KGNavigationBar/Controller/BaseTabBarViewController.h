//
//  BaseTabBarViewController.h
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ExampleItem;

@interface BaseTabBarViewController : UITabBarController
- (instancetype)initWithModel:(ExampleItem *)item;
@end

NS_ASSUME_NONNULL_END
