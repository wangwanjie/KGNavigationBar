//
//  KGNavigationBarConfigure.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGNavigationBarConfigure.h"

@interface KGNavigationBarConfigure ()
/// 当前 item 修复间距
@property (nonatomic, assign) CGFloat navItemfixedSpace;
@end

@implementation KGNavigationBarConfigure
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KGNavigationBarConfigure *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        [instance setupDefaultConfigure];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (void)setupDefaultConfigure {
    self.backgroundColor = [UIColor whiteColor];
    self.titleColor = [UIColor blackColor];
    self.titleFont = [UIFont boldSystemFontOfSize:17.0f];
    self.disableFixSpace = NO;
    self.navItemLeftSpace = 12.0;
    self.navItemRightSpace = 12.0;
    self.pushTransitionCriticalValue = 0.3f;
    self.popTransitionCriticalValue = 0.5f;
    self.criticalVelocityX = 1000.0;
    self.transitionShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.transitionShadowEnable = true;
    self.disableScaleWhenHasTabBar = false;

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.navItemfixedSpace = MIN(screenSize.width, screenSize.height) > 375.0f ? 20.0f : 16.0f;
}

- (void)setupCustomConfigure:(void (^)(KGNavigationBarConfigure *_Nonnull))block {
    [self setupDefaultConfigure];
    [self updateConfigure:block];
}

- (void)updateConfigure:(void (^)(KGNavigationBarConfigure *_Nonnull))block {
    !block ?: block(self);
}
@end

KGNavigationBarConfigure *KGNavConfigure(void) {
    return [KGNavigationBarConfigure sharedInstance];
}
