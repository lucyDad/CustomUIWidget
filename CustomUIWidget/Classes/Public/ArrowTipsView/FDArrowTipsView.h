//
//  FDArrowTipsView.h
//  FunnyRecord
//
//  Created by hexiang on 2019/12/3.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const gArrowTipsViewMarginOffset;

typedef NS_ENUM(NSInteger, FDArrowDirection) {
    FDArrowDirection_Top,
    FDArrowDirection_Bottom,
    FDArrowDirection_Left,
    FDArrowDirection_Right,
};

@interface FDArrowTipsViewConfig : NSObject

@property (nonatomic, assign) CGFloat  contentCornerRadius; ///> 内容区域view的圆角(不包含箭头的部分), 默认-1(表示实际高度的一半), 设置该值有限制条件，不能超过实际高度的一般，超过则默认取一半
@property (nonatomic, assign) UIEdgeInsets  contentEdgeInsets;  ///> 内容view的间距（默认[2,2,2,2]）, 表示自定义view离箭头容器上下左右的距离

@property (nonatomic, strong) CAGradientLayer *gradientBackgroundLayer; ///> 渐变层，可根据提供的工具函数生成传入，有默认渐变颜色的配置

@property (nonatomic, assign) FDArrowDirection  originDirection;    ///> 初始的箭头指向，默认top
@property (nonatomic, assign) CGSize  arrowSize;    ///> 渐变结束点，默认[8, 8]

// 高级使用属性
@property (nonatomic, assign) BOOL  autoTimeOutClose;  ///> 是否超时自动关闭（默认NO）
@property (nonatomic, assign) BOOL  isStartTimer;   ///> 是否启动定时器（默认NO）
@property (nonatomic, assign) NSInteger  timeOutTime;   ///> 定时器超时的时长（默认3s）

@property (nonatomic, assign) CGFloat  animationTime;   ///> 动画的时长（默认0.5s）

// 供外部封装使用
@property (nonatomic, assign) BOOL  autoAdjustPos;  ///> 是否自动调整显示位置（默认NO）,自动调整即根据相应的点的位置和箭头view是否在view内来进行，不适用极端情况（很大的view或很小的父view）
@property (nonatomic, assign) CGFloat  fixedOffset; ///> 默认0.0(表示默认偏移不固定), 设置了此值的话，则箭头偏移为固定值

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors;

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint;

@end

typedef NS_ENUM(NSUInteger, FDArrowTipsViewActionType) {
    FDArrowTipsViewActionTypeClick,
    FDArrowTipsViewActionTypeTimeOut,
    FDArrowTipsViewActionTypeAnimationEnd,
    FDArrowTipsViewActionTypeWillRemove,
};

@class FDArrowTipsView;
typedef BOOL(^arrowTipsViewActionBlock)(FDArrowTipsView *arrowTipsView, FDArrowTipsViewActionType actionType);

@interface FDArrowTipsView : UIView

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDArrowTipsViewConfig *)config andCustomView:(UIView *)customView;

@property (nonatomic, strong, readonly) FDArrowTipsViewConfig *viewConfig;

@property (nonatomic, assign) CGFloat  arrowCenterXOffset;
@property (nonatomic, assign) CGFloat  arrowCenterYOffset;
@property (nonatomic, assign) FDArrowDirection  direction; ///> 实际指向方向，初始时等于配置参数里的方向，重新设置该值的话，箭头方向即可根据设定值改变

@property (nonatomic, strong) arrowTipsViewActionBlock actionBlock;

- (void)startShowTimerWithTime:(NSTimeInterval)time;

- (void)startViewAnimation;

- (void)dismissTipsView;

- (CGFloat)getCornerRadius;

@end

NS_ASSUME_NONNULL_END
