//
//  FDGridView.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDGridView.h"

@interface FDGridView ()
{
    
}

@property(nonatomic, strong) CAShapeLayer *separatorLayer;
@end

@implementation FDGridView

#pragma mark - Public Interface

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;
    self.separatorLayer.lineWidth = _separatorWidth;
    self.separatorLayer.hidden = _separatorWidth <= 0;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.separatorLayer.strokeColor = _separatorColor.CGColor;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame column:(NSInteger)column rowHeight:(CGFloat)rowHeight {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.columnCount = column;
        self.rowHeight = rowHeight;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column rowHeight:(CGFloat)rowHeight {
    return [self initWithFrame:CGRectZero column:column rowHeight:rowHeight];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame column:0 rowHeight:0];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSInteger rowCount = [self rowCount];
    CGFloat totalHeight = rowCount * self.rowHeight + (rowCount - 1) * self.separatorWidth;
    totalHeight += self.padding.top + self.padding.bottom;
    size.height = totalHeight;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger subviewCount = self.subviews.count;
    if (subviewCount == 0) return;
    
    CGSize size = self.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) return;
    
    CGFloat columnWidth = [self stretchColumnWidth];
    CGFloat rowHeight = self.rowHeight;
    NSInteger rowCount = [self rowCount];
    
    BOOL shouldShowSeparator = self.separatorWidth > 0;
    CGFloat lineOffset = shouldShowSeparator ? self.separatorWidth / 2.0 : 0;
    UIBezierPath *separatorPath = shouldShowSeparator ? [UIBezierPath bezierPath] : nil;
    
    for (NSInteger row = 0; row < rowCount; row++) {
        for (NSInteger column = 0; column < self.columnCount; column++) {
            NSInteger index = row * self.columnCount + column;
            if (index < subviewCount) {
                BOOL isLastColumn = column == self.columnCount - 1;
                BOOL isLastRow = row == rowCount - 1;
                
                UIView *subview = self.subviews[index];
                CGRect subviewFrame = CGRectMake(columnWidth * column + self.separatorWidth * column + self.padding.left, rowHeight * row + self.separatorWidth * row + self.padding.top, columnWidth, rowHeight);
                
                if (isLastColumn) {
                    // 每行最后一个item要占满剩余空间，否则可能因为strecthColumnWidth不精确导致右边漏空白
                    subviewFrame.size.width = size.width - (self.padding.left + self.padding.right ) - columnWidth * (self.columnCount - 1) - self.separatorWidth * (self.columnCount - 1);
                }
                if (isLastRow) {
                    // 最后一行的item要占满剩余空间，避免一些计算偏差
                    subviewFrame.size.height = size.height - (self.padding.top + self.padding.bottom ) - rowHeight * (rowCount - 1) - self.separatorWidth * (rowCount - 1);
                }
                
                subview.frame = subviewFrame;
                [subview setNeedsLayout];
                
                if (shouldShowSeparator) {
                    // 每个 item 都画右边和下边这两条分隔线
                    CGPoint rightTopPoint = CGPointMake(CGRectGetMaxX(subviewFrame) + lineOffset, CGRectGetMinY(subviewFrame));
                    CGPoint rightBottomPoint = CGPointMake(rightTopPoint.x - (isLastColumn ? lineOffset : 0), CGRectGetMaxY(subviewFrame) + (!isLastRow ? lineOffset : 0));
                    CGPoint leftBottomPoint = CGPointMake(CGRectGetMinX(subviewFrame), rightBottomPoint.y);
                    
                    if (!isLastColumn) {
                        [separatorPath moveToPoint:rightTopPoint];
                        [separatorPath addLineToPoint:rightBottomPoint];
                    }
                    if (!isLastRow) {
                        [separatorPath moveToPoint:rightBottomPoint];
                        [separatorPath addLineToPoint:leftBottomPoint];
                    }
                }
            }
        }
    }
    
    if (shouldShowSeparator) {
        self.separatorLayer.path = separatorPath.CGPath;
    }
}

#pragma mark - Event Response

#pragma mark - Private Methods

// 返回最接近平均列宽的值，保证其为整数，因此所有columnWidth加起来可能比总宽度要小
- (CGFloat)stretchColumnWidth {
    return floor((CGRectGetWidth(self.bounds) - self.padding.top - self.padding.bottom - self.separatorWidth * (self.columnCount - 1)) / self.columnCount);
}

- (NSInteger)rowCount {
    NSInteger subviewCount = self.subviews.count;
    return subviewCount / self.columnCount + (subviewCount % self.columnCount > 0 ? 1 : 0);
}

- (void)setupUI {
    self.separatorLayer = [CAShapeLayer layer];
    //[self.separatorLayer qmui_removeDefaultAnimations];
    self.separatorLayer.hidden = YES;
    [self.layer addSublayer:self.separatorLayer];
    
    self.separatorColor = UIColorHex(#333333);
}

#pragma mark - Setter or Getter

@end
