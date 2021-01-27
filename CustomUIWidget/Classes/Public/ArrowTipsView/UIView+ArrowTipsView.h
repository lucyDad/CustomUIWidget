//
//  UIView+ArrowTipsView.h
//  FunnyRecord
//
//  Created by hexiang on 2019/12/6.
//  Copyright © 2019 HeXiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FDArrowTipsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ArrowTipsView)

/// 根据传入配置显示列表内容的箭头view
/// @param config 配置信息
/// @param attrText 需要显示的attrText
/// @param realSize 整体view的固定大小，传入0就表示根据文本自动适应
/// @param block 相关操作的回调
- (FDArrowTipsView *)showArrowTipsViewWithConfig:(FDArrowTipsViewConfig *)config
                                         andText:(NSAttributedString *)attrText
                                     andRealSize:(CGSize)realSize
                                  andActionBlock:(nullable arrowTipsViewActionBlock)block;

/// 根据传入配置以及自定义view显示箭头view
/// @param customView 自定义view
/// @param config 配置信息
/// @param block 相关操作的回调
- (FDArrowTipsView *)showCustomArrowTipsView:(UIView *)customView
                                   andConfig:(FDArrowTipsViewConfig *)config
                              andActionBlock:(arrowTipsViewActionBlock)block;

@end

NS_ASSUME_NONNULL_END
