//
//  FDFlexibleLayoutView.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/1/5.
//

#import "FDFlexibleLayoutView.h"
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>

@interface UIView()

@property (nonatomic, assign, getter=isFlexibleLayoutViewSelect) BOOL  flexibleLayoutViewSelect;

@end

@implementation UIView(FlexibleLayoutViewInfo)

- (CGFloat)flexibleLayoutViewLeftMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFlexibleLayoutViewLeftMargin:(CGFloat)flexibleLayoutViewLeftMargin {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewLeftMargin), @(flexibleLayoutViewLeftMargin), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)flexibleLayoutViewRightMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFlexibleLayoutViewRightMargin:(CGFloat)flexibleLayoutViewRightMargin {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewRightMargin), @(flexibleLayoutViewRightMargin), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)flexibleLayoutViewMinWidthLimit {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setFlexibleLayoutViewMinWidthLimit:(CGFloat)flexibleLayoutViewMinWidthLimit {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewMinWidthLimit), @(flexibleLayoutViewMinWidthLimit), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isFlexibleLayoutViewSelect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFlexibleLayoutViewSelect:(BOOL)flexibleLayoutViewSelect {
    objc_setAssociatedObject(self, @selector(isFlexibleLayoutViewSelect), @(flexibleLayoutViewSelect), OBJC_ASSOCIATION_RETAIN);
}

- (FlexibleLayoutYType)flexibleLayoutViewYType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setFlexibleLayoutViewYType:(FlexibleLayoutYType)flexibleLayoutViewYType {
    objc_setAssociatedObject(self, @selector(flexibleLayoutViewYType), @(flexibleLayoutViewYType), OBJC_ASSOCIATION_RETAIN);
}

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

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)reloadUI {
    if (nil == self.adjustView ) {
        return;
    }
    [self removeAllSubviews];
    
    CGSize size = [self caculateSize:self.size adjustView:self.adjustView fixViews:self.fixedViews];
    self.size = size;
    
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
            NSLog(@"layoutView>>>leftWidth = %f, maxHeight = %f", leftWidth, maxHeight);
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
            
            NSLog(@"layoutView>>>idx = %lu, frame = %@, originX = %f", (unsigned long)idx, NSStringFromCGRect(obj.frame), originX);
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
