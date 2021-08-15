//
//  KGCustomNavigationBar.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGCustomNavigationBar.h"
#import "KGNavigationBarDefine.h"

@implementation KGCustomNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = NO;
        self.kg_navBarBackgroundAlpha = 1.0f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 适配iOS11，遍历所有子控件，向下移动状态栏高度
    if (kg_navigationBarDeviceVersion() >= 11.0f) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                obj.backgroundColor = [UIColor clearColor];
                CGRect frame = obj.frame;
                frame.size.height = self.frame.size.height;
                obj.frame = frame;
            } else {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                CGFloat height = [UIScreen mainScreen].bounds.size.height;
                CGFloat y = 0;
                if (width > height) {
                    if (ks_isIphoneXSeries()) {
                        y = 0;
                    } else {
                        y = kg_statusBarHeight();
                    }
                } else {
                    y = kg_statusBarHeight();
                }
                CGRect frame = obj.frame;
                frame.origin.y = y;
                obj.frame = frame;
            }
        }];
    }
    // 重新设置透明度
    self.kg_navBarBackgroundAlpha = self.kg_navBarBackgroundAlpha;
    // 分割线
    [self kg_navLineHideOrShow];
}

- (void)kg_navLineHideOrShow {
    UIView *backgroundView = self.subviews.firstObject;
    for (UIView *view in backgroundView.subviews) {
        if (view.frame.size.height > 0 && view.frame.size.height <= 1.0f) {
            view.hidden = self.kg_navLineHidden;
        }
    }
}

- (void)setKg_navBarBackgroundAlpha:(CGFloat)kg_navBarBackgroundAlpha {
    _kg_navBarBackgroundAlpha = kg_navBarBackgroundAlpha;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (kg_navigationBarDeviceVersion() >= 10.0f && [obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj.alpha != kg_navBarBackgroundAlpha) {
                    obj.alpha = kg_navBarBackgroundAlpha;
                }
            });
        } else if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (obj.alpha != kg_navBarBackgroundAlpha) {
                    obj.alpha = kg_navBarBackgroundAlpha;
                }
            });
        }
    }];
    BOOL isClipsToBounds = (kg_navBarBackgroundAlpha == 0.0f);
    if (self.clipsToBounds != isClipsToBounds) {
        self.clipsToBounds = isClipsToBounds;
    }
}
@end
