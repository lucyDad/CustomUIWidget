//
//  FDAlertViewCommonDef.h
//  FunnyRecord
//
//  Created by hexiang on 2019/9/25.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#ifndef FDAlertViewCommonDef_h
#define FDAlertViewCommonDef_h

// 通用弹框操作类型
typedef NS_ENUM(NSInteger, FDAlertViewClickType) {
    FDAlertViewClickTypeClose,
    FDAlertViewClickTypeCancel,
    FDAlertViewClickTypeConfirm,
    FDAlertViewClickTypeTimeout,
    FDAlertViewClickTypeBackground,
};
typedef void(^FDAlertViewClickBlock)(FDAlertViewClickType clickType);

// 通用弹框的间距
#define FDCommonAlertViewMargin  (35)

#endif /* FDAlertViewCommonDef_h */
