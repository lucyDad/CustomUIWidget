//
//  FDCommonAlertView.h
//  funnydate
//
//  Created by hexiang on 2019/3/30.
//  Copyright © 2019 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDAlertViewCommonDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDCommonAlertViewConfig : NSObject

@property (nonatomic, strong) NSString *title;  ///> 有title的样式没有关闭按钮，同时默认底部按钮只显示一个

@property (nonatomic, strong) NSString *confirmTitle;
@property (nonatomic, strong) NSString *confirmSubTitle;
@property (nonatomic, strong) NSString *cancelTitle;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSAttributedString *attributedContent; ///> 自己定义的attributedContent

@property (nonatomic, strong) NSString *subContent; // 子内容(排版位于内容之下，属性目前不可配置，如需要可开放)
@property (nonatomic, strong) NSAttributedString *subAttributedContent; ///> 自己定义的attributedContent

@property (nonatomic, assign) BOOL  isNeedCloseButton; ///> 是否需要关闭按钮（默认-NO）
@property (nonatomic, assign) BOOL  isOnlyConfirmButton; ///> 是否只有确认按钮（默认-NO）

@property (nonatomic, assign) BOOL  isNeedTimer;    ///> 是否需要按钮显示定时（默认-NO）
@property (nonatomic, assign) NSInteger  countDownTime; ///> 按钮倒计时的总时长s（默认-15）
@property (nonatomic, assign) BOOL  isTimerInCancelButton; ///> 倒计时是否显示在取消按钮上（默认-NO, 即显示在确认按钮上）

@end

@class FDCommonAlertView;
typedef void(^FDCommonAlertViewClickBlock)(FDCommonAlertView *popView, FDAlertViewClickType clickType);

@interface FDCommonAlertView : UIView

@property (nonatomic, strong) FDCommonAlertViewClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDCommonAlertViewConfig *)config customView:(UIView * __nullable)customView;

@end

NS_ASSUME_NONNULL_END
