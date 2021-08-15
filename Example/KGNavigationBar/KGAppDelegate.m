//
//  KGAppDelegate.m
//  KGNavigationBar
//
//  Created by wangwanjie on 08/15/2021.
//  Copyright (c) 2021 wangwanjie. All rights reserved.
//

#import "KGAppDelegate.h"
#import <KGNavigationBar/KGNavigationBar.h>
#import "KGViewController.h"
#import "KGNavigationController.h"

@implementation KGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 非必要
    [KGNavConfigure() updateConfigure:^(KGNavigationBarConfigure *_Nonnull configure) {
        UIImage *image = [UIImage imageNamed:@"icon_back_black"];
        configure.backButtonImage = image;
        configure.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        configure.titleColor = [UIColor whiteColor];
        configure.titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    }];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    KGViewController *vc = [[KGViewController alloc] init];
    UINavigationController *navc = [KGNavigationController rootVC:vc transitionRatio:0.92];

    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
