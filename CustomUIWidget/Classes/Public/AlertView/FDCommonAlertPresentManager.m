//
//  FDCommonAlertPresentManager.m
//  funnydate
//
//  Created by hexiang on 2019/4/17.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import "FDCommonAlertPresentManager.h"
#import "FDAnimationManagerView.h"
#import "FDCommonAlertView.h"
#import <libextobjc/extobjc.h>

@implementation FDCommonAlertPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface FDCommonAlertPresentManager ()
{
    
}

@end

@implementation FDCommonAlertPresentManager

#pragma mark - Public Interface

+ (void)presentCommonAlertViewWithConfig:(FDCommonAlertViewConfig *)config {
    [self presentCommonAlertViewWithConfig:config clickBlock:nil];
}

+ (void)presentCommonAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                    clickBlock:(FDAlertViewClickBlock)clickBlock {

    FDCommonAlertView *view = [[FDCommonAlertView alloc] initWithFrame:CGRectMake(FDCommonAlertViewMargin, 0, [UIScreen mainScreen].bounds.size.width - 2 * FDCommonAlertViewMargin, 100) andConfig:config customView:nil];
    
    FDAnimationManagerViewConfig *animationConfig = [FDAnimationManagerViewConfig new];
    animationConfig.animationContainerView = view;
    animationConfig.managerType = FDAnimationManagerShowTypeMiddle;
    FDAnimationManagerView *managerView = [[FDAnimationManagerView alloc] initWithFrame:[UIScreen mainScreen].bounds andConfig:animationConfig];
    managerView.clickBackgroundBlock = ^(FDAnimationManagerView *animationView) {
        // 点击背景不做处理
    };
    
    FDCommonAlertPresentViewController *alertVC = [[FDCommonAlertPresentViewController alloc] init];
    alertVC.view.backgroundColor = [UIColor clearColor];
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alertVC.view.frame = [UIScreen mainScreen].bounds;
    [alertVC.view addSubview:managerView];
    [managerView showAnimationManagerView:nil];
    
    [[self getTopVC] presentViewController:alertVC animated:NO completion:nil];
    
    @weakify(alertVC, managerView);
    view.clickBlock = ^(FDCommonAlertView * popView, FDAlertViewClickType clickType) {
        @strongify(alertVC, managerView);
        [managerView dismissAnimationManagerView:^{
            [alertVC dismissViewControllerAnimated:NO completion:^{
                if (clickBlock) {
                    clickBlock((FDAlertViewClickType)clickType);
                }
            }];
        }];
    };
}

//+ (void)presentPostTimelineView:(CGPoint)point {
//
//    NSArray *titles = @[@"文字", @"相册", @"拍照", @"短视频", @"语音"];
//    NSArray *images = @[[UIImage imageNamed:@"arrow_popView_text"], [UIImage imageNamed:@"arrow_popView_album"], [UIImage imageNamed:@"arrow_popView_photo"],[UIImage imageNamed:@"arrow_popView_camera"], [UIImage imageNamed:@"arrow_popView_audio"]];
//    FDArrowCustomListViewConfig *listConfig = [FDArrowCustomListViewConfig new];
//    listConfig.titles = titles;
//    listConfig.images = images;
//    listConfig.cellHeight = 50;
//    listConfig.titleColor = [UIColor whiteColor];
//    FDArrowCustomListView *listView = [[FDArrowCustomListView alloc] initWithFrame:CGRectMake(0, 0, 150, 0) withConfig:listConfig];
//
//    FDArrowTipsViewConfig *config = [FDArrowTipsViewConfig new];
//    config.gradientBeginColor = [UIColor colorWithRed:170.0/255.0f green:108.0/255.0f blue:239.0/255.0f alpha:1.0f];
//    config.gradientEndColor = [UIColor colorWithRed:133.0/255.0f green:112.0/255.0f blue:241.0/255.0f alpha:1.0f];
//    config.gradientBeginPoint = CGPointMake(0, 0);
//    config.gradientEndPoint = CGPointMake(1, 1);
//    FDArrowTipsView *popView = [[FDArrowTipsView alloc] initWithFrame:CGRectZero andConfig:config andCustomView:listView];
//
//    popView.top = NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT - 5;
//    popView.right = [UIScreen mainScreen].bounds.size.width - 10;
//
//    FDAnimationManagerViewConfig *animationConfig = [FDAnimationManagerViewConfig new];
//    animationConfig.animationContainerView = popView;
//    animationConfig.managerType = FDAnimationManagerShowTypeMiddle;
//    animationConfig.centerPoint = CGPointMake(CGRectGetMinX(popView.frame) + popView.width / 2.0f, CGRectGetMinY(popView.frame) + popView.height / 2.0f);
//    FDAnimationManagerView *managerView = [[FDAnimationManagerView alloc] initWithFrame:[UIScreen mainScreen].bounds andConfig:animationConfig];
//
//    FDCommonAlertPresentViewController *alertVC = [[FDCommonAlertPresentViewController alloc] init];
//    alertVC.view.backgroundColor = [UIColor clearColor];
//    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    alertVC.view.frame = [UIScreen mainScreen].bounds;
//    [alertVC.view addSubview:managerView];
//    [managerView showAnimationManagerView:nil];
//    [[self getTopVC] presentViewController:alertVC animated:NO completion:nil];
//
//    @weakify(alertVC, managerView);
//    popView.clickBlock = ^(FDArrowPopView * _Nonnull morePopView, NSString * _Nonnull title, NSInteger index) {
//
//        @strongify(alertVC, managerView);
//
//        [managerView dismissAnimationManagerView:^{
//            [alertVC dismissViewControllerAnimated:NO completion:^{
//                if (clickBlock) {
//                    clickBlock([self getPostTimelineClickType:title]);
//                }
//            }];
//        }];
//    };
//    managerView.clickBackgroundBlock = ^(FDAnimationManagerView *animationView) {
//        @strongify(alertVC, managerView);
//        [managerView dismissAnimationManagerView:^{
//            [alertVC dismissViewControllerAnimated:NO completion:^{
//                if (clickBlock) {
//                    clickBlock(FDPostTimelineClickTypeNone);
//                }
//            }];
//        }];
//    };
//}

#pragma mark - Life Cycle

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Event Response

#pragma mark - Private Methods

+ (UIViewController *)getTopVC {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = [self topViewController:rootVC];
    if (topVC.presentingViewController) {
        return topVC;
    }
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (UIViewController*)topViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark - Setter or Getter

@end
