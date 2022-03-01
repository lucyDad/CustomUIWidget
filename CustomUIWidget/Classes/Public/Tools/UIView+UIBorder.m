//
//  UIView+UIBorder.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import "UIView+UIBorder.h"
#import "CALayer+FDUI.h"
#import <Aspects/Aspects.h>
#import "FDUIHelper.h"
#import "FDCommonDefine.h"

@interface FDUIBorderLayer : CAShapeLayer

@property(nonatomic, weak) UIView *_weak_targetBorderView; // 反向持有view

@end

@implementation FDUIBorderLayer

- (void)layoutSublayers {
    [super layoutSublayers];
    if (!self._weak_targetBorderView) return;
    
    UIView *view = self._weak_targetBorderView;
    CGFloat borderWidth = self.lineWidth;

    CGFloat (^adjustsLocation)(CGFloat, CGFloat, CGFloat) = ^CGFloat(CGFloat inside, CGFloat center, CGFloat outside) {
        return view.fdui_borderLocation == FDUIViewBorderLocationInside ? inside : (view.fdui_borderLocation == FDUIViewBorderLocationCenter ? center : outside);
    };
    // 为了像素对齐而做的偏移(绘制时，计算的点是在每条线的中点)
    CGFloat lineOffset = adjustsLocation(borderWidth / 2.0, 0, -borderWidth / 2.0);
    // 两条相邻的边框连接的位置(根据位置从里到外的最大点范围)
    CGFloat lineCapOffset = adjustsLocation(0, borderWidth / 2.0, borderWidth);
    
    NSDictionary<NSString *, NSArray<NSValue *> *> *points = [self caculatePointData:lineOffset lineCapOffset:lineCapOffset];
    
    UIBezierPath *topPath = [UIBezierPath bezierPath];
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    
    CGFloat cornerRadius = view.layer.cornerRadius;
    if (cornerRadius > 0) {
        if (view.layer.fdui_originMaskedCorners) {
            [self generateMaskedCorner:topPath leftPath:leftPath bottomPath:bottomPath rightPath:rightPath cornerRadius:cornerRadius lineOffset:lineOffset points:points];
        } else {
            [self generateCornerRadius:topPath leftPath:leftPath bottomPath:bottomPath rightPath:rightPath cornerRadius:cornerRadius lineOffset:lineOffset];
        }
    } else {
        [self generateRectPath:topPath leftPath:leftPath bottomPath:bottomPath rightPath:rightPath points:points];
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL shouldShowTopBorder = (view.fdui_borderPosition & FDUIViewBorderPositionTop) == FDUIViewBorderPositionTop;
    BOOL shouldShowLeftBorder = (view.fdui_borderPosition & FDUIViewBorderPositionLeft) == FDUIViewBorderPositionLeft;
    BOOL shouldShowBottomBorder = (view.fdui_borderPosition & FDUIViewBorderPositionBottom) == FDUIViewBorderPositionBottom;
    BOOL shouldShowRightBorder = (view.fdui_borderPosition & FDUIViewBorderPositionRight) == FDUIViewBorderPositionRight;
    if (shouldShowTopBorder && ![topPath isEmpty]) {
        [path appendPath:topPath];
    }
    if (shouldShowLeftBorder && ![leftPath isEmpty]) {
        [path appendPath:leftPath];
    }
    if (shouldShowBottomBorder && ![bottomPath isEmpty]) {
        [path appendPath:bottomPath];
    }
    if (shouldShowRightBorder && ![rightPath isEmpty]) {
        [path appendPath:rightPath];
    }

    self.path = path.CGPath;
}

- (NSDictionary<NSString *, NSArray<NSValue *> *> *)caculatePointData:(CGFloat)lineOffset
                                                        lineCapOffset:(CGFloat)lineCapOffset {
    UIView *view = self._weak_targetBorderView;
    
    BOOL shouldShowTopBorder = (view.fdui_borderPosition & FDUIViewBorderPositionTop) == FDUIViewBorderPositionTop;
    BOOL shouldShowLeftBorder = (view.fdui_borderPosition & FDUIViewBorderPositionLeft) == FDUIViewBorderPositionLeft;
    BOOL shouldShowBottomBorder = (view.fdui_borderPosition & FDUIViewBorderPositionBottom) == FDUIViewBorderPositionBottom;
    BOOL shouldShowRightBorder = (view.fdui_borderPosition & FDUIViewBorderPositionRight) == FDUIViewBorderPositionRight;
    
    // 计算绘制的点数据
    CGPoint topX = CGPointMake((shouldShowLeftBorder ? -lineCapOffset : 0), lineOffset);
    CGPoint topY = CGPointMake(CGRectGetWidth(self.bounds) + (shouldShowRightBorder ? lineCapOffset : 0) ,lineOffset);
    
    CGPoint leftX = CGPointMake(lineOffset, CGRectGetHeight(self.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0));
    CGPoint leftY = CGPointMake(lineOffset, (shouldShowTopBorder ? -lineCapOffset : 0));
    
    CGPoint bottomX = CGPointMake(CGRectGetWidth(self.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), CGRectGetHeight(self.bounds) - lineOffset);
    CGPoint bottomY = CGPointMake((shouldShowLeftBorder ? -lineCapOffset : 0), CGRectGetHeight(self.bounds) - lineOffset);
    
    CGPoint rightX = CGPointMake(CGRectGetWidth(self.bounds) - lineOffset, (shouldShowTopBorder ? -lineCapOffset : 0));
    CGPoint rightY = CGPointMake(CGRectGetWidth(self.bounds) - lineOffset, CGRectGetHeight(self.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0));
    
    NSDictionary<NSString *, NSArray<NSValue *> *> *points = @{
        @"toppath": @[
                [NSValue valueWithCGPoint:topX],
                [NSValue valueWithCGPoint:topY],
        ],
        @"leftpath": @[
                [NSValue valueWithCGPoint:leftX],
                [NSValue valueWithCGPoint:leftY],
        ],
        @"bottompath": @[
                [NSValue valueWithCGPoint:bottomX],
                [NSValue valueWithCGPoint:bottomY],
        ],
        @"rightpath": @[
                [NSValue valueWithCGPoint:rightX],
                [NSValue valueWithCGPoint:rightY],
        ],
    };
    
    return points;
}

- (void)generateRectPath:(UIBezierPath *)topPath
                leftPath:(UIBezierPath *)leftPath
              bottomPath:(UIBezierPath *)bottomPath
               rightPath:(UIBezierPath *)rightPath
                  points:(NSDictionary<NSString *, NSArray<NSValue *> *> *)points {
    
    [topPath moveToPoint:points[@"toppath"][0].CGPointValue];           // 左上角
    [topPath addLineToPoint:points[@"toppath"][1].CGPointValue];        // 右上角

    [leftPath moveToPoint:points[@"leftpath"][0].CGPointValue];         // 左下角
    [leftPath addLineToPoint:points[@"leftpath"][1].CGPointValue];      // 左上角

    [bottomPath moveToPoint:points[@"bottompath"][0].CGPointValue];     // 右下角
    [bottomPath addLineToPoint:points[@"bottompath"][1].CGPointValue];  // 左下角

    [rightPath moveToPoint:points[@"rightpath"][0].CGPointValue];       // 右上角
    [rightPath addLineToPoint:points[@"rightpath"][1].CGPointValue];    // 右下角
}

- (void)generateMaskedCorner:(UIBezierPath *)topPath
                    leftPath:(UIBezierPath *)leftPath
                  bottomPath:(UIBezierPath *)bottomPath
                   rightPath:(UIBezierPath *)rightPath
                cornerRadius:(CGFloat)cornerRadius
                  lineOffset:(CGFloat)lineOffset
                      points:(NSDictionary<NSString *, NSArray<NSValue *> *> *)points {
    
    CGFloat radius = cornerRadius - lineOffset;
    
    UIView *view = self._weak_targetBorderView;
    if ((view.layer.fdui_originMaskedCorners & kCALayerMinXMinYCorner) == kCALayerMinXMinYCorner) {
        [topPath addArcWithCenter:CGPointMake(cornerRadius , cornerRadius) radius:radius startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius , lineOffset)];
        [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:radius startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(self.bounds) - cornerRadius)];
    } else {
        [topPath moveToPoint:points[@"toppath"][0].CGPointValue];
        [topPath addLineToPoint:CGPointMake(points[@"toppath"][1].CGPointValue.x - cornerRadius, points[@"toppath"][1].CGPointValue.y)];
        [leftPath moveToPoint:CGPointMake(points[@"leftpath"][0].CGPointValue.x, points[@"leftpath"][0].CGPointValue.y - cornerRadius)];
        [leftPath addLineToPoint:points[@"leftpath"][1].CGPointValue];
    }
    
    if ((view.layer.fdui_originMaskedCorners & kCALayerMinXMaxYCorner) == kCALayerMinXMaxYCorner) {
        [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
        [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - lineOffset)];
    } else {
        [leftPath moveToPoint:points[@"leftpath"][0].CGPointValue];
        [leftPath addLineToPoint:CGPointMake(points[@"leftpath"][0].CGPointValue.x, points[@"leftpath"][0].CGPointValue.y - cornerRadius)];
        [bottomPath moveToPoint:points[@"bottompath"][1].CGPointValue];
        [bottomPath addLineToPoint:CGPointMake(points[@"bottompath"][0].CGPointValue.x - cornerRadius, points[@"bottompath"][0].CGPointValue.y)];
    }
    
    if ((view.layer.fdui_originMaskedCorners & kCALayerMaxXMaxYCorner) == kCALayerMaxXMaxYCorner) {
        [bottomPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
        [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - lineOffset, cornerRadius)];
    } else {
        [bottomPath addLineToPoint:points[@"bottompath"][0].CGPointValue];
        [rightPath moveToPoint:points[@"rightpath"][1].CGPointValue];
        [rightPath addLineToPoint:CGPointMake(points[@"rightpath"][0].CGPointValue.x, points[@"rightpath"][0].CGPointValue.y + cornerRadius)];
    }
    
    if ((view.layer.fdui_originMaskedCorners & kCALayerMaxXMinYCorner) == kCALayerMaxXMinYCorner) {
        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius , cornerRadius) radius:radius startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
        [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, cornerRadius) radius:radius startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
    } else {
        [rightPath addLineToPoint:points[@"rightpath"][0].CGPointValue];
        [topPath addLineToPoint:points[@"toppath"][1].CGPointValue];
    }
}

- (void)generateCornerRadius:(UIBezierPath *)topPath
                    leftPath:(UIBezierPath *)leftPath
                  bottomPath:(UIBezierPath *)bottomPath
                   rightPath:(UIBezierPath *)rightPath
                cornerRadius:(CGFloat)cornerRadius
                  lineOffset:(CGFloat)lineOffset {
    
    CGFloat radius = cornerRadius - lineOffset;
    
    [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:radius startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
    [topPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, lineOffset)];
    [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, cornerRadius) radius:radius startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
    
    [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:radius startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
    [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(self.bounds) - cornerRadius)];
    [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
    
    [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
    [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - lineOffset)];
    [bottomPath addArcWithCenter:CGPointMake(CGRectGetHeight(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
    
    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, CGRectGetHeight(self.bounds) - cornerRadius) radius:radius startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - lineOffset, cornerRadius)];
    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) - cornerRadius, cornerRadius) radius:radius startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
}

@end

@interface UIView ()
{
    
}
@property (nonatomic, strong) id<AspectToken> fdui_cornerRadiusToken;
@property (nonatomic, strong) id<AspectToken> fdui_maskedCornerToken;
@end

@implementation UIView (UIBorder)

FDUISynthesizeIdStrongProperty(fdui_cornerRadiusToken, setFdui_cornerRadiusToken)
FDUISynthesizeIdStrongProperty(fdui_maskedCornerToken, setFdui_maskedCornerToken)
FDUISynthesizeIdStrongProperty(fdui_borderLayer, setFdui_borderLayer)

#pragma mark - Property

- (void)setFdui_borderColor:(UIColor *)fdui_borderColor {
    objc_setAssociatedObject(self, @selector(fdui_borderColor), fdui_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    
    if (self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
}

- (UIColor *)fdui_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, _cmd);
}

- (void)setFdui_borderWidth:(CGFloat)fdui_borderWidth {
    BOOL valueChanged = self.fdui_borderWidth != fdui_borderWidth;
    objc_setAssociatedObject(self, @selector(fdui_borderWidth), @(fdui_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
    [self uiborderLog:@"%s excute valueChanged = %d, self.fdui_borderLayer = %@, self.fdui_borderLayer.hidden = %d", __func__, valueChanged, self.fdui_borderLayer, self.fdui_borderLayer.hidden];
}

- (CGFloat)fdui_borderWidth {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) floatValue];
}

- (void)setFdui_borderLocation:(FDUIViewBorderLocation)fdui_borderLocation {
    BOOL valueChanged = self.fdui_borderLocation != fdui_borderLocation;
    objc_setAssociatedObject(self, @selector(fdui_borderLocation), @(fdui_borderLocation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    
    if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
}

- (FDUIViewBorderLocation)fdui_borderLocation {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) unsignedIntegerValue];
}

- (void)setFdui_borderPosition:(FDUIViewBorderPosition)fdui_borderPosition {
    BOOL valueChanged = self.fdui_borderPosition != fdui_borderPosition;
    objc_setAssociatedObject(self, @selector(fdui_borderPosition), @(fdui_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    
    if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
}

- (FDUIViewBorderPosition)fdui_borderPosition {
    return [((NSNumber *)objc_getAssociatedObject(self, _cmd)) unsignedIntegerValue];
}

- (void)setFdui_dashPhase:(CGFloat)fdui_dashPhase {
    BOOL valueChanged = self.fdui_dashPhase != fdui_dashPhase;
    objc_setAssociatedObject(self, @selector(fdui_dashPhase), @(fdui_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    
    if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
}

- (CGFloat)fdui_dashPhase {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFdui_dashPattern:(NSArray<NSNumber *> *)fdui_dashPattern {
    BOOL valueChanged = [self.fdui_dashPattern isEqualToArray:fdui_dashPattern];
    objc_setAssociatedObject(self, @selector(fdui_dashPattern), fdui_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _fduiborder_createBorderLayerIfNeeded];
    
    if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
        [self setNeedsLayout];
    }
}

- (NSArray<NSNumber *> *)fdui_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Private Method

- (void)_fduiborder_createBorderLayerIfNeeded {
    // 是否需要创建边框: 1. 边框宽度; 2. 边框颜色; 3. 边框位置
    BOOL shouldShowBorder = self.fdui_borderWidth > 0 && self.fdui_borderColor && self.fdui_borderPosition != FDUIViewBorderPositionNone;
    if (!shouldShowBorder) {
        self.fdui_borderLayer.hidden = YES;
        return;
    }
    
    // CALayerDelegate layoutSublayersOfLayer: Tells the delegate a layer's bounds have changed.
    [self aspect_hookSelector:@selector(layoutSublayersOfLayer:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        
        UIView *selfObject = [info instance];
        [self uiborderLog:@"layoutSublayersOfLayer instance = %p", selfObject];
        
        if (!selfObject.fdui_borderLayer || selfObject.fdui_borderLayer.hidden)
            return;
        selfObject.fdui_borderLayer.frame = selfObject.bounds;
        [selfObject.layer fdui_bringSublayerToFront:selfObject.fdui_borderLayer];
        // 把布局刷新逻辑剥离到 layer 内，方便在子线程里直接刷新 layer，如果放在 UIView 内，子线程里就无法主动请求刷新了
        [selfObject.fdui_borderLayer setNeedsLayout];
    } error:NULL];
    
    // 禁用隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (!self.fdui_borderLayer) {
        FDUIBorderLayer *layer = [FDUIBorderLayer layer];
        layer._weak_targetBorderView = self;
        layer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        self.fdui_borderLayer = layer;
        
        [self observerLayerCornerRadius];
        [self observerLayerMaskedCorner];
    }
    self.fdui_borderLayer.lineWidth = self.fdui_borderWidth;
    self.fdui_borderLayer.strokeColor = self.fdui_borderColor.CGColor;
    self.fdui_borderLayer.lineDashPhase = self.fdui_dashPhase;
    self.fdui_borderLayer.lineDashPattern = self.fdui_dashPattern;
    self.fdui_borderLayer.hidden = NO;
    
    [CATransaction commit];
}

/// 监测Layer的半径变化
- (void)observerLayerCornerRadius {
    if (nil != self.fdui_cornerRadiusToken) {
        [self.fdui_cornerRadiusToken remove];
    }
    NSError *error = nil;
    self.fdui_cornerRadiusToken = [self.layer aspect_hookSelector:@selector(setCornerRadius:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        
        CALayer *selfObject = [info instance];
        NSArray *params = [info arguments];
        CGFloat cornerRadius = [[params firstObject] floatValue];
        // flat 处理，避免浮点精度问题
        BOOL valueChanged = flat(selfObject.fdui_originCornerRadius) != flat(cornerRadius);
        // 更新layer值
        selfObject.fdui_originCornerRadius = cornerRadius;
        //
        if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
            [self.fdui_borderLayer setNeedsLayout];
        }
    } error:&error];
    
    if (error) {
        [self uiborderLog:@"ERROR: Aspect setCornerRadius error = %@", error];
    }
}

/// 监测Layer的maskedCorners变化
- (void)observerLayerMaskedCorner {
    if (nil != self.fdui_maskedCornerToken) {
        [self.fdui_maskedCornerToken remove];
    }
    NSError *error = nil;
    self.fdui_maskedCornerToken = [self.layer aspect_hookSelector:@selector(setMaskedCorners:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        
        CALayer *selfObject = [info instance];
        NSArray *params = [info arguments];
        NSUInteger maskedCorner = [[params firstObject] unsignedIntValue];
        // flat 处理，避免浮点精度问题
        BOOL valueChanged = selfObject.fdui_originMaskedCorners != maskedCorner;
        // 更新layer值
        selfObject.fdui_originMaskedCorners = maskedCorner;
        //
        if (valueChanged && self.fdui_borderLayer && !self.fdui_borderLayer.hidden) {
            [self.fdui_borderLayer setNeedsLayout];
        }
    } error:&error];
    
    if (error) {
        [self uiborderLog:@"ERROR: Aspect setMaskedCorners error = %@", error];
    }
}

- (void)uiborderLog:(NSString *)format, ... {

#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"UIView (UIBorder)>>>%@", msg);
#endif
}

@end
