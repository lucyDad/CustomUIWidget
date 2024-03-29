//
//  FDFlexibleLayoutView.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/1/5.
//

#import "FDFlexibleLayoutView.h"
#import <objc/runtime.h>

@interface UIView()

@property (nonatomic, assign, getter=isFlexibleLayoutViewSelect) BOOL  flexibleLayoutViewSelect; // 每个view标记是否展示

@property (nonatomic, assign, getter=isSetUpRightMargin) BOOL  setUpRightMargin; // 是否设置过右侧偏移

@end

@implementation UIView(FlexibleLayoutViewInfo)

#pragma mark - Public

- (CGFloat)flexibleLayoutViewLeftMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFlexibleLayoutViewLeftMargin:(CGFloat)flexibleLayoutViewLeftMargin {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewLeftMargin), @(flexibleLayoutViewLeftMargin), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)flexibleLayoutViewRightMargin {
    if (self.isSetUpRightMargin) {
        return [objc_getAssociatedObject(self, _cmd) floatValue];
    }
    return 5; // 默认值是5
}

- (void)setFlexibleLayoutViewRightMargin:(CGFloat)flexibleLayoutViewRightMargin {
    self.setUpRightMargin = YES;
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewRightMargin), @(flexibleLayoutViewRightMargin), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)flexibleLayoutViewMinWidthLimit {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFlexibleLayoutViewMinWidthLimit:(CGFloat)flexibleLayoutViewMinWidthLimit {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewMinWidthLimit), @(flexibleLayoutViewMinWidthLimit), OBJC_ASSOCIATION_RETAIN);
}

- (FlexibleLayoutYType)flexibleLayoutViewYType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setFlexibleLayoutViewYType:(FlexibleLayoutYType)flexibleLayoutViewYType {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewYType), @(flexibleLayoutViewYType), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Private

- (BOOL)isFlexibleLayoutViewSelect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFlexibleLayoutViewSelect:(BOOL)flexibleLayoutViewSelect {
    objc_setAssociatedObject(self, @selector(isFlexibleLayoutViewSelect), @(flexibleLayoutViewSelect), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSetUpRightMargin {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSetUpRightMargin:(BOOL)setUpRightMargin {
    objc_setAssociatedObject(self, @selector(isSetUpRightMargin), @(setUpRightMargin), OBJC_ASSOCIATION_RETAIN);
}

@end

@interface FDFlexibleLayoutView ()
{
    
}

@property (nonatomic, assign) CGRect  oldFrame;

@end

@implementation FDFlexibleLayoutView

#pragma mark - Public Interface

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//- (void)layoutSubviews {
//    //NSLog(@"oldframe = %@, frame = %@", NSStringFromCGRect(self.oldFrame), NSStringFromCGRect(self.frame));
//    if (!CGRectEqualToRect(self.oldFrame, self.frame)) {
//        self.oldFrame = self.frame;
//        [self reloadUI];
//    }
//}

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)reloadUI {
    if (nil == self.adjustView ) {
        return;
    }
    CGRect frame = self.frame;
    // 自动布局时初始不处理
    if (CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    // 移除所有子view
    while(self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    
    CGSize size = [self caculateSize:frame.size adjustView:self.adjustView fixViews:self.fixedViews];
    frame.size = size;
    self.frame = frame;
    
    [self addSubview:self.adjustView];
    [self.fixedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFlexibleLayoutViewSelect) {
            [self addSubview:obj];
        }
    }];
}

- (CGSize)caculateSize:(CGSize)containerSize
              adjustView:(UIView *)adjustView
                fixViews:(nullable NSArray<UIView *> *)fixViews {
    
    CGFloat widthLimit = containerSize.width;
    CGFloat adjustViewMinWidth = adjustView.flexibleLayoutViewMinWidthLimit + adjustView.flexibleLayoutViewLeftMargin + adjustView.flexibleLayoutViewRightMargin;   // 可缩小的最大长度
    __block CGFloat leftWidth = widthLimit - adjustViewMinWidth;    // 剩余可用的宽度
    __block CGFloat maxHeight = CGRectGetHeight(adjustView.frame);  // 计算最大的高度
    // 计算选中的view
    [fixViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat interval = obj.flexibleLayoutViewLeftMargin + obj.flexibleLayoutViewRightMargin;
        CGFloat singleWidth = CGRectGetWidth(obj.frame) + interval;
        
        if (leftWidth - singleWidth > 0) {
            leftWidth -= singleWidth;
            obj.flexibleLayoutViewSelect = YES;
            
            if (CGRectGetHeight(obj.frame) > maxHeight) {
                maxHeight = CGRectGetHeight(obj.frame);
            }
            NSLog(@"layoutView>>>剩余可用宽度 = %f, 最大高度 = %f", leftWidth, maxHeight);
        } else {
            NSLog(@"layoutView>>>剩余可用宽度 = %f < 要加载view的宽度 = %f", leftWidth, singleWidth);
        }
    }];
    
    CGFloat heightLimit = ( 0.0f == containerSize.height ? maxHeight : containerSize.height); //
    CGFloat adjustViewWidth = MAX(MIN(adjustViewMinWidth + leftWidth, CGRectGetWidth(adjustView.frame)), adjustViewMinWidth);
    adjustView.frame = CGRectMake(adjustView.flexibleLayoutViewLeftMargin, [self getYPos:adjustView limitHeight:heightLimit], adjustViewWidth, CGRectGetHeight(adjustView.frame));
    
    __block CGFloat originX = CGRectGetMaxX(adjustView.frame) + adjustView.flexibleLayoutViewRightMargin;
    [fixViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFlexibleLayoutViewSelect) {
            obj.frame = CGRectMake(originX, [self getYPos:obj limitHeight:heightLimit], CGRectGetWidth(obj.frame), CGRectGetHeight(obj.frame));
            
            originX = CGRectGetMaxX(obj.frame) + obj.flexibleLayoutViewRightMargin;
            
            NSLog(@"layoutView>>>加载view的索引 = %lu, frame = %@, 最外层容器view宽度 = %f", (unsigned long)idx, NSStringFromCGRect(obj.frame), originX);
        }
    }];
    return CGSizeMake(originX, heightLimit);
}

- (CGFloat)getYPos:(UIView *)view limitHeight:(CGFloat)limitHeight {
    CGFloat yPos = 0.0f;
    switch (view.flexibleLayoutViewYType) {
        case FlexibleLayoutYTypeTop:
        {
            yPos = 0.0f;
            break;
        }
        case FlexibleLayoutYTypeBottom:
        {
            yPos = limitHeight - CGRectGetHeight(view.frame);
            break;
        }
        case FlexibleLayoutYTypeCenter:
        default:
        {
            yPos = (limitHeight - CGRectGetHeight(view.frame) ) / 2.0f;
            break;
        }
    }
    return yPos;
}

#pragma mark - Setter or Getter

@end
