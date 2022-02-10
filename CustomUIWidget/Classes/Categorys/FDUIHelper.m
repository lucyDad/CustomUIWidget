//
//  FDUIHelper.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import "FDUIHelper.h"

@implementation FDUIHelper

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

+ (BOOL)isFullScreen {
    BOOL result = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return result;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            result = YES;
        }
    }
    return result;
}

+ (CGFloat)tabbarHeight {
    UITabBarController *tabbarVC = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    if ([tabbarVC isKindOfClass:[UITabBarController class]]) {
        return tabbarVC.tabBar.frame.size.height;
    }
    return ([self isFullScreen] ? (83) : (49));
}

+ (CGFloat)bottomSafeAreaHeight {
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        height = window.safeAreaInsets.bottom;
    }
    return height;
}

static NSMutableSet<NSString *> *executedIdentifiers;
+ (BOOL)executeBlock:(void (NS_NOESCAPE ^)(void))block oncePerIdentifier:(NSString *)identifier {
    if (!block || identifier.length <= 0) return NO;
    @synchronized (self) {
        if (!executedIdentifiers) {
            executedIdentifiers = NSMutableSet.new;
        }
        if (![executedIdentifiers containsObject:identifier]) {
            [executedIdentifiers addObject:identifier];
            block();
            return YES;
        }
        return NO;
    }
}

@end
