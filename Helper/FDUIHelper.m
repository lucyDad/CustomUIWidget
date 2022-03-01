//
//  FDUIHelper.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import "FDUIHelper.h"
#import "FDCGCommonDefines.h"
#import "FDCompileCommonDefines.h"

@implementation FDUIHelper

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FDUIHelper sharedInstance];// 确保内部的变量、notification 都正确配置
    });
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FDUIHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
//        // 先设置默认值，不然可能变量的指针地址错误
//        instance.keyboardVisible = NO;
//        instance.lastKeyboardHeight = 0;
//        instance.orientationBeforeChangingByHelper = UIDeviceOrientationUnknown;
//
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleAppSizeWillChange:) name:QMUIAppSizeWillChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleDeviceOrientationNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(handleAppEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)dealloc {
    // QMUIHelper 若干个分类里有用到消息监听，所以在 dealloc 的时候注销一下
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end

@implementation FDUIHelper (UIGraphic)

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

+ (void)inspectContextSize:(CGSize)size {
    if (!CGSizeIsValidated(size)) {
        NSAssert(NO, @"FDUIHelper (UIGraphic)", @"QMUI CGPostError, %@:%d %s, 非法的size：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, NSStringFromCGSize(size), [NSThread callStackSymbols]);
    }
}

+ (BOOL)inspectContextIfInvalidated:(CGContextRef)context {
    if (!context) {
        NSAssert(NO, @"FDUIHelper (UIGraphic)", @"QMUI CGPostError, %@:%d %s, 非法的context：%@\n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, context, [NSThread callStackSymbols]);
        return NO;
    }
    return YES;
}

@end

@implementation FDUIHelper (SystemVersion)

+ (NSInteger)numbericOSVersion {
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *OSVersionArr = [OSVersion componentsSeparatedByString:@"."];
    
    NSInteger numbericOSVersion = 0;
    NSInteger pos = 0;
    
    while ([OSVersionArr count] > pos && pos < 3) {
        numbericOSVersion += ([[OSVersionArr objectAtIndex:pos] integerValue] * pow(10, (4 - pos * 2)));
        pos++;
    }
    
    return numbericOSVersion;
}

+ (NSComparisonResult)compareSystemVersion:(NSString *)currentVersion toVersion:(NSString *)targetVersion {
    return [currentVersion compare:targetVersion options:NSNumericSearch];
}

+ (BOOL)isCurrentSystemAtLeastVersion:(NSString *)targetVersion {
    return [FDUIHelper compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedSame || [FDUIHelper compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedDescending;
}

+ (BOOL)isCurrentSystemLowerThanVersion:(NSString *)targetVersion {
    return [FDUIHelper compareSystemVersion:[[UIDevice currentDevice] systemVersion] toVersion:targetVersion] == NSOrderedAscending;
}

@end
