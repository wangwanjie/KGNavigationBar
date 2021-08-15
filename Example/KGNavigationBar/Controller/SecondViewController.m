//
//  SecondViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController () <KGViewControllerPushDelegate>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_statusBarStyle = UIStatusBarStyleDefault;
    self.kg_navBackgroundColor = [UIColor yellowColor];
    self.kg_navigationItem.title = @"二级页面";
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"Push 更深层级页面" forState:UIControlStateNormal];

    if (self.navigationController.kg_openScrollLeftPush) {
        self.kg_pushDelegate = self;
        self.tipLabel.text = @"当前页面支持左滑 Push 页面操作，可以左滑实现抖音视频浏览页左滑拉出视频作者个人页效果，状态栏设置深色没问题";
    } else {
        self.tipLabel.text = @"连续 Push 页面没问题，状态栏设置深色没问题";
    }
}

- (void)clickedPushButton:(UIButton *)button {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - KGViewControllerPushDelegate
- (void)kg_pushToNextViewController {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    vc.isLeftSlidePushed = true;
    [self.navigationController pushViewController:vc animated:true];
}
@end
