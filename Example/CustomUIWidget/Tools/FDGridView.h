//
//  FDGridView.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDGridView : UIView

/// 指定要显示的列数，默认为 0
@property(nonatomic, assign) NSInteger columnCount;

/// 指定每一行的高度，默认为 0
@property(nonatomic, assign) CGFloat rowHeight;

/// 内部的 padding，默认为 UIEdgeInsetsZero
@property(nonatomic, assign) UIEdgeInsets padding;

/// 指定 item 之间的分隔线宽度，默认为 0
@property(nonatomic, assign) CGFloat separatorWidth;

/// 指定 item 之间的分隔线颜色，默认为 UIColorSeparator
@property(nonatomic, strong) UIColor *separatorColor;

/// item 之间的分隔线是否要用虚线显示，默认为 NO
@property(nonatomic, assign) BOOL separatorDashed;

@end

NS_ASSUME_NONNULL_END
