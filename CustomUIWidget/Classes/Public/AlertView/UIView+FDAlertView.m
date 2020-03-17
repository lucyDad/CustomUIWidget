//
//  UIView+FDAlertView.m
//  funnydate
//
//  Created by hexiang on 2019/4/2.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import "UIView+FDAlertView.h"
#import "FDAnimationManagerView.h"
#import <libextobjc/extobjc.h>

@implementation UIView (FDAlertView)

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config {
    [self showFDAlertViewWithConfig:config clickBlock:nil];
}

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
          customView:(UIView *)customView {
    [self showFDAlertViewWithConfig:config customView:customView clickBlock:nil];
}

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
             clickBlock:(FDAlertViewClickBlock)clickBlock {

    [self showFDAlertViewWithConfig:config customView:nil clickBlock:clickBlock];
}

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                       customView:(UIView *)customView
             clickBlock:(FDAlertViewClickBlock)clickBlock {

    FDCommonAlertView *view = [[FDCommonAlertView alloc] initWithFrame:CGRectMake(FDCommonAlertViewMargin, 0, [UIScreen mainScreen].bounds.size.width - 2 * FDCommonAlertViewMargin, 100) andConfig:config customView:customView];
    
    FDAnimationManagerViewConfig *animationConfig = [FDAnimationManagerViewConfig new];
    animationConfig.animationContainerView = view;
    animationConfig.managerType = FDAnimationManagerShowTypeMiddle;
    FDAnimationManagerView *managerView = [[FDAnimationManagerView alloc] initWithFrame:self.bounds andConfig:animationConfig];
    managerView.clickBackgroundBlock = ^(FDAnimationManagerView *animationView) {
        // 点击背景不做处理
        if (clickBlock) {
            clickBlock(FDAlertViewClickTypeBackground);
        }
    };
    @weakify(managerView);
    view.clickBlock = ^(FDCommonAlertView * popView, FDAlertViewClickType clickType) {
        @strongify(managerView);
        [managerView dismissAnimationManagerView:^{
            [managerView removeFromSuperview];
            
            if (clickBlock) {
                clickBlock((FDAlertViewClickType)clickType);
            }
        }];
    };
    
    [self addSubview:managerView];
    [managerView showAnimationManagerView:nil];
}

@end
