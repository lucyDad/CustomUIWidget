//
//  FDFlowerContainerView.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/3/17.
//

#import "FDFlowerContainerView.h"
#import "UIView+YYAdd.h"

@implementation FDFlowerContainerViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return self;
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

@end

@interface FDFlowerContainerView ()
{
    
}
@property (nonatomic, strong) FDFlowerContainerViewConfig *viewConfig;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;      ///> 可显示区域的layer
@property (nonatomic, strong) UIView *customView;

@end

@implementation FDFlowerContainerView

#pragma mark - Public Interface

+ (instancetype)flowerContainerView:(NSAttributedString *)attrString backgroundColor:(UIColor *)backgroundColor {
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.attributedText = attrString;
        label;
    });
    FDFlowerContainerViewConfig *config = [FDFlowerContainerViewConfig new];
    config.gradientBackgroundLayer = [FDFlowerContainerViewConfig gradientLayerWith:@[backgroundColor, backgroundColor] startPoint:CGPointZero endPoint:CGPointMake(1, 0)];
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - config.contentEdgeInsets.left - config.contentEdgeInsets.right;
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    titleLabel.size = size;
    
    FDFlowerContainerView *view = [[FDFlowerContainerView alloc] initWithConfig:config customView:titleLabel];
    
    return view;
}

#pragma mark - Life Cycle

- (instancetype)initWithConfig:(FDFlowerContainerViewConfig *)config customView:(UIView *)customView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.viewConfig = config;
        self.customView = customView;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label;
    });
    return [self initWithConfig:[FDFlowerContainerViewConfig new] customView:titleLabel];
}

- (void)dealloc {
    //DLog(@"%s: ", __func__);
}

- (void)layoutSubviews {
    
}

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)setupUI {
    
    CAGradientLayer *gradientLayer = self.viewConfig.gradientBackgroundLayer;
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];

    self.triangleLayer = ({
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        //[layer setFillColor:[UIColor cyanColor].CGColor];
        layer;
    });
    [self.layer addSublayer:self.triangleLayer];
    
    gradientLayer.mask = self.triangleLayer;
    
    if (self.viewConfig.isOval) {
        CGFloat width = self.customView.width + 2 * self.viewConfig.contentEdgeInsets.left;
        CGFloat height = self.customView.height + 2 * self.viewConfig.contentEdgeInsets.top + self.viewConfig.contentEdgeInsets.bottom;
        self.size = CGSizeMake(width, height);
        
        self.customView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
        self.triangleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    } else {
        self.customView.left = self.viewConfig.contentEdgeInsets.left;
        self.customView.top = self.viewConfig.contentEdgeInsets.top;
        self.triangleLayer.path = [self getBezierPath].CGPath;
        
        CGFloat width = self.customView.width + self.viewConfig.contentEdgeInsets.left + self.viewConfig.contentEdgeInsets.right;
        CGFloat height = self.customView.height + self.viewConfig.contentEdgeInsets.top + self.viewConfig.contentEdgeInsets.bottom;
        self.size = CGSizeMake(width, height);
    }

    [self addSubview:self.customView];
}

- (UIBezierPath *)getBezierPath {
    CGSize middleSize = self.customView.size;
    UIEdgeInsets edgeInsets = self.viewConfig.contentEdgeInsets;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(edgeInsets.left, middleSize.height + edgeInsets.top)];
    // 画左边圆弧
    {
        CGPoint endPoint = CGPointMake(edgeInsets.left, edgeInsets.top);
        if (0 == edgeInsets.left) {
            [path addLineToPoint:endPoint];
        } else {
            [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(0, middleSize.height / 2.0 + edgeInsets.top)];
        }
    }
    // 画上边圆弧
    {
        CGPoint endPoint = CGPointMake(edgeInsets.left + middleSize.width, edgeInsets.top);
        if (0 == edgeInsets.top) {
            [path addLineToPoint:endPoint];
        } else {
            [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(edgeInsets.left + middleSize.width / 2.0 , 0)];
        }
    }
    // 画右边圆弧
    {
        CGPoint endPoint = CGPointMake(edgeInsets.left + middleSize.width, edgeInsets.top + middleSize.height);
        if (0 == edgeInsets.right) {
            [path addLineToPoint:endPoint];
        } else {
            [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(edgeInsets.left + middleSize.width + edgeInsets.right , edgeInsets.top + middleSize.height / 2.0)];
        }
    }
    // 画下边圆弧
    {
        CGPoint endPoint = CGPointMake(edgeInsets.left, edgeInsets.top + middleSize.height);
        if (0 == edgeInsets.bottom) {
            [path addLineToPoint:endPoint];
        } else {
            [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(edgeInsets.left + middleSize.width / 2.0 , edgeInsets.top + middleSize.height + edgeInsets.bottom)];
        }
    }

    [path closePath];
    return path;
}

#pragma mark - Setter or Getter

@end
