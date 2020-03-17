//
//  UIView+FDAlertView.h
//  funnydate
//
//  Created by hexiang on 2019/4/2.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDCommonAlertView.h"

@interface UIView (FDAlertView)

#pragma mark - 不带block回调方法

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config;

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                       customView:(UIView *)customView;

#pragma mark - 带block回调方法

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                       clickBlock:(FDAlertViewClickBlock)clickBlock;

- (void)showFDAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                       customView:(UIView *)customView
                       clickBlock:(FDAlertViewClickBlock)clickBlock;

@end
