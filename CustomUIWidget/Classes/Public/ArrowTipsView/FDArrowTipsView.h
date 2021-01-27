//
//  FDArrowTipsView.h
//  FunnyRecord
//
//  Created by hexiang on 2019/12/3.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FDArrowDirection) {
    FDArrowDirection_Top,
    FDArrowDirection_Bottom,
    FDArrowDirection_Left,
    FDArrowDirection_Right,
};

@interface FDArrowTipsViewConfig : NSObject

@property (nonatomic, assign) CGFloat  contentCornerRadius; ///> 内容区域view的圆角(不包含箭头的部分), 默认-1(表示实际高度的一半), 设置该值有限制条件，不能超过实际高度的一般，超过则默认取一半
@property (nonatomic, assign) UIEdgeInsets  contentEdgeInsets;  ///> 内容view的间距（默认[10, 10, 10, 10]）, 表示自定义view离箭头容器上下左右的距离

@property (nonatomic, strong) CAGradientLayer *gradientBackgroundLayer; ///> 渐变层，可根据提供的工具函数生成传入，有默认渐变颜色的配置

@property (nonatomic, assign) FDArrowDirection  originDirection;    ///> 初始的箭头指向，默认top
@property (nonatomic, assign) CGSize  arrowSize;    ///> 渐变结束点，默认[8, 8]

// 工具方法--根据不同颜色生成配置中需要的渐变层
+ (CAGradientLayer *)gradientLayerSingleColor:(UIColor *)color;

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors;

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint;

@end

// 箭头操作行为类型
typedef NS_ENUM(NSUInteger, FDArrowTipsViewActionType) {
    FDArrowTipsViewActionTypeClick,     // 点击箭头view(不包含中间自定义view的点击)
    // 设置了定时器功能时，定时器超时的回调
    FDArrowTipsViewActionTypeTimeOut,
    // 设置了动画功能时，启动动画结束和调用dismissTipsView时view将移除时的回调
    FDArrowTipsViewActionTypeShowAnimationEnd,
    FDArrowTipsViewActionTypeDismissAnimationEnd,
};

@class FDArrowTipsView;
typedef void(^arrowTipsViewActionBlock)(FDArrowTipsView *arrowTipsView, FDArrowTipsViewActionType actionType);

@interface FDArrowTipsView : UIView

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDArrowTipsViewConfig *)config andCustomView:(UIView *)customView;

@property (nonatomic, strong, readonly) FDArrowTipsViewConfig *viewConfig;  ///> 配置参数

@property (nonatomic, assign) CGFloat  arrowCenterOffset;  ///> 设置箭头中点的位置(触发重新绘制)，左右箭头为y值，上下箭头为x值

@property (nonatomic, assign) FDArrowDirection  direction; ///> 实际指向方向，初始时等于配置参数里的方向，重新设置该值的话，箭头方向即可根据设定值改变

@property (nonatomic, strong) arrowTipsViewActionBlock actionBlock; ///> 操作block

@property (nonatomic, strong) UIBezierPath *customBezierPath; ///> 特殊需求，自定义设置绘制路径

/// 获取实际的cornerRadius
- (CGFloat)getCornerRadius;

/// 启动定时器功能
/// @param time 时长
- (void)startShowTimerWithTime:(NSTimeInterval)time autoDismiss:(BOOL)autoDismiss;

/// 启动默认显示动画功能(放大 0.4-1.0， 托名都0.4-1.0)
- (void)startViewAnimation:(CGFloat)animationTime;

/// 启动默认消失动画功能
- (void)dismissTipsView:(CGFloat)animationTime autoRemove:(BOOL)autoRemove;

@end

NS_ASSUME_NONNULL_END
