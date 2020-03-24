//
//  UIView+ArrowTipsView.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/6.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "UIView+ArrowTipsView.h"
#import "FDCustomUIWidgetDef.h"

#define ArrowTipsViewZoneInOffset(v, a, b) ( v < a ? a : (v > b ? b : v))

@implementation UIView (ArrowTipsView)

- (void)showArrowTipsViewWithText:(NSAttributedString *)attrText andArrowPoint:(CGPoint)point {

    [self showArrowTipsViewWithConfig:[FDArrowTipsViewConfig new] andText:attrText andRealSize:CGSizeZero andArrowPoint:point andActionBlock:nil];
}

- (void)showArrowTipsViewWithConfig:(FDArrowTipsViewConfig *)config
                            andText:(NSAttributedString *)attrText
                        andRealSize:(CGSize)realSize
                      andArrowPoint:(CGPoint)point
                     andActionBlock:(nullable arrowTipsViewActionBlock)block {

    CGSize containerSize = [self getLabelContainerSize:config realSize:realSize];
    YYLabel *label = [self createYYLabelWithAttrText:attrText containerSize:containerSize];
    
    FDArrowTipsView *tipsView = [self showCustomArrowTipsView:label andConfig:config andArrowPoint:point andActionBlock:block];
    @weakify(tipsView);
    label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(tipsView);
        [tipsView dismissTipsView];
    };
}

- (FDArrowTipsView *)showCustomArrowTipsView:(UIView *)customView
                                   andConfig:(FDArrowTipsViewConfig *)config
                               andArrowPoint:(CGPoint)point
                              andActionBlock:(arrowTipsViewActionBlock)block {
    FDArrowTipsView *tipsView = [[FDArrowTipsView alloc] initWithFrame:CGRectZero andConfig:config andCustomView:customView];

    [self updatePositionWithTipsView:tipsView point:point];
    
    if (config.isStartTimer) {
        [tipsView startShowTimerWithTime:config.timeOutTime];
    }
    
    if (config.animationTime != 0.0f) {
        [tipsView startViewAnimation];
    }

    tipsView.actionBlock = ^BOOL(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        LOGGO_INFO(@"actionType = %zd", actionType);
        BOOL result = YES;
        if (block) {
            result = block(arrowTipsView, actionType);
        }
        if (result) {
           switch (actionType) {
                case FDArrowTipsViewActionTypeClick:
                {
                    [arrowTipsView dismissTipsView];
                    break;
                }
                default:
                    break;
            }
        }
        return YES;
    };
    [self addSubview:tipsView];
    return tipsView;
}

#pragma mark - 带背景的显示方式

- (void)showArrowTipsBackgroundViewWithConfig:(FDArrowTipsViewConfig *)config
                                      andText:(NSAttributedString *)attrText
                                  andRealSize:(CGSize)realSize
                                andArrowPoint:(CGPoint)point
                               andActionBlock:(arrowTipsViewActionBlock)block {

    CGSize containerSize = [self getLabelContainerSize:config realSize:realSize];
    YYLabel *label = [self createYYLabelWithAttrText:attrText containerSize:containerSize];
    
    FDAnimationManagerView *managerView = [self showArrowTipsBackgroundViewWithConfig:config withCustomView:label point:point];
    @weakify(managerView);
    label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(managerView);
        FDArrowTipsView *tipsView = (FDArrowTipsView *)managerView.config.animationContainerView;
        [tipsView dismissTipsView];
    };
}

- (FDAnimationManagerView *)showArrowTipsBackgroundViewWithConfig:(FDArrowTipsViewConfig *)config
                                  withCustomView:(UIView *)customView
                                           point:(CGPoint)point {
    
    FDArrowTipsView *tipsView = [[FDArrowTipsView alloc] initWithFrame:CGRectZero andConfig:config andCustomView:customView];
    [self updatePositionWithTipsView:tipsView point:point];
    
    FDAnimationManagerViewConfig *animationConfig = [FDAnimationManagerViewConfig new];
    animationConfig.backgroundColor = [UIColor clearColor];
    animationConfig.isNeedAnimation = NO;
    animationConfig.animationContainerView = tipsView;
    animationConfig.managerType = FDAnimationManagerShowTypeMiddle;
    animationConfig.centerPoint = CGPointMake(CGRectGetMinX(tipsView.frame) + tipsView.width / 2.0f, CGRectGetMinY(tipsView.frame) + tipsView.height / 2.0f);
    FDAnimationManagerView *managerView = [[FDAnimationManagerView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) andConfig:animationConfig];
    [managerView showAnimationManagerView:nil];
    
    @weakify(tipsView);
    managerView.clickBackgroundBlock = ^(FDAnimationManagerView *animationView) {
        @strongify(tipsView);
        [tipsView dismissTipsView];
    };
    
    if (config.isStartTimer) {
        [tipsView startShowTimerWithTime:config.timeOutTime];
    }
    
    if (config.animationTime != 0.0f) {
        [tipsView startViewAnimation];
    }
    
    @weakify(managerView);
    tipsView.actionBlock = ^BOOL(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        @strongify(managerView);
        LOGGO_INFO(@"actionType = %zd", actionType);
        switch (actionType) {
            case FDArrowTipsViewActionTypeClick:
            {
                [arrowTipsView dismissTipsView];
                break;
            }
            case FDArrowTipsViewActionTypeWillRemove:
            {
                [managerView dismissAnimationManagerView:nil];
                break;
            }
            default:
                break;
        }
        return YES;
    };
    [self addSubview:managerView];
    return managerView;
}

#pragma mark - 显示调整

- (void)updatePositionWithTipsView:(FDArrowTipsView *)view point:(CGPoint)point {
    if (view.viewConfig.autoAdjustPos) {
        LOGGO_INFO(@">>>自动调整开始");
        if ([self __isNeedChangeDirection:view point:point]) {
            
        }
    }
    
    BOOL isSpecialHandle = [self __updateAdjustTipsViewPosition:view point:point];
    if ( !isSpecialHandle && 0.0 != view.viewConfig.fixedOffset) {
        [self __updateTipsViewPositionWithFixedOffset:view point:point];
    }
}

- (BOOL)updateHorizontalDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    // 水平方向自动调整
    BOOL isSpecialHandle = NO;
    CGSize viewSize = tipsView.size;
    CGFloat allLength = viewSize.width;
    CGFloat defaultCenter = allLength / 2.0f;
    // 根据point在水平三个区域调整箭头位置
    CGFloat offset = point.x;
    if (offset < allLength / 2.0f) {
        tipsView.left = 0;
        defaultCenter = offset;
        isSpecialHandle = YES;
    } else if (offset > self.width - allLength / 2.0f) {
        tipsView.left = self.width - allLength;
        defaultCenter = tipsView.left + offset;
        isSpecialHandle = YES;
    } else {
        tipsView.left = offset - allLength / 2.0f;
    }
    tipsView.arrowCenterXOffset = defaultCenter;
    return isSpecialHandle;
}

- (BOOL)updateVerticalDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    // 垂直方向自动调整
    BOOL isSpecialHandle = NO;
    CGSize viewSize = tipsView.size;
    CGFloat defaultCenter = viewSize.height / 2.0f;
    // 根据point在水平三个区域调整箭头位置
    if (point.y < viewSize.height / 2.0f) {
        tipsView.top = 0;
        defaultCenter = point.y;
        isSpecialHandle = YES;
    } else if (point.y > self.height - viewSize.height / 2.0f) {
        tipsView.top = self.height - viewSize.height;
        defaultCenter =  point.y - tipsView.top;
        isSpecialHandle = YES;
    } else {
        tipsView.top = point.y - viewSize.height / 2.0f;
    }
    tipsView.arrowCenterYOffset = defaultCenter;
    return isSpecialHandle;
}

- (BOOL)__updateAdjustTipsViewPosition:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    BOOL isSpecialHandle = NO;
    LOGGO_INFO(@">>>更新tipsView坐标，direction = %zd", tipsView.direction);
    switch (tipsView.direction) {
        case FDArrowDirection_Top:
        {
            isSpecialHandle = [self updateHorizontalDirection:tipsView point:point];
            tipsView.top = point.y;
            break;
        }
        case FDArrowDirection_Bottom:
        {
            isSpecialHandle = [self updateHorizontalDirection:tipsView point:point];
            CGSize viewSize = tipsView.size;
            tipsView.top = point.y - viewSize.height;
            break;
        }
        case FDArrowDirection_Left:
        {
            isSpecialHandle = [self updateVerticalDirection:tipsView point:point];
            tipsView.left = point.x;
            break;
        }
        case FDArrowDirection_Right:
        {
            isSpecialHandle = [self updateVerticalDirection:tipsView point:point];
            CGSize viewSize = tipsView.size;
            tipsView.left = point.x - viewSize.width;
            break;
        }
        default:
            break;
    }
    return isSpecialHandle;
}

- (void)__updateTipsViewPositionWithFixedOffset:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    LOGGO_INFO(@">>>根据固定偏移更新坐标，direction = %zd", tipsView.direction);
    CGFloat offset = tipsView.viewConfig.fixedOffset;
    CGFloat width = tipsView.viewConfig.contentCornerRadius + gArrowTipsViewMarginOffset;
    switch (tipsView.direction) {
        case FDArrowDirection_Top:
        {
            width += tipsView.viewConfig.arrowSize.width / 2.0f;
            CGFloat arrowCenterXOffset = ArrowTipsViewZoneInOffset(offset, width, tipsView.width - width);
            tipsView.top = point.y;
            tipsView.left = point.x - arrowCenterXOffset;
            tipsView.arrowCenterXOffset = arrowCenterXOffset;
            break;
        }
        case FDArrowDirection_Bottom:
        {
            CGFloat arrowCenterXOffset = ArrowTipsViewZoneInOffset(offset, width, tipsView.width - width);
            tipsView.top = point.y - tipsView.height;
            tipsView.left = point.x - arrowCenterXOffset;
            tipsView.arrowCenterXOffset = arrowCenterXOffset;
            break;
        }
        case FDArrowDirection_Left:
        {
            width += tipsView.viewConfig.arrowSize.height / 2.0f;
            CGFloat arrowCenterYOffset = ArrowTipsViewZoneInOffset(offset, width, tipsView.height - width);
            tipsView.left = point.x;
            tipsView.top = point.y - arrowCenterYOffset;
            tipsView.arrowCenterYOffset = arrowCenterYOffset;
            break;
        }
        case FDArrowDirection_Right:
        {
            width += tipsView.viewConfig.arrowSize.height / 2.0f;
            CGFloat arrowCenterYOffset = ArrowTipsViewZoneInOffset(offset, width, tipsView.height - width);
            tipsView.left = point.x - tipsView.width;
            tipsView.top = point.y - arrowCenterYOffset;
            tipsView.arrowCenterYOffset = arrowCenterYOffset;
            break;
        }
        default:
            break;
    }
}

#pragma mark - 位置信息

/// 是否位于四个死角的位置（点位于死角事，没办法对其自动纠正箭头指向，需要排除掉）
/// @param tipsView 箭头view
/// @param point 当前点的位置
- (BOOL)__isDeadAngleInSuperView:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    CGFloat border = 1;
    CGFloat width = tipsView.viewConfig.contentCornerRadius + gArrowTipsViewMarginOffset + 2 * border;
    CGRect leftTopCorner = CGRectMake(-border, -border, width, width);
    CGRect leftBottomCorner = CGRectMake(-border, self.height - width + border, width, width);
    CGRect rightTopCorner = CGRectMake(self.width - width - border, -border, width, width);
    CGRect rightBottomCorner = CGRectMake(self.width - width - border, self.height - width + border, width, width);
    if (CGRectContainsPoint(leftTopCorner, point) ||
        CGRectContainsPoint(rightTopCorner, point) ) {
        LOGGO_INFO(@">>>点位于死角, 默认方向 上");
        tipsView.direction = FDArrowDirection_Top;
        return YES;
    } else if (CGRectContainsPoint(leftBottomCorner, point) || CGRectContainsPoint(rightBottomCorner, point) ) {
        LOGGO_INFO(@">>>点位于死角, 默认方向 下");
        tipsView.direction = FDArrowDirection_Bottom;
        return YES;
    }
    return NO;
}

- (BOOL)updateArrowTopDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    CGFloat width = [tipsView getCornerRadius] + gArrowTipsViewMarginOffset;
    CGRect leftSpecialZone = CGRectMake(0, 0, width, self.height);
    CGRect rightSpecialZone = CGRectMake(self.width - width, 0, width, self.height);
    CGRect bottomSpecialZone = CGRectMake(0, self.height - width, self.width, tipsView.height);
    
    BOOL result = NO;
    if (CGRectContainsPoint(leftSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Left;
        LOGGO_INFO(@">>>需要变更方向 上--->左");
    } else if ( CGRectContainsPoint(rightSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Right;
        LOGGO_INFO(@">>>需要变更方向 上--->右");
    } else if ( CGRectContainsPoint(bottomSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Bottom;
        LOGGO_INFO(@">>>需要变更方向 上--->下");
    }
    return result;
}

- (BOOL)updateArrowBottomDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    CGFloat width = [tipsView getCornerRadius] + gArrowTipsViewMarginOffset;
    CGRect leftSpecialZone = CGRectMake(0, 0, width, self.height);
    CGRect rightSpecialZone = CGRectMake(self.width - width, 0, width, self.height);
    CGRect topSpecialZone = CGRectMake(0, 0, self.width, tipsView.height);
    
    BOOL result = NO;
    if (CGRectContainsPoint(leftSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Left;
        LOGGO_INFO(@">>>需要变更方向 下--->左");
    } else if ( CGRectContainsPoint(rightSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Right;
        LOGGO_INFO(@">>>需要变更方向 下--->右");
    } else if ( CGRectContainsPoint(topSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Top;
        LOGGO_INFO(@">>>需要变更方向 下--->上");
    }
    return result;
}

- (BOOL)updateArrowLeftDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    CGFloat width = [tipsView getCornerRadius] + tipsView.viewConfig.arrowSize.width;
    CGRect rightSpecialZone = CGRectMake(self.width - width, 0, width, self.height);
    CGFloat height = tipsView.height / 2.0f;
    CGRect topSpecialZone = CGRectMake(0, 0, self.width, height);
    CGRect bottomSpecialZone = CGRectMake(0, self.height - height, self.width, height);
    
    BOOL result = NO;
    if (CGRectContainsPoint(topSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Top;
        LOGGO_INFO(@">>>需要变更方向 左--->上");
    } else if ( CGRectContainsPoint(bottomSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Bottom;
        LOGGO_INFO(@">>>需要变更方向 左--->下");
    } else if ( CGRectContainsPoint(rightSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Right;
        LOGGO_INFO(@">>>需要变更方向 左--->右");
    }
    return result;
}

- (BOOL)updateArrowRightDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    CGFloat width = [tipsView getCornerRadius] + tipsView.viewConfig.arrowSize.width;
    CGRect leftSpecialZone = CGRectMake(0, 0, width, self.height);
    CGFloat height = tipsView.height / 2.0f;
    CGRect topSpecialZone = CGRectMake(0, 0, self.width, height);
    CGRect bottomSpecialZone = CGRectMake(0, self.height - height, self.width, height);

    BOOL result = NO;
    if (CGRectContainsPoint(topSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Top;
        LOGGO_INFO(@">>>需要变更方向 右--->上");
    } else if ( CGRectContainsPoint(bottomSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Bottom;
        LOGGO_INFO(@">>>需要变更方向 右--->下");
    } else if ( CGRectContainsPoint(leftSpecialZone, point) ) {
        result = YES;
        tipsView.direction = FDArrowDirection_Left;
        LOGGO_INFO(@">>>需要变更方向 右--->左");
    }
    return result;
}

- (BOOL)__isNeedChangeDirection:(FDArrowTipsView *)tipsView point:(CGPoint)point {
    
    if ([self __isDeadAngleInSuperView:tipsView point:point]) {
        return NO;
    }
    BOOL result = NO;
    switch (tipsView.direction) {
        case FDArrowDirection_Top:
        {
            result = [self updateArrowTopDirection:tipsView point:point];
            break;
        }
        case FDArrowDirection_Bottom:
        {
            result = [self updateArrowBottomDirection:tipsView point:point];
            break;
        }
        case FDArrowDirection_Left:
        {
            result = [self updateArrowLeftDirection:tipsView point:point];
            break;
        }
        case FDArrowDirection_Right:
        {
            result = [self updateArrowRightDirection:tipsView point:point];
            break;
        }
        default:
            break;
    }
    return result;
}

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

#pragma mark - 默认label的自定义view

+ (NSMutableAttributedString *)defaultArrowTipsViewAttributedString:(NSString *)text {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    attText.yy_font = FONT_REGULAR_WITH_SIZE(15);
    attText.yy_color = [UIColor whiteColor];
    attText.yy_alignment = NSTextAlignmentCenter;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attText;
}

- (YYLabel *)createYYLabelWithAttrText:(NSAttributedString *)attrText
                         containerSize:(CGSize)containerSize {

    YYLabel *label = [[YYLabel alloc] init];
    label.displaysAsynchronously = YES;
    label.fadeOnAsynchronouslyDisplay = NO;
    label.fadeOnHighlight = NO;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) insets:UIEdgeInsetsZero];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attrText];
    
    CGFloat equalValue = 0.0f;
    CGSize realSize = containerSize;
    if (containerSize.width == equalValue || containerSize.height == equalValue) {

        if (containerSize.width == equalValue && containerSize.height == equalValue ) {
            realSize = layout.textBoundingRect.size;
        } else if (containerSize.width == equalValue ) {
            realSize = CGSizeMake(layout.textBoundingRect.size.width, containerSize.height);
        } else if (containerSize.height == equalValue ) {
            realSize = CGSizeMake(containerSize.width, layout.textBoundingRect.size.height);
        }
    }
    label.textLayout = layout;
    label.size = realSize;
    return label;
}

@end
