//
//  KGNavigationController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/7/23.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "KGNavigationController.h"
#import <objc/runtime.h>

@interface KGNavigationController ()

@end

@implementation KGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBarHidden = true;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (BOOL)shouldAutorotate {
    return self.viewControllers.lastObject.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.hideTabBarIfNoFirstVc) {
        // 第一个 控制器 不需要隐藏tabbar
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    }

    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    return [super popToRootViewControllerAnimated:animated];
}

@end
