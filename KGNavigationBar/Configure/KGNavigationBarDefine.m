//
//  KGNavigationBarDefine.m
//  KGNavigationBar
//
//  Created by VanJay on 2019/10/27.
//

#import "KGNavigationBarDefine.h"
#import <objc/runtime.h>

const CGFloat KGNavigationBarItemSpace = -1;

void kg_swizzled_instanceMethod(Class oldClass, NSString *oldSelector, Class newClass) {
    NSString *newSelector = [NSString stringWithFormat:@"kg_nav_%@", oldSelector];
    SEL originalSelector = NSSelectorFromString(oldSelector);
    SEL swizzledSelector = NSSelectorFromString(newSelector);
    Method originalMethod = class_getInstanceMethod(oldClass, NSSelectorFromString(oldSelector));
    Method swizzledMethod = class_getInstanceMethod(newClass, NSSelectorFromString(newSelector));
    BOOL isAdd = class_addMethod(oldClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        class_replaceMethod(newClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

BOOL kg_overrideImplementation(Class _Nonnull targetClass, SEL _Nonnull targetSelector, id _Nonnull (^_Nonnull implementationBlock)(Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

const NSTimeInterval KGUINavigationControllerHideShowBarDuration = 0.3;
