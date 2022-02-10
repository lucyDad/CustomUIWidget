//
//  FDImageLabelView.h
//  funnydate
//
//  Created by hexiang on 2021/11/29.
//  Copyright © 2021 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FDImagePositionStyle) {
    /// 图片在左，文字在右
    FDImagePositionStyleDefault,
    /// 图片在右，文字在左
    FDImagePositionStyleRight,
    /// 图片在上，文字在下
    FDImagePositionStyleTop,
    /// 图片在下，文字在上
    FDImagePositionStyleBottom,
};

@interface FDImageLabelView : UIView

@property (nonatomic, assign) CGFloat  spacing;
@property (nonatomic, assign) FDImagePositionStyle  style;
@property (nonatomic, assign) UIEdgeInsets  contentEdgeInsets;
@property (nonatomic, assign) BOOL  isRelyOnImage; // 默认YES,设置为NO，则最终高度或宽度依赖label和image的最大值(只针对左右样式)

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) NSString *text;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
