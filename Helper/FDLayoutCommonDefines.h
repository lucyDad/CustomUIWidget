//
//  FDLayoutCommonDefines.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#ifndef FDLayoutCommonDefines_h
#define FDLayoutCommonDefines_h

#import "FDUIHelper+Device.h"

#pragma mark - 变量-设备相关

/// 设备类型
#define IS_IPAD [FDUIHelper isIPad]
#define IS_IPOD [FDUIHelper isIPod]
#define IS_IPHONE [FDUIHelper isIPhone]
#define IS_SIMULATOR [FDUIHelper isSimulator]
#define IS_MAC [FDUIHelper isMac]

/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])

/// 数字形式的操作系统版本号，可直接用于大小比较；如 110205 代表 11.2.5 版本；根据 iOS 规范，版本号最多可能有3位
#define IOS_VERSION_NUMBER [FDUIHelper numbericOSVersion]

/// 是否横竖屏
/// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
/// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/// 设备宽度，跟横竖屏无关
#define DEVICE_WIDTH MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// 设备高度，跟横竖屏无关
#define DEVICE_HEIGHT MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// 是否Retina
#define IS_RETINASCREEN ([[UIScreen mainScreen] scale] >= 2.0)

/// 是否放大模式（iPhone 6及以上的设备支持放大模式，iPhone X 除外）
#define IS_ZOOMEDMODE [FDUIHelper isZoomedMode]

/// 获取一个像素
#define PixelOne [FDUIHelper pixelOne]

/// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算，iOS 13 起，来电等情况下状态栏高度不会改变)
#define StatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)

#define kBottomSafeAreaHeight ([FDUIHelper bottomSafeAreaHeight])
#define kTabBarHeight ([FDUIHelper tabbarHeight])
#define kNavigationBarHeight (44)
#define kIsFullScreen ([FDUIHelper isFullScreen])

/// bounds && nativeBounds / scale && nativeScale
#define ScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
#define ScreenNativeBoundsSize ([[UIScreen mainScreen] nativeBounds].size)
#define ScreenScale ([[UIScreen mainScreen] scale])
#define ScreenNativeScale ([[UIScreen mainScreen] nativeScale])

#endif /* FDLayoutCommonDefines_h */
