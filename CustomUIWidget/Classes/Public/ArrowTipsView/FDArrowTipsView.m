//
//  FDArrowTipsView.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/3.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "FDArrowTipsView.h"
#import <libextobjc/extobjc.h>
#import "UIView+YYAdd.h"

static NSString* const kShowAnimationKey = @"arrowTipsView_showAnimation";
static NSString* const kDismissAnimationKey = @"arrowTipsView_dismissAnimation";
static CGFloat const kDefaultAnimationTime = 0.5;

@interface FDArrowTipsViewConfig ()
{
    
}
@property (nonatomic, strong) UIView *customView;   ///> 中间部分的自定义view

@end

@implementation FDArrowTipsViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentCornerRadius = -1;
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.gradientBackgroundLayer = [FDArrowTipsViewConfig defaultGradientLayer];
        self.arrowSize = CGSizeMake(8, 8);
    }
    return self;
}

+ (CAGradientLayer *)gradientLayerSingleColor:(UIColor *)color {
    return [self gradientLayerWith:@[color, color] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors {

    return [self gradientLayerWith:colors startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint {

    NSMutableArray *arrCGColors = [NSMutableArray arrayWithCapacity:colors.count];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIColor class]]) {
            [arrCGColors addObject:((id)obj.CGColor)];
        }
    }];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = arrCGColors;
    
    return gradientLayer;
}

+ (CAGradientLayer *)defaultGradientLayer {
    UIColor *gradientBeginColor = [UIColor colorWithRed:170.0/255.0f green:108.0/255.0f blue:239.0/255.0f alpha:1.0f];
    UIColor *gradientEndColor = [UIColor colorWithRed:133.0/255.0f green:112.0/255.0f blue:241.0/255.0f alpha:1.0f];
    return [self gradientLayerWith:@[gradientBeginColor, gradientEndColor] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

@end

@interface FDArrowTipsView ()<CAAnimationDelegate>
{
    NSTimer *_timer;
    BOOL _isAutoDismiss; // 定时器关闭时是否自动移除view
    BOOL _dismissAutoRemove;
}
@property (nonatomic, strong) FDArrowTipsViewConfig *viewConfig;

@property (nonatomic, strong) UIButton *arrowLayerButton;   ///> 底部可操作的button
@property (nonatomic, strong) UIView *containerView;        ///> 包含传入进来自定义view的容器view

@property (nonatomic, strong) CAShapeLayer *triangleLayer;      ///> 可显示区域的layer

@end

@implementation FDArrowTipsView

#pragma mark - Public Interface

- (void)startShowTimerWithTime:(NSTimeInterval)time autoDismiss:(BOOL)autoDismiss {
    _isAutoDismiss = autoDismiss;
    [self startTimerWithTime:time];
}

- (void)startViewAnimation:(CGFloat)animationTime {

    CGFloat scaleRatio = 0.4f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:scaleRatio]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0.4); // 起始帧
    animation2.toValue = @(1.0); // 终了帧
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = animationTime;
    group.repeatCount = 1;
    group.animations = [NSArray arrayWithObjects:animation, animation2, nil];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.layer addAnimation:group forKey:kShowAnimationKey];
}

- (void)dismissTipsView:(CGFloat)animationTime autoRemove:(BOOL)autoRemove {
    _dismissAutoRemove = autoRemove;
    [self stopTimer];
    
    CGFloat scaleRatio = 0.4f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:scaleRatio]; // 结束时的倍率

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(1.0); // 起始帧
    animation2.toValue = @(0.4); // 终了帧

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = animationTime;
    group.repeatCount = 1;
    group.animations = [NSArray arrayWithObjects:animation, animation2, nil];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.layer addAnimation:group forKey:kDismissAnimationKey];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDArrowTipsViewConfig *)config andCustomView:(UIView *)customView {
    if (nil == customView || CGSizeEqualToSize(customView.size, CGSizeZero) ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.viewConfig = config;
        self.viewConfig.customView = customView;
        _direction = self.viewConfig.originDirection;
        [self setupUI];
        switch (self.viewConfig.originDirection) {
            case FDArrowDirection_Left:
            case FDArrowDirection_Right:
            {
                self.arrowCenterOffset = self.height / 2.0f;
                break;
            }
            case FDArrowDirection_Top:
            case FDArrowDirection_Bottom:
            default:
            {
                self.arrowCenterOffset = self.width / 2.0f;
                break;
            }
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andConfig:[FDArrowTipsViewConfig new] andCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)]];
}

- (void)dealloc {
    [self stopTimer];
    NSLog(@"%s", __func__);
}

#pragma mark - Event Response

- (void)arrowButtonClickAction:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    if (self.actionBlock) {
        self.actionBlock(weakSelf, FDArrowTipsViewActionTypeClick);
    }
}

- (void)timerEndAction:(NSTimer *)timer {
    [self stopTimer];
    
    __weak typeof(self)weakSelf = self;
    if (self.actionBlock) {
        self.actionBlock(weakSelf, FDArrowTipsViewActionTypeTimeOut);
    }
    
    if (_isAutoDismiss) {
        [self dismissTipsView:kDefaultAnimationTime autoRemove:YES];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    __weak typeof(self)weakSelf = self;
    if (flag) {
        if ([self.layer.animationKeys containsObject:kShowAnimationKey]) {
            [self.layer removeAnimationForKey:kShowAnimationKey];
            if (self.actionBlock) {
                self.actionBlock(weakSelf, FDArrowTipsViewActionTypeShowAnimationEnd);
            }
        } else if ([self.layer.animationKeys containsObject:kDismissAnimationKey]) {
            [self.layer removeAnimationForKey:kDismissAnimationKey];
            if (self.actionBlock) {
                self.actionBlock(weakSelf, FDArrowTipsViewActionTypeDismissAnimationEnd);
            }
            if (_dismissAutoRemove) {
                [self removeFromSuperview];
            }
        }
    }
}

#pragma mark - Private Methods

- (void)resetUI {
    [self.arrowLayerButton removeFromSuperview];
    self.arrowLayerButton = nil;
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [self setupUI];
}

- (void)setupUI {
    [self updateViewSize];
    
    self.arrowLayerButton = [self createArrowView];
    self.containerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view.autoresizesSubviews = YES;
        view.size = self.viewConfig.customView.size;
        self.viewConfig.customView.left = 0;
        self.viewConfig.customView.top = 0;
        [view addSubview:self.viewConfig.customView];
        view;
    });
    [self updateContainerViewPos];
    
    [self addSubview:self.arrowLayerButton];
    [self addSubview:self.containerView];
}

- (void)updateContainerViewPos {
    switch (self.direction) {
        case FDArrowDirection_Top:
        {
            self.containerView.left = self.viewConfig.contentEdgeInsets.left;
            self.containerView.top = self.viewConfig.arrowSize.height + self.viewConfig.contentEdgeInsets.top;
            break;
        }
        case FDArrowDirection_Bottom:
        {
            self.containerView.left = self.viewConfig.contentEdgeInsets.left;
            self.containerView.top = self.viewConfig.contentEdgeInsets.top;
            break;
        }
        case FDArrowDirection_Left:
        {
            self.containerView.left = self.viewConfig.arrowSize.width + self.viewConfig.contentEdgeInsets.left;
            self.containerView.top = self.viewConfig.contentEdgeInsets.top;
            break;
        }
        case FDArrowDirection_Right:
        {
            self.containerView.left = self.viewConfig.contentEdgeInsets.left;
            self.containerView.top = self.viewConfig.contentEdgeInsets.top;
            break;
        }
        default:
            break;
    }
    self.containerView.size = self.viewConfig.customView.size;
}

- (void)updateViewSize {
    UIEdgeInsets contentEdgeInsets = self.viewConfig.contentEdgeInsets;
    CGFloat viewWidth = 0.0f;
    CGFloat viewHeight = 0.0f;
    switch (self.direction) {
        case FDArrowDirection_Top:
        case FDArrowDirection_Bottom:
        {
            viewWidth = contentEdgeInsets.left + contentEdgeInsets.right + self.viewConfig.customView.width;
            viewHeight = contentEdgeInsets.top + contentEdgeInsets.bottom + self.viewConfig.customView.height + self.viewConfig.arrowSize.height;
            break;
        }
        case FDArrowDirection_Left:
        case FDArrowDirection_Right:
        {
            viewWidth = contentEdgeInsets.left + contentEdgeInsets.right + self.viewConfig.customView.width + self.viewConfig.arrowSize.width;
            viewHeight = contentEdgeInsets.top + contentEdgeInsets.bottom + self.viewConfig.customView.height;
            break;
        }
        default:
            break;
    }
    
    CGSize newSize = CGSizeMake(viewWidth, viewHeight);
    self.size = newSize;
    self.arrowLayerButton.size = newSize;
    self.viewConfig.gradientBackgroundLayer.frame = self.arrowLayerButton.bounds;
}

#pragma mark -- Datas

- (CGFloat)getAdjustArrowCenterXOffset:(CGFloat)cornerRadius {

    CGFloat xOffset = self.arrowCenterOffset;
    CGFloat minXOffset = cornerRadius + self.viewConfig.arrowSize.width / 2.0f;  // 最小偏移量
    CGFloat maxXOffset = self.size.width - cornerRadius - self.viewConfig.arrowSize.width / 2.0f;
    xOffset = MIN(maxXOffset, MAX(minXOffset, xOffset));
    
    return xOffset;
}

- (CGFloat)getAdjustArrowCenterYOffset:(CGFloat)cornerRadius {

    CGFloat yOffset = self.arrowCenterOffset ;
    CGFloat minYOffset = cornerRadius + self.viewConfig.arrowSize.height / 2.0f;  // 最小偏移量
    CGFloat maxYOffset = self.size.height - cornerRadius - self.viewConfig.arrowSize.height / 2.0f;
    yOffset = MIN(maxYOffset, MAX(minYOffset, yOffset));
    
    return yOffset;
}

#pragma mark -- 绘制箭头view的路径

- (UIBezierPath *)getTrianglePath {
    CGSize viewSize = self.arrowLayerButton.size;
    CGSize arrowSize = self.viewConfig.arrowSize;
    CGFloat cornerRadius = [self getCornerRadius];
    
    CGFloat arrowCenterXOffset = [self getAdjustArrowCenterXOffset:cornerRadius];
    CGFloat arrowCenterYOffset = [self getAdjustArrowCenterYOffset:cornerRadius];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.direction) {
        case FDArrowDirection_Top:
        {
            // 画左上角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + arrowSize.height) radius:cornerRadius startAngle:M_PI endAngle:1.5 *M_PI clockwise:YES];
            // 添加到右上角线
            [path addLineToPoint:CGPointMake(arrowCenterXOffset - arrowSize.width / 2.0f, arrowSize.height)];
            [path addLineToPoint:CGPointMake(arrowCenterXOffset , 0)];
            [path addLineToPoint:CGPointMake(arrowCenterXOffset + arrowSize.width / 2.0f, arrowSize.height)];
            [path addLineToPoint:CGPointMake(viewSize.width - cornerRadius, arrowSize.height)];
            // 画右上角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, cornerRadius + arrowSize.height) radius:cornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(viewSize.width , viewSize.height - cornerRadius)];
            // 画右下角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(cornerRadius, viewSize.height)];
            // 画左下角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path closePath];
            break;
        }
        case FDArrowDirection_Bottom:
        {
            // 画左上角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5 *M_PI clockwise:YES];
            // 添加到右上角线
            [path addLineToPoint:CGPointMake(viewSize.width - cornerRadius, 0)];
            // 画右上角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(viewSize.width , viewSize.height - cornerRadius - arrowSize.height)];
            // 画右下角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, viewSize.height - cornerRadius - arrowSize.height) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(arrowCenterXOffset + arrowSize.width / 2.0f, viewSize.height - arrowSize.height)];
            [path addLineToPoint:CGPointMake(arrowCenterXOffset , viewSize.height)];
            [path addLineToPoint:CGPointMake(arrowCenterXOffset - arrowSize.width / 2.0f, viewSize.height - arrowSize.height)];
            [path addLineToPoint:CGPointMake(cornerRadius, viewSize.height - arrowSize.height)];
            // 画左下角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, viewSize.height - arrowSize.height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path closePath];
            break;
        }
        case FDArrowDirection_Left:
        {
            // 画左上角圆弧
            [path addArcWithCenter:CGPointMake(arrowSize.width + cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5 *M_PI clockwise:YES];
            // 添加到右上角线
            [path addLineToPoint:CGPointMake(viewSize.width - cornerRadius, 0)];
            // 画右上角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, cornerRadius) radius:cornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(viewSize.width , viewSize.height - cornerRadius)];
            // 画右下角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(arrowSize.width + cornerRadius, viewSize.height)];
            // 画左下角圆弧
            [path addArcWithCenter:CGPointMake(arrowSize.width + cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            // 添加到左箭头
            [path addLineToPoint:CGPointMake(arrowSize.width, arrowCenterYOffset + arrowSize.height / 2.0f)];
            [path addLineToPoint:CGPointMake(0 , arrowCenterYOffset)];
            [path addLineToPoint:CGPointMake(arrowSize.width, arrowCenterYOffset - arrowSize.height / 2.0f)];
            [path closePath];
            break;
        }
        case FDArrowDirection_Right:
        {
            // 画左上角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5 *M_PI clockwise:YES];
            // 添加到右上角线
            [path addLineToPoint:CGPointMake(viewSize.width - cornerRadius - arrowSize.width, 0)];
            // 画右上角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius - arrowSize.width, cornerRadius) radius:cornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
            // 添加到右箭头
            [path addLineToPoint:CGPointMake(viewSize.width - arrowSize.width, arrowCenterYOffset - arrowSize.height / 2.0f)];
            [path addLineToPoint:CGPointMake(viewSize.width, arrowCenterYOffset)];
            [path addLineToPoint:CGPointMake(viewSize.width - arrowSize.width, arrowCenterYOffset + arrowSize.height / 2.0f)];
            [path addLineToPoint:CGPointMake(viewSize.width - arrowSize.width, viewSize.height - cornerRadius )];
            // 画右下角圆弧
            [path addArcWithCenter:CGPointMake(viewSize.width - arrowSize.width - cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            // 添加到右下角线
            [path addLineToPoint:CGPointMake(cornerRadius, viewSize.height)];
            // 画左下角圆弧
            [path addArcWithCenter:CGPointMake(cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path closePath];
            break;
        }
        default:
            break;
    }

    return path;
}

#pragma mark -- 箭头view创建

- (UIButton *)createArrowView {
    
    CGSize viewSize = self.size;
    UIButton *superView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [superView addTarget:self action:@selector(arrowButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];

    CAShapeLayer *triangleLayer = [[CAShapeLayer alloc]init];
    [triangleLayer setFillColor:[UIColor cyanColor].CGColor];
    self.triangleLayer = triangleLayer;
    
    CAGradientLayer *gradientLayer = self.viewConfig.gradientBackgroundLayer;
    gradientLayer.frame = superView.bounds;

    [superView.layer addSublayer:gradientLayer];
    [superView.layer addSublayer:triangleLayer];
    
    gradientLayer.mask = triangleLayer;
    
    return superView;
}

#pragma mark -- Datas

- (CGFloat)getCornerRadius {
    CGSize viewSize = self.arrowLayerButton.size;
    CGSize arrowSize = self.viewConfig.arrowSize;
    
    CGFloat cornerRadius = self.viewConfig.contentCornerRadius;
    if (cornerRadius < 0.0f) {
        // 需要自动计算
        switch (self.direction) {
            case FDArrowDirection_Top:
            case FDArrowDirection_Bottom:
            {
                cornerRadius = (viewSize.height - arrowSize.height) / 2.0f;
                break;
            }
            case FDArrowDirection_Left:
            case FDArrowDirection_Right:
            {
                cornerRadius = viewSize.height / 2.0f;
                break;
            }
            default:
                break;
        }
    }
    // 限制条件
    cornerRadius = MIN(cornerRadius, (viewSize.height - arrowSize.height) / 2.0f); ///> 半径不能大于高度一半
    return cornerRadius;
}

#pragma mark -- Timer

- (void)startTimerWithTime:(NSTimeInterval)time {
    [self stopTimer];
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerEndAction:) userInfo:nil repeats:NO];
    }
}

- (void)stopTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}

#pragma mark - Setter or Getter

- (void)setCustomBezierPath:(UIBezierPath *)customBezierPath {
    _customBezierPath = customBezierPath;
    
    self.triangleLayer.path = nil;
    self.triangleLayer.path = customBezierPath.CGPath;
}

- (void)setArrowCenterOffset:(CGFloat)arrowCenterOffset {
    _arrowCenterOffset = arrowCenterOffset;
    
    self.triangleLayer.path = nil;
    self.triangleLayer.path = [self getTrianglePath].CGPath;
}

- (void)setDirection:(FDArrowDirection)direction {
    
    BOOL isNeedReset = (direction != _direction);
    _direction = direction;
    
    if (isNeedReset) {
        [self resetUI];
    } else {
        [self updateContainerViewPos];
    }
    self.triangleLayer.path = nil;
    self.triangleLayer.path = [self getTrianglePath].CGPath;
}

@end
