//
//  FDCollectionCellView.m
//  funnydate
//
//  Created by hexiang on 2019/11/6.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import "FDCollectionCellView.h"
#import <Masonry/Masonry.h>
#import <YYModel/YYModel.h>
#import "FDCustomUIWidgetDef.h"

NSInteger const gTagForCollectionCellView = 8000;       ///> 每个子view的初始tag

@implementation FDCollectionCellViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.columnNumber = 3;
        self.lineColor = UIColorHex(F4F4F4);
        self.lineWidth = 1.0f;
        self.fillType = CellViewFillTypeAll;
        self.fillViewColor = [UIColor whiteColor];
        self.contentEdgeInsets = UIEdgeInsetsMake(self.lineWidth, 0, 0, 0);
        self.adapteInteger = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }

@end

@interface FDCollectionCellView ()
{
    
}

@property (nonatomic, assign) CGFloat  maxWidth;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) FDCollectionCellViewConfig *viewConfig;

@end

@implementation FDCollectionCellView

#pragma mark - Public Interface

/// 反向调整计算整个view需要的宽度 （保证内部cell的宽度为整数）
/// @param maxWidth 初始传入view的宽度
/// @param config 配置参数
+ (CGFloat)caculateViewWidth:(CGFloat)maxWidth config:(FDCollectionCellViewConfig *)config {
    CGFloat lineWidth = config.lineWidth;
    NSInteger columnNumber = config.columnNumber;
    CGFloat xOriginPos = config.contentEdgeInsets.left;
    CGFloat allLineWidth = (columnNumber - 1 ) * lineWidth;
    
    CGFloat singleWidth = [self caculateSingleWidth:maxWidth config:config];
    // 反推需要的总宽度
    CGFloat allWidth = singleWidth * columnNumber + allLineWidth + xOriginPos + config.contentEdgeInsets.right;
    
    return allWidth;
}

+ (CGFloat)caculateSingleWidth:(CGFloat)maxWidth config:(FDCollectionCellViewConfig *)config {
    CGFloat lineWidth = config.lineWidth;
    NSInteger columnNumber = config.columnNumber;
    CGFloat xOriginPos = config.contentEdgeInsets.left;
    CGFloat allLineWidth = (columnNumber - 1 ) * lineWidth;
    CGFloat singleWidth = (maxWidth - allLineWidth - xOriginPos - config.contentEdgeInsets.right) / columnNumber;
    
    if (config.adapteInteger) {
        singleWidth = ceil(singleWidth);
    }
    return singleWidth;
}

- (void)reloadViewConfig:(FDCollectionCellViewConfig *)viewConfig {
    _viewConfig = viewConfig;
    
    [self reloadUI];
}

#pragma mark - Life Cycle

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth
                          config:(FDCollectionCellViewConfig *)config {
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        [self setupUI];
        self.maxWidth = maxWidth;
        self.viewConfig = config;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat maxWidth = (frame.size.width <= 0.0f ? [UIScreen mainScreen].bounds.size.width : frame.size.width);
    FDCollectionCellView *cellView = [self initWithMaxWidth:maxWidth config:[FDCollectionCellViewConfig new]];
    cellView.left = frame.origin.x;
    cellView.top = frame.origin.y;
    return cellView;
}

- (void)dealloc {
    NLog(@"%s: ", __func__);
}

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)setupUI {
    [self addSubview:self.contentView];
}

- (void)reloadUI {
    self.contentView.backgroundColor = self.viewConfig.lineColor;
    
    NSInteger columnNumber = self.viewConfig.columnNumber;
    if (0 == columnNumber) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    CGFloat heightOfCell = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(heightOfCellViewInCollection:)] ) {
        heightOfCell = [self.dataSource heightOfCellViewInCollection:weakSelf];
    }
    
    CGFloat lineWidth = self.viewConfig.lineWidth;
    CGFloat xOriginPos = self.viewConfig.contentEdgeInsets.left; // 初始xPos
    CGFloat yOriginPos = self.viewConfig.contentEdgeInsets.top; // 初始yPos
    __block CGFloat allHeight = 0;  // 布局后最终的高度
    
    CGFloat singleWidth = [FDCollectionCellView caculateSingleWidth:self.maxWidth config:self.viewConfig];
    
    UIView *contentView = self.contentView;
    [contentView removeAllSubviews];
    
    CGFloat viewFinalWidth = [FDCollectionCellView caculateViewWidth:self.maxWidth config:self.viewConfig]; // 整个view的最终宽度
    
    NSInteger allCount = 0; // 总个数
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numOfCellViewInCollection:)] ) {
        allCount = [self.dataSource numOfCellViewInCollection:weakSelf];
    }
    for (int idx = 0; idx < allCount; idx++) {
        // 创建单个View
        UIView *view = [self createSingleView:CGSizeMake(singleWidth, heightOfCell) index:idx];
        view.tag = gTagForCollectionCellView + idx;

        // 更新坐标
        NSInteger row = idx / columnNumber;  // 当前在第几行(0开始)
        NSInteger column = idx % columnNumber; // 当前在第几列(0开始)
        view.left = xOriginPos + (CGFloat)column * (view.width + lineWidth);
        view.top = yOriginPos + (CGFloat)row * (view.height + lineWidth);
        [contentView addSubview:view];
        
        allHeight = CGRectGetMaxY(view.frame);
        
        if (idx == allCount - 1) {
            // 最后一个计算填充view的宽度(ps: 如果刚好排满则不需要填充)
            // 填充剩余空白地方(不填充是lineColor, all --用整个cell的颜色填充， single-模拟单个cell填充(可看到分割线))
            if (column < columnNumber - 1) {
                CGFloat fillXPos = view.right + lineWidth;
                CGFloat fillYPos = view.top;

                switch (self.viewConfig.fillType) {
                    case CellViewFillTypeAll:
                    {
                        // 需要全部填充view的frame
                        CGRect fillViewRect = CGRectMake(fillXPos, fillYPos, viewFinalWidth - self.viewConfig.contentEdgeInsets.right - fillXPos, heightOfCell);
                        UIView *fillView = [[UIView alloc] initWithFrame:fillViewRect];
                        fillView.backgroundColor = self.viewConfig.fillViewColor;
                        [contentView addSubview:fillView];
                        break;
                    }
                    case CellViewFillTypeSingle:
                    {
                        for (NSInteger j = column + 1; j < columnNumber ; j++) {
                            UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, singleWidth, heightOfCell)];
                            fillView.backgroundColor = self.viewConfig.fillViewColor;
                            fillView.left = xOriginPos + (CGFloat)j * (fillView.width + lineWidth);
                            fillView.top = fillYPos;
                            [contentView addSubview:fillView];
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }

    // 获取最终计算后整个view的高度
    allHeight += self.viewConfig.contentEdgeInsets.bottom;
    self.contentView.height = allHeight;
    self.contentView.width = viewFinalWidth;
    // 更新总高度
    self.size = self.contentView.size;
}

- (UIView *)createSingleView:(CGSize)size index:(NSInteger)index {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(singleCellViewInCollection:cellIndex:)] ) {
        return [self.dataSource singleCellViewInCollection:size cellIndex:index];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

#pragma mark - Setter or Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = ({
            UIView *view = [UIView new];
            view;
        });
    }
    return _contentView;
}

@end
