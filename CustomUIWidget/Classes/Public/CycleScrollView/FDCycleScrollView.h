//
//  FDCycleScrollView.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 滚动方向
typedef NS_ENUM(NSUInteger, FDCycleScrollViewScrollDirection) {
    FDCycleScrollViewScrollDirectionHorizontal = 0, // 横向
    FDCycleScrollViewScrollDirectionVertical   = 1  // 纵向
};

@class FDCycleScrollView;

@protocol FDCycleScrollViewDataSource <NSObject>

/// 返回cell个数
/// @param cycleScrollView 当前实例
- (NSInteger)numberOfCellsInCycleScrollView:(FDCycleScrollView *)cycleScrollView;

@end

@protocol FDCycleScrollViewDelegate <NSObject>

@optional

/// 返回自定义cell尺寸
/// @param cycleScrollView cycleScrollView description
- (CGSize)sizeForCellInCycleScrollView:(FDCycleScrollView *)cycleScrollView;

@end

@interface FDCycleScrollView : UIView

@property (nonatomic, weak) id<FDCycleScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<FDCycleScrollViewDelegate> delegate;

// 滚动方向，默认为横向
@property (nonatomic, assign) FDCycleScrollViewScrollDirection  direction;
// 是否自动滚动，默认YES
@property (nonatomic, assign) BOOL isAutoScroll;
// 自动滚动时间间隔，默认3s
@property (nonatomic, assign) CGFloat autoScrollTime;
// 是否无限循环，默认YES
@property (nonatomic, assign) BOOL isInfiniteLoop;

// 左右间距，默认0
@property (nonatomic, assign) CGFloat leftRightMargin;
// 上下间距，默认0
@property (nonatomic, assign) CGFloat topBottomMargin;

// 默认选中的页码（默认：0）
@property (nonatomic, assign) NSInteger defaultSelectIndex;

@end

NS_ASSUME_NONNULL_END
