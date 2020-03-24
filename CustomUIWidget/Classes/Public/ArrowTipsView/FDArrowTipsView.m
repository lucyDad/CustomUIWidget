//
//  FDArrowTipsView.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/3.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "FDArrowTipsView.h"
#import "FDCustomUIWidgetDef.h"

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
        self.contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);

        self.gradientBackgroundLayer = [FDArrowTipsViewConfig defaultGradientLayer];

        self.arrowSize = CGSizeMake(8, 8);
        
        self.timeOutTime = 3;
        self.animationTime = 0.0;
    }
    return self;
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

CGFloat const gArrowTipsViewMarginOffset = 5; // 微调值

@interface FDArrowTipsView ()<CAAnimationDelegate>
{
    NSTimer *_timer;
}
@property (nonatomic, strong) FDArrowTipsViewConfig *viewConfig;

@property (nonatomic, strong) UIButton *arrowLayerButton;   ///> 底部可操作的button
@property (nonatomic, strong) UIView *containerView;        ///> 包含传入进来自定义view的容器view

@property (nonatomic, strong) CAShapeLayer *triangleLayer;      ///> 可显示区域的layer

@end

@implementation FDArrowTipsView

#pragma mark - Public Interface

- (void)startShowTimerWithTime:(NSTimeInterval)time {
    
    [self startTimerWithTime:time];
}

- (void)startViewAnimation {
    
    CGFloat animationTime = self.viewConfig.animationTime;
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
    group.delegate = self;
    [self.layer addAnimation:group forKey:@"arrowTipsView_showAnimation"];
}

- (void)dismissTipsView {
    [self stopTimer];
    
    CGFloat animationTime = self.viewConfig.animationTime;
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
    group.delegate = self;
    [self.layer addAnimation:group forKey:@"arrowTipsView_dismissAnimation"];

    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.viewConfig.animationTime - 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.layer removeAllAnimations];
        
        if (self.actionBlock) {
            self.actionBlock(self, FDArrowTipsViewActionTypeWillRemove);
        }
        [self removeFromSuperview];
    });
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
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andConfig:[FDArrowTipsViewConfig new] andCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)]];
}

- (void)dealloc {
    [self stopTimer];
    LOGGO_INFO(@"");
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
    
    if (self.viewConfig.autoTimeOutClose) {
        [self dismissTipsView];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    __weak typeof(self)weakSelf = self;
    if (flag) {
        if (self.actionBlock) {
            self.actionBlock(weakSelf, FDArrowTipsViewActionTypeAnimationEnd);
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

- (CGFloat)getAdjustArrowXOffset:(CGFloat)cornerRadius {

    CGFloat xOffset = self.arrowCenterXOffset - self.viewConfig.arrowSize.width / 2.0f;
    CGFloat minXOffset = cornerRadius + gArrowTipsViewMarginOffset;  // 最小偏移量
    CGFloat maxXOffset = self.size.width - minXOffset - self.viewConfig.arrowSize.width;
    xOffset = MIN(maxXOffset, MAX(minXOffset, xOffset));
    
    return xOffset;
}

- (CGFloat)getAdjustArrowYOffset:(CGFloat)cornerRadius {

    CGFloat yOffset = self.arrowCenterYOffset - self.viewConfig.arrowSize.height / 2.0f;
    CGFloat minYOffset = cornerRadius + gArrowTipsViewMarginOffset;  // 最小偏移量
    CGFloat maxYOffset = self.size.height - minYOffset - self.viewConfig.arrowSize.height;
    yOffset = MIN(maxYOffset, MAX(minYOffset, yOffset));
    
    return yOffset;
}

#pragma mark -- 绘制箭头view的路径

- (UIBezierPath *)getTrianglePath {
    CGSize viewSize = self.arrowLayerButton.size;
    CGSize arrowSize = self.viewConfig.arrowSize;
    CGFloat cornerRadius = [self getCornerRadius];
    
    CGFloat arrowXOffset = [self getAdjustArrowXOffset:cornerRadius];
    CGFloat arrowYOffset = [self getAdjustArrowYOffset:cornerRadius];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.direction) {
        case FDArrowDirection_Top:
        {
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, arrowSize.height, viewSize.width, viewSize.height - arrowSize.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            
            UIBezierPath *triangleRect = [UIBezierPath bezierPath];
            [triangleRect moveToPoint:CGPointMake(arrowXOffset, arrowSize.height)];
            [triangleRect addLineToPoint:CGPointMake(arrowXOffset + arrowSize.width / 2.0f, 0)];
            [triangleRect addLineToPoint:CGPointMake(arrowXOffset + arrowSize.width, arrowSize.height)];
            [triangleRect closePath];
            
            [path appendPath:roundedRect];
            [path appendPath:triangleRect];
            break;
        }
        case FDArrowDirection_Bottom:
        {
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height - arrowSize.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            
            UIBezierPath *triangleRect = [UIBezierPath bezierPath];
            [triangleRect moveToPoint:CGPointMake(arrowXOffset, viewSize.height - arrowSize.height)];
            [triangleRect addLineToPoint:CGPointMake(arrowXOffset + arrowSize.width / 2.0f, viewSize.height)];
            [triangleRect addLineToPoint:CGPointMake(arrowXOffset + arrowSize.width, viewSize.height - arrowSize.height)];
            [triangleRect closePath];
            
            [path appendPath:roundedRect];
            [path appendPath:triangleRect];
            break;
        }
        case FDArrowDirection_Left:
        {
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(arrowSize.width, 0, viewSize.width - arrowSize.width, viewSize.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            
            UIBezierPath *triangleRect = [UIBezierPath bezierPath];
            [triangleRect moveToPoint:CGPointMake(arrowSize.width, arrowYOffset)];
            [triangleRect addLineToPoint:CGPointMake(0, arrowYOffset + arrowSize.height / 2.0f)];
            [triangleRect addLineToPoint:CGPointMake(arrowSize.width, arrowYOffset + arrowSize.height)];
            [triangleRect closePath];
            
            [path appendPath:roundedRect];
            [path appendPath:triangleRect];
            break;
        }
        case FDArrowDirection_Right:
        {
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width - arrowSize.width, viewSize.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            
            UIBezierPath *triangleRect = [UIBezierPath bezierPath];
            [triangleRect moveToPoint:CGPointMake(viewSize.width - arrowSize.width, arrowYOffset)];
            [triangleRect addLineToPoint:CGPointMake(viewSize.width, arrowYOffset + arrowSize.height / 2.0f)];
            [triangleRect addLineToPoint:CGPointMake(viewSize.width - arrowSize.width, arrowYOffset + arrowSize.height)];
            [triangleRect closePath];
            
            [path appendPath:roundedRect];
            [path appendPath:triangleRect];
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

- (void)setArrowCenterXOffset:(CGFloat)arrowCenterXOffset {
    _arrowCenterXOffset = arrowCenterXOffset;
    
    self.triangleLayer.path = nil;
    self.triangleLayer.path = [self getTrianglePath].CGPath;
}

- (void)setArrowCenterYOffset:(CGFloat)arrowCenterYOffset {
    _arrowCenterYOffset = arrowCenterYOffset;
    
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
