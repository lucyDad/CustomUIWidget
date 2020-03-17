//
//  FDCommonAlertPresentManager.h
//  funnydate
//
//  Created by hexiang on 2019/4/17.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDCommonAlertView.h"

@interface FDCommonAlertPresentViewController : UIViewController

@end

@interface FDCommonAlertPresentManager : NSObject

+ (void)presentCommonAlertViewWithConfig:(FDCommonAlertViewConfig *)config;

/**
 present方式加载通用弹框

 @param config 弹框配置参数
 @param clickBlock 点击回调
 */
+ (void)presentCommonAlertViewWithConfig:(FDCommonAlertViewConfig *)config
                    clickBlock:(FDAlertViewClickBlock)clickBlock;

@end
