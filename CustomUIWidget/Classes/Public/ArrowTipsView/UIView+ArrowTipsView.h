//
//  UIView+ArrowTipsView.h
//  FunnyRecord
//
//  Created by hexiang on 2019/12/6.
//  Copyright © 2019 HeXiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FDArrowTipsView.h"
#import "FDArrowCustomListView.h"
#import "FDAnimationManagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ArrowTipsView)

/// 显示箭头view （默认配置，自定计算宽高）
/// @param attrText 需要显示的attrText
/// @param point 箭头指向的点
- (void)showArrowTipsViewWithText:(NSAttributedString *)attrText andArrowPoint:(CGPoint)point;

/// 根据传入配置显示列表内容的箭头view
/// @param config 箭头view相关的配置选项
/// @param attrText 需要显示的attrText
/// @param realSize 整体view的大小，传入0就表示根据文本自动适应
/// @param point 箭头指向的点
/// @param block 相关操作的回调
- (void)showArrowTipsViewWithConfig:(FDArrowTipsViewConfig *)config
                            andText:(NSAttributedString *)attrText
                        andRealSize:(CGSize)realSize
                      andArrowPoint:(CGPoint)point
                     andActionBlock:(nullable arrowTipsViewActionBlock)block;

+ (NSMutableAttributedString *)defaultArrowTipsViewAttributedString:(NSString *)text;

/// 根据传入配置显示列表内容的自带整个父view大小背景的箭头view
/// @param config 箭头view相关的配置选项
/// @param attrText 需要显示的attrText
/// @param realSize 整体view的大小，传入0就表示根据文本自动适应
/// @param point 箭头指向的点
/// @param block 相关操作的回调
- (void)showArrowTipsBackgroundViewWithConfig:(FDArrowTipsViewConfig *)config
                                      andText:(NSAttributedString *)attrText
                                  andRealSize:(CGSize)realSize
                                andArrowPoint:(CGPoint)point
                               andActionBlock:(nullable arrowTipsViewActionBlock)block;

@end

NS_ASSUME_NONNULL_END
