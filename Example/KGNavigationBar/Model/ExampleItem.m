//
//  ExampleItem.m
//  KGNavigationBar_Example
//
//  Created by VanJay on 2021/8/14.
//  Copyright © 2021 wangwanjie. All rights reserved.
//

#import "ExampleItem.h"

@implementation ExampleItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionShadowEnable = true;
        self.useCustomTransition = true;
        self.tabBarHeight = 0;
    }
    return self;
}

+ (instancetype)itemWithDesc:(NSString *)desc transitionRatio:(CGFloat)transitionRatio hideTabBarIfNoFirstVc:(BOOL)hideTabBarIfNoFirstVc {
    ExampleItem *item = [[self alloc] init];
    item.desc = desc;
    item.transitionRatio = transitionRatio;
    item.hideTabBarIfNoFirstVc = hideTabBarIfNoFirstVc;
    return item;
}
@end
