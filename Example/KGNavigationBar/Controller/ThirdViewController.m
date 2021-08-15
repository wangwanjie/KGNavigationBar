//
//  ThirdViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "ThirdViewController.h"
#import "NoneFullScreenGestureViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_navBackgroundColor = [UIColor blueColor];
    self.kg_navigationItem.title = @"更深层级页面";
    self.kg_navTitleColor = [UIColor blackColor];
    [self.pushButton setTitle:@"Push 无全屏手势退出页面" forState:UIControlStateNormal];
    if (self.isLeftSlidePushed) {
        self.tipLabel.text = @"边缘返回和全屏返回每个页面单独处理禁用，你可以在 init 也可以在 viewDidLoad 处理，当然，随时设置都是生效的\n\n 我是被左滑 Push 出来的，如同抖音视频浏览页左滑拉出视频作者个人页效果";
    } else {
        self.tipLabel.text = @"边缘返回和全屏返回每个页面单独处理禁用，你可以在 init 也可以在 viewDidLoad 处理，当然，随时设置都是生效的";
    }
}

- (void)clickedPushButton:(UIButton *)button {
    NoneFullScreenGestureViewController *vc = [[NoneFullScreenGestureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}
@end
