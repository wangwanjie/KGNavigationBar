//
//  NoneEdgePopGestureViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "NoneEdgePopGestureViewController.h"
#import "HideNavigationBarViewController.h"

@interface NoneEdgePopGestureViewController ()

@end

@implementation NoneEdgePopGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_interactivePopDisabled = true;
    self.kg_navBackgroundColor = [UIColor greenColor];
    self.kg_navigationItem.title = @"禁用滑动退出手势";
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"Push 无导航栏页面" forState:UIControlStateNormal];
    self.tipLabel.text = @"当前页面禁用了手势退出，只能点击返回按钮退出或者代码触发返回";
}

- (void)clickedPushButton:(UIButton *)button {
    HideNavigationBarViewController *vc = [[HideNavigationBarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
