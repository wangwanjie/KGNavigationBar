//
//  PresentStyleViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/9/6.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "PresentStyleViewController.h"
#import "HideNavigationBarViewController.h"

@interface PresentStyleViewController ()

@end

@implementation PresentStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_statusBarStyle = UIStatusBarStyleDefault;
    self.kg_navBackgroundColor = [UIColor yellowColor];
    self.kg_navigationItem.title = @"Present 样式进栈出栈页面";
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"Push 无导航栏页面" forState:UIControlStateNormal];

    self.tipLabel.text = @"当前页面是以 Present 样式推进的";
}

- (void)clickedPushButton:(UIButton *)button {
    HideNavigationBarViewController *vc = [[HideNavigationBarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}
@end
