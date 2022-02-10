//
//  UIView+UIBorder.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, FDUIViewBorderPosition) {
    FDUIViewBorderPositionNone      = 0,
    FDUIViewBorderPositionTop       = 1 << 0,
    FDUIViewBorderPositionLeft      = 1 << 1,
    FDUIViewBorderPositionBottom    = 1 << 2,
    FDUIViewBorderPositionRight     = 1 << 3
};

typedef NS_ENUM(NSUInteger, FDUIViewBorderLocation) {
    FDUIViewBorderLocationInside,
    FDUIViewBorderLocationCenter,
    FDUIViewBorderLocationOutside
};

@interface UIView (UIBorder)

/// 边框的颜色，默认为UIColorSeparator。请注意修改 qmui_borderPosition 的值以将边框显示出来。
@property(nullable, nonatomic, strong) UIColor *fdui_borderColor;

/// 边框的大小，默认为PixelOne。请注意修改 fdui_borderPosition 的值以将边框显示出来。
@property(nonatomic, assign) CGFloat fdui_borderWidth;

/// 设置边框的位置，默认为 QMUIViewBorderLocationInside，与 view.layer.border 一致。
@property(nonatomic, assign) FDUIViewBorderLocation fdui_borderLocation;

/// 设置边框类型，支持组合，例如：`borderPosition = QMUIViewBorderPositionTop|QMUIViewBorderPositionBottom`。默认为 QMUIViewBorderPositionNone。
@property(nonatomic, assign) FDUIViewBorderPosition fdui_borderPosition;

/// 虚线 : dashPhase默认是0，且当dashPattern设置了才有效
/// qmui_dashPhase 表示虚线起始的偏移，qmui_dashPattern 可以传一个数组，表示“lineWidth，lineSpacing，lineWidth，lineSpacing...”的顺序，至少传 2 个。
@property(nonatomic, assign) CGFloat fdui_dashPhase;
@property(nullable, nonatomic, copy) NSArray<NSNumber *> *fdui_dashPattern;

/// border的layer
@property(nullable, nonatomic, strong, readonly) CAShapeLayer *fdui_borderLayer;

@end

NS_ASSUME_NONNULL_END
