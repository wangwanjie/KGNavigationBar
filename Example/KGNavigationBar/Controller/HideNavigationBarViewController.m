//
//  HideNavigationBarViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "HideNavigationBarViewController.h"

@interface HideNavigationBarViewController ()

@end

@implementation HideNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_statusBarStyle = UIStatusBarStyleDefault;

    self.kg_navigationBar.hidden = true;
    self.kg_navLineHidden = true;
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"点击回到顶级页面" forState:UIControlStateNormal];
    self.tipLabel.text = @"当前页面虽然隐藏了导航栏，但是手势是开启的，可以滑动返回\n\n注意，当前页面的状态栏被设置成了黑色，你不需要考虑 UIStatusBarStyleDarkContent 情况，用 kg_statusBarStyle 设置内部会自动判断\n\n\n一个完整的项目中的事件应该是创建你自己的基类控制器，在 viewWillAppear 中根据实际业务情况处理导航栏和状态栏样式";
}

- (void)clickedPushButton:(UIButton *)button {
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
