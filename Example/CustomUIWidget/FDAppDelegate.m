//
//  FDAppDelegate.m
//  CustomUIWidget
//
//  Created by lucyDad on 03/11/2020.
//  Copyright (c) 2020 lucyDad. All rights reserved.
//

#import "FDAppDelegate.h"
#import "FDViewController.h"
#import "FDComponentsViewController.h"
#import "FDUIKitViewController.h"
#import "FDSettingViewController.h"
#import <YYCategories/YYCategories.h>

@implementation FDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    #if DEBUG
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    #endif
    
    UIImage *bgImage = [self defaultNavigationBarBackgroundImage];
    NSDictionary *attr = [self defaultNavigationBarTitleTextAttributes];
    // navigationBar setBackgroundImage not working on iOS15 https://developer.apple.com/forums/thread/683265
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
//        appearance.backgroundColor = [UIColor whiteColor];
//        appearance.shadowColor = [UIColor whiteColor];
//        appearance.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        [appearance setBackgroundImage:bgImage];
        [appearance setTitleTextAttributes:attr];
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = [UINavigationBar appearance].standardAppearance;
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[bgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:attr];
    }
    
    // 界面
    self.window = [[UIWindow alloc] init];
    [self didInitWindow];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didInitWindow {
    self.window.rootViewController = [self generateWindowRootViewController];
    [self.window makeKeyAndVisible];
}

- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
    return tabBarItem;
}

- (UIViewController *)generateWindowRootViewController {
    UITabBarController *tabBarViewController = [[UITabBarController alloc] init];
    
    // UIComponents
    FDComponentsViewController *componentViewController = [[FDComponentsViewController alloc] init];
    componentViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *componentNavController = [[UINavigationController alloc] initWithRootViewController:componentViewController];
    componentNavController.tabBarItem = [self tabBarItemWithTitle:@"Components" image:UIImageMake(@"icon_tabbar_component") selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    AddAccessibilityHint(componentNavController.tabBarItem, @"展示 QMUI 自己的组件库");
    
    // QMUIKit
    FDUIKitViewController *uikitViewController = [[FDUIKitViewController alloc] init];
    uikitViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *uikitNavController = [[UINavigationController alloc] initWithRootViewController:uikitViewController];
    uikitNavController.tabBarItem = [self tabBarItemWithTitle:@"FDUIKit" image:UIImageMake(@"icon_tabbar_uikit") selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:0];
    AddAccessibilityHint(uikitNavController.tabBarItem, @"展示一系列对系统原生控件的拓展的能力");
    
    // Lab
    FDViewController *labViewController = [[FDViewController alloc] init];
    labViewController.hidesBottomBarWhenPushed = NO;
    UINavigationController *labNavController = [[UINavigationController alloc] initWithRootViewController:labViewController];
    labNavController.tabBarItem = [self tabBarItemWithTitle:@"Lab" image:UIImageMake(@"icon_tabbar_lab") selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:2];
    AddAccessibilityHint(labNavController.tabBarItem, @"集合一些非正式但可能很有用的小功能");
    
    // window root controller
    tabBarViewController.viewControllers = @[componentNavController, uikitNavController, labNavController];
    return tabBarViewController;
}

- (UIImage *)defaultNavigationBarBackgroundImage {
    return [UIImage imageWithColors:[self defaultNavigationBarBackgroundColors] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
}

- (NSArray *)defaultNavigationBarBackgroundColors {
    return @[(id)[UIColor colorWithHexString:@"#864dd4"].CGColor,
             (id)[UIColor colorWithHexString:@"#716bef"].CGColor];
}

- (NSDictionary *)defaultNavigationBarTitleTextAttributes {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [dict setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    return dict;
}


@end
