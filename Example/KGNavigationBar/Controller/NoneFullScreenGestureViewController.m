//
//  NoneFullScreenGestureViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "NoneFullScreenGestureViewController.h"
#import "NoneEdgePopGestureViewController.h"

@interface NoneFullScreenGestureViewController ()

@end

@implementation NoneFullScreenGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_fullScreenPopDisabled = true;
    self.kg_navBackgroundColor = [UIColor greenColor];
    self.kg_navigationItem.title = @"禁用全屏退出手势";
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"Push 禁用滑动退出" forState:UIControlStateNormal];
    self.tipLabel.text = @"当前页面没有全屏手势退出，但是边缘仍然可以滑动退出";
}

- (void)clickedPushButton:(UIButton *)button {
    NoneEdgePopGestureViewController *vc = [[NoneEdgePopGestureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end
