//
//  FDAlertNavigationManager.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import "FDAlertNavigationManager.h"

@implementation FDAlertNavigationConfigInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@interface FDAlertNavigationManager ()
{
    
}

@end

@implementation FDAlertNavigationManager

#pragma mark - Public Interface

//+ (void)presentAlertNavigation:(UIViewController *)superVC configInfo:(FDAlertNavigationConfigInfo *)configInfo {
//    UINavigationController *navChild = ({
//        UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[FDPushRecommendListViewController new]];
//        vc.view.backgroundColor = [UIColor greenColor];
//        vc.view.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
//        vc.view.top = [UIScreen mainScreen].bounds.size.height - 300;
//        vc;
//    });
//    
//    UIViewController *rootVC = [UIViewController new];
//    [rootVC.view addSubview:navChild.view];
//    [rootVC addChildViewController:navChild];
//    UINavigationController *nav = ({
//        UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:rootVC];
//        vc.view.backgroundColor = [UIColor redColor];
//        vc.view.autoresizesSubviews = NO;
//        vc;
//    });
//    
//    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext; //
//    NSLog(@"present nav = %p, childNav = %p", nav, navChild);
//    [superVC presentViewController:nav animated:YES completion:^{
//        //UIViewController *vc = [ZATopViewControllerUtils topViewControllerWithDefaultRootViewController];
//        //NSLog(@"top vc = %@, nav = %p", vc, vc.navigationController);
//        
//    }];
//}

#pragma mark - Life Cycle

#pragma mark - Event Response

#pragma mark - Private Methods

#pragma mark - Setter or Getter

@end
