//
//  BaseViewController.h
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KGNavigationBar/KGNavigationBar.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
/// Push 按钮
@property (nonatomic, strong, readonly) UIButton *pushButton;
/// 提示
@property (nonatomic, strong, readonly) UILabel *tipLabel;
- (void)clickedPushButton:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
