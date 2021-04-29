//
//  FDGradientView.m
//  ZAIssue
//
//  Created by hexiang on 2021/4/15.
//  Copyright © 2021 MAC. All rights reserved.
//

#import "FDGradientBorderView.h"
#import "UIColor+YYAdd.h"

@interface FDGradientBorderView ()
{
    
}

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation FDGradientBorderView

#pragma mark - Public Interface

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.shapeLayer.lineWidth = lineWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    [self updatePath];
}

- (void)setCustomPath:(UIBezierPath *)customPath {
    _customPath = customPath;
    
    [self updatePath];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1);
        self.gradientLayer.colors = @[(__bridge id)UIColorHex(FD8E6E).CGColor, (__bridge id)UIColorHex(FF2E7F).CGColor];
        self.shapeLayer = ({
            CAShapeLayer *layer = [CAShapeLayer new];
            layer.lineWidth = 2.0f;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor blackColor].CGColor;
            layer;
        });
        self.layer.mask = self.shapeLayer;
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)layoutSubviews {
    //NSLog(@"%s", __func__);
    [self updatePath];
}

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)updatePath {
    self.shapeLayer.path = nil;
    if (nil != self.customPath) {
        self.shapeLayer.path = self.customPath.CGPath;
        return;
    }
    self.shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
}

#pragma mark - Setter or Getter

@end
