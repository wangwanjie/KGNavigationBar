//
//  BaseTabBarViewController.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseViewController.h"
#import <KGNavigationBar/KGNavigationBar.h>
#import "KGNavigationController.h"
#import "ExampleItem.h"

@interface BaseTabBarViewController ()
/// 配置
@property (nonatomic, strong) ExampleItem *item;
@end

@implementation BaseTabBarViewController

- (instancetype)initWithModel:(ExampleItem *)item {
    self = [super init];
    if (self) {
        self.item = item;

        if (item.isTabBarBgTransparent) {
            self.tabBar.kg_isBgTransparent = true;
        }

        NSMutableArray<UIViewController *> *vcs = [NSMutableArray arrayWithCapacity:4];

        void (^addChildVC)(NSString *) = ^void(NSString *name) {
            BaseViewController *vc = [[BaseViewController alloc] init];
            vc.kg_navigationItem.title = name;
            vc.title = name;
            vc.tabBarItem.image = [[UIImage imageNamed:@"ic-qaeda-normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic-qaeda-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (item.isTabBarBgTransparent) {
                vc.extendedLayoutIncludesOpaqueBars = YES;
                vc.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            }
            KGNavigationController *navc = [KGNavigationController rootVC:vc transitionRatio:item.transitionRatio openScrollLeftPush:item.openScrollLeftPush];
            navc.hideTabBarIfNoFirstVc = item.hideTabBarIfNoFirstVc;
            navc.kg_transitionShadowEnable = item.transitionShadowEnable;
            if (item.transitionShadowColor) {
                navc.kg_transitionShadowColor = item.transitionShadowColor;
            }
            navc.kg_useCustomTransition = item.useCustomTransition;
            [vcs addObject:navc];
        };
        addChildVC(@"发现");
        addChildVC(@"直播");
        addChildVC(@"K歌");
        addChildVC(@"我的");

        if (item.nestedItem) {
            BaseTabBarViewController *tabBarVc = [[BaseTabBarViewController alloc] initWithModel:item.nestedItem];
            tabBarVc.tabBarItem.image = [[UIImage imageNamed:@"ic-qaeda-normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabBarVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic-qaeda-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabBarVc.kg_navigationItem.title = @"嵌套";
            tabBarVc.title = @"嵌套";
            [vcs addObject:tabBarVc];
        }
        self.viewControllers = [vcs copy];
        self.tabBar.kg_isBgTransparent = item.isTabBarBgTransparent;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.item.tabBarHeight > 0) {
        CGRect frame = self.tabBar.frame;
        CGFloat height = self.item.tabBarHeight;
        frame.size.height = height;
        frame.origin.y = self.view.bounds.size.height - height;
        self.tabBar.frame = frame;
    }
}

@end
