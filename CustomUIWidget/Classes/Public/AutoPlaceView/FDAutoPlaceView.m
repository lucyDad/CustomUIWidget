//
//  FDAutoPlaceView.m
//  CustomUIWidget
//
//  Created by hexiang on 2020/9/10.
//

#import "FDAutoPlaceView.h"
#import <objc/runtime.h>
#import "UIView+YYAdd.h"

@implementation NSObject(AutoPlacePositionInfo)

- (NSArray<UIView *> *)autoPlaceViews {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoPlaceViews:(NSArray<UIView *> *)autoPlaceViews {
    objc_setAssociatedObject(self, @selector(autoPlaceViews), autoPlaceViews, OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation UIView(AutoPlacePositionInfo)

- (NSInteger)rowForAutoPlaceView {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setRowForAutoPlaceView:(NSInteger)rowForAutoPlaceView {
    objc_setAssociatedObject(self, @selector(rowForAutoPlaceView), @(rowForAutoPlaceView), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)placeViewLeftMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setPlaceViewLeftMargin:(CGFloat)placeViewLeftMargin {
    objc_setAssociatedObject(self, @selector(placeViewLeftMargin), @(placeViewLeftMargin), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)placeViewRightMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setPlaceViewRightMargin:(CGFloat)placeViewRightMargin {
    objc_setAssociatedObject(self, @selector(placeViewRightMargin), @(placeViewRightMargin), OBJC_ASSOCIATION_RETAIN);
}

@end

@implementation FDAutoPlaceViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        self.contentSingleViewInterval = 5;
        self.contentEachLineInterval = 5;
    }
    return self;
}

@end

@interface FDAutoPlaceView ()
{
    
}

@property (nonatomic, strong) FDAutoPlaceViewConfig *config;

@property (nonatomic, assign) CGFloat  maxWidth;

@end

@implementation FDAutoPlaceView

#pragma mark - Public Interface

- (void)setPlaceViewProtocol:(id<FDAutoPlaceViewProtocol>)placeViewProtocol {
    if ( ![placeViewProtocol respondsToSelector:@selector(viewsInAutoPlaceView)] ) {
        return;
    }
    _placeViews = [placeViewProtocol viewsInAutoPlaceView];
    
    [self reloadUI];
}

- (void)setPlaceViews:(NSArray<UIView *> *)placeViews {
    _placeViews = placeViews;
    
    [self reloadUI];
}

+ (CGFloat)allHeightOfAutoPlaceView:(CGFloat)maxWidth
                             config:(FDAutoPlaceViewConfig *)config
                       viewProtocol:(id<FDAutoPlaceViewProtocol>)viewProtocol {
    if ( ![viewProtocol respondsToSelector:@selector(viewsInAutoPlaceView)] ) {
        return 0.0f;
    }
    NSArray *placeViews = [viewProtocol viewsInAutoPlaceView];
    return [self allHeightOfAutoPlaceView:maxWidth config:config views:placeViews];
}

#pragma mark - Life Cycle

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth andConfig:(FDAutoPlaceViewConfig *)config views:(nullable NSArray<UIView *> *)views {
    maxWidth = ( 0 != maxWidth ? maxWidth : [UIScreen mainScreen].bounds.size.width);
    self = [super initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    if (self) {
        self.maxWidth = maxWidth;
        self.config = config;
        self.placeViews = views;
    }
    return self;
}

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth
                       andConfig:(FDAutoPlaceViewConfig *)config
                    viewProtocol:(id<FDAutoPlaceViewProtocol>)viewProtocol {
    NSArray *placeViews = nil;
    if ( [viewProtocol respondsToSelector:@selector(viewsInAutoPlaceView)] ) {
        placeViews = [viewProtocol viewsInAutoPlaceView];
    }
    return [self initWithMaxWidth:maxWidth andConfig:config views:placeViews];
}

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth andConfig:(FDAutoPlaceViewConfig *)config {
    return [self initWithMaxWidth:maxWidth andConfig:config views:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithMaxWidth:frame.size.width andConfig:[FDAutoPlaceViewConfig new] views:nil];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Event Response

#pragma mark - Private Methods

- (void)reloadUI {
    [self removeAllSubviews];
    
    CGFloat contentMaxWidth = self.maxWidth - self.config.contentEdgeInsets.left - self.config.contentEdgeInsets.right;   // 每行的最大显示宽度
    __block CGFloat placeViewY = self.config.contentEdgeInsets.top;
    NSArray<NSNumber *> *heights = [FDAutoPlaceView heightsOfAutoPlaceView:self.maxWidth config:self.config views:self.placeViews];
    
    __block CGFloat recordMaxWidth = 0.0f;
    [heights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull rowHeight, NSUInteger rowIdx, BOOL * _Nonnull stop) {
        
        CGFloat centerY = [rowHeight floatValue] / 2.0f;
        __block CGFloat placeViewX = self.config.contentEdgeInsets.left;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %ld", @"rowForAutoPlaceView", rowIdx + 1];
        NSArray<UIView *> *filterViews = [self.placeViews filteredArrayUsingPredicate:predicate];
        [filterViews enumerateObjectsUsingBlock:^(UIView * _Nonnull placeView, NSUInteger placeIdx, BOOL * _Nonnull stop) {
            placeView.width = MIN(placeView.width, contentMaxWidth);
            CGFloat left = placeViewX + placeView.placeViewLeftMargin;
            placeView.left = left;
            placeView.centerY = placeViewY + centerY;
            
            [self addSubview:placeView];
            
            placeViewX = CGRectGetMaxX(placeView.frame) + placeView.placeViewRightMargin + self.config.contentSingleViewInterval;
        }];
        
        placeViewY += [rowHeight floatValue] + self.config.contentEachLineInterval;
        
        if (placeViewX + self.config.contentEdgeInsets.right > recordMaxWidth) {
            recordMaxWidth = placeViewX + self.config.contentEdgeInsets.right;
        }
    }];
    
    CGFloat viewHeight = placeViewY + self.config.contentEdgeInsets.bottom;
    self.height = viewHeight;
    
    if (self.config.isAutoUpdateWidth) {
        self.width = recordMaxWidth;
    } else {
        self.width = self.maxWidth;
    }
    
    NSLog(@"hexiang size = %@", NSStringFromCGSize((CGSize){recordMaxWidth, viewHeight}));
}

+ (CGFloat)allHeightOfAutoPlaceView:(CGFloat)maxWidth
                             config:(FDAutoPlaceViewConfig *)config
                              views:(NSArray<UIView *> *)views {
    
    __block CGFloat placeViewY = config.contentEdgeInsets.top;
    NSArray<NSNumber *> *heights = [FDAutoPlaceView heightsOfAutoPlaceView:maxWidth config:config views:views];
    [heights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull rowHeight, NSUInteger rowIdx, BOOL * _Nonnull stop) {
        placeViewY += [rowHeight floatValue] + config.contentEachLineInterval;
    }];
    
    CGFloat viewHeight = placeViewY + config.contentEdgeInsets.bottom;
    return viewHeight;
}

+ (NSArray<NSNumber *> *)heightsOfAutoPlaceView:(CGFloat)maxWidth
                                         config:(FDAutoPlaceViewConfig *)config
                                          views:(NSArray<UIView *> *)views {
    CFTimeInterval startTime = CACurrentMediaTime();
    
    if (0 == views.count ) {
        return nil;
    }

    CGFloat contentMaxWidth = maxWidth - config.contentEdgeInsets.left - config.contentEdgeInsets.right;   // 每行的最大显示宽度
    CGFloat rowInterval = config.contentSingleViewInterval;    // 每行内的间距
    __block NSMutableArray *arrHeight = [NSMutableArray array]; // 记录每行的高度列表
    __block NSInteger row = 1;  // 记录总的行数
    __block CGFloat leftWidth = contentMaxWidth;    // 初始剩余的宽度
    __block CGFloat maxHeight = 0;  // 初始当前行最大的高度
    NSInteger allCount = views.count;
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull placeView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize viewSize = placeView.size;
        CGFloat allViewWidth = viewSize.width + placeView.placeViewLeftMargin + placeView.placeViewRightMargin + rowInterval; // 总宽度(每个view自己的前后间距再加上总内容定义的元素之间间距)
        allViewWidth = MIN(allViewWidth, contentMaxWidth); // 最大不能超过contentMaxWidth
        if (leftWidth < allViewWidth) {
            // 当前行剩余宽度不能容纳新的勋章，需要另起一行
            row++;
            // 1. 剩余宽度重置为下一行的宽度
            // 2. 同时保存上一行的最大高度(需加上每行的下面间距)
            // 3. 并且重置下一行的高度为当前需要换行的勋章高度
            leftWidth = contentMaxWidth;
            [arrHeight addObject:@(maxHeight)];
            maxHeight = viewSize.height;
        } else {
            // 不需要换行，则计算最大高度
            maxHeight = MAX(maxHeight, viewSize.height);
        }
        leftWidth -= allViewWidth; // 剩余宽度递减
        
        // 最后一行(或者只有一行)需要加上高度
        if (idx == allCount - 1) {
            [arrHeight addObject:@(maxHeight)];
        }
        
        // 为每个view挂载计算好的信息
        placeView.rowForAutoPlaceView = row;
        
        NSLog(@"FDAutoPlaceView>>>row = %zd leftWidth = %f, maxHeight = %f", row, leftWidth, maxHeight);
    }];
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval consumingTime = endTime - startTime;
    NSLog(@"FDAutoPlaceView>>>%@, row = %zd arrHeight = %@", @(consumingTime), row, arrHeight);
    return arrHeight;
}

#pragma mark - Setter or Getter

@end
