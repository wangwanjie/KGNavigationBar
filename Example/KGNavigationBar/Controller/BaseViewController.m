//
//  BaseViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "BaseViewController.h"
#import "SecondViewController.h"

@interface BaseViewController ()
/// Push 按钮
@property (nonatomic, strong) UIButton *pushButton;
/// 提示
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kg_navigationItem.title = @"一级页面";

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.pushButton];
    self.pushButton.translatesAutoresizingMaskIntoConstraints = false;

    NSLayoutConstraint *centerXA = [self.pushButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    NSLayoutConstraint *bottomA = [self.pushButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100];

    NSLayoutConstraint *widthA = [self.pushButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-80];
    NSLayoutConstraint *heightA = [self.pushButton.heightAnchor constraintEqualToConstant:40];

    [self.pushButton addConstraints:@[heightA]];
    [self.view addConstraints:@[centerXA, bottomA, widthA]];

    [self.view addSubview:self.tipLabel];
    self.tipLabel.translatesAutoresizingMaskIntoConstraints = false;

    NSLayoutConstraint *labelCenterXA = [self.tipLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    NSLayoutConstraint *labelBottomA = [self.tipLabel.bottomAnchor constraintEqualToAnchor:self.pushButton.topAnchor constant:-40];
    NSLayoutConstraint *labelWidthA = [self.tipLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-80];
    [self.view addConstraints:@[labelCenterXA, labelBottomA, labelWidthA]];
}

#pragma mark - event response
- (void)clickedPushButton:(UIButton *)button {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - lazy load
- (UIButton *)pushButton {
    if (_pushButton) return _pushButton;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [button setTitle:@"Push 二级页面" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:24];
    [button addTarget:self action:@selector(clickedPushButton:) forControlEvents:UIControlEventTouchUpInside];
    _pushButton = button;
    return _pushButton;
}

- (UILabel *)tipLabel {
    if (_tipLabel) return _tipLabel;

    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.text = @"点击按钮 Push 页面试试，你可以自定义任何一个页面的导航栏上的任何东西，包括但不限于返回按钮，标题，背景色，等等，你可以像使用系统 navigationItem 一样使用 kg_navigationItem。最小成本接入正常只需要替换默认返回按钮，可以直接创建一个基类控制器，设置 self.kg_backButtonImage = UIImage_instance 即可，如果你希望更改默认设置，设置转场之前在 [KGNavConfigure() updateConfigure:] 中设置默认属性，参考本 Demo 中 KGAppDelegate 中代码";

    _tipLabel = label;
    return _tipLabel;
}
@end
