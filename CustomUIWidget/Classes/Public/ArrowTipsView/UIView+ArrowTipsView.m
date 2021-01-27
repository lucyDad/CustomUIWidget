//
//  UIView+ArrowTipsView.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/6.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "UIView+ArrowTipsView.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import <libextobjc/extobjc.h>

@implementation UIView (ArrowTipsView)

- (FDArrowTipsView *)showArrowTipsViewWithConfig:(FDArrowTipsViewConfig *)config
                                         andText:(NSAttributedString *)attrText
                                     andRealSize:(CGSize)realSize
                                  andActionBlock:(nullable arrowTipsViewActionBlock)block {

    YYLabel *label = [self createYYLabelWithConfig:config andText:attrText andRealSize:realSize];
    
    FDArrowTipsView *tipsView = [self showCustomArrowTipsView:label andConfig:config andActionBlock:block];
    @weakify(tipsView);
    label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(tipsView);
        if (block) {
            block(tipsView, FDArrowTipsViewActionTypeClick);
        }
    };
    return tipsView;
}

- (FDArrowTipsView *)showCustomArrowTipsView:(UIView *)customView
                                   andConfig:(FDArrowTipsViewConfig *)config
                              andActionBlock:(arrowTipsViewActionBlock)block {
    
    FDArrowTipsView *tipsView = [[FDArrowTipsView alloc] initWithFrame:CGRectZero andConfig:config andCustomView:customView];
    tipsView.actionBlock = block;
    [self addSubview:tipsView];
    return tipsView;
}

#pragma mark - 创建YYLabel

/// 根据实际大小(如果长或者宽实际需要大小不足，则会根据文本自适应)来创建实际大小的Label
/// @param attrText 富文本
/// @param realSize 外部传入所需要的大小
- (YYLabel *)createYYLabelWithConfig:(FDArrowTipsViewConfig *)config
                             andText:(NSAttributedString *)attrText
                         andRealSize:(CGSize)realSize {

    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) insets:UIEdgeInsetsZero];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attrText];

    // 如果给定的容器大小太小才会根据文本自适应
    CGSize containerSize = [self getLabelContainerSize:config realSize:realSize];
    CGFloat equalValue = 0.0f;
    CGSize caculateSize = containerSize;
    if (containerSize.width == equalValue || containerSize.height == equalValue) {
        if (containerSize.width == equalValue && containerSize.height == equalValue ) {
            caculateSize = layout.textBoundingRect.size;
        } else if (containerSize.width == equalValue ) {
            caculateSize = CGSizeMake(layout.textBoundingRect.size.width, containerSize.height);
        } else if (containerSize.height == equalValue ) {
            caculateSize = CGSizeMake(containerSize.width, layout.textBoundingRect.size.height);
        }
    }
    // 创建Label
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, caculateSize.width, caculateSize.height)];
    label.displaysAsynchronously = NO;
    label.fadeOnAsynchronouslyDisplay = NO;
    label.fadeOnHighlight = NO;
    label.textLayout = layout;
    return label;
}

/// 根据中间内容实际大小获取总内容大小(最小为CGSizeZero)
/// @param config 配置
/// @param realSize 实际大小
- (CGSize)getLabelContainerSize:(FDArrowTipsViewConfig *)config realSize:(CGSize)realSize {
    CGSize containerSize = CGSizeZero;
    UIEdgeInsets edgetInsets = config.contentEdgeInsets;
    switch (config.originDirection) {
        case FDArrowDirection_Top:
        case FDArrowDirection_Bottom:
        {
            CGFloat width = realSize.width - edgetInsets.left - edgetInsets.right;
            CGFloat height = realSize.height - edgetInsets.top - edgetInsets.bottom - config.arrowSize.height;
            containerSize = CGSizeMake(MAX(width, 0.0f), MAX(height, 0.0f));
            break;
        }
        case FDArrowDirection_Left:
        case FDArrowDirection_Right:
        {
            CGFloat width = realSize.width - edgetInsets.left - edgetInsets.right - config.arrowSize.width;
            CGFloat height = realSize.height - edgetInsets.top - edgetInsets.bottom;
            containerSize = CGSizeMake(MAX(width, 0.0f), MAX(height, 0.0f));
            break;
        }
        default:
            break;
    }
    return containerSize;
}

@end
