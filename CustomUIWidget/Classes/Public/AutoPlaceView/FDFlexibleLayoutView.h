//
//  FDFlexibleLayoutView.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FlexibleLayoutYType) {
    FlexibleLayoutYTypeTop,
    FlexibleLayoutYTypeBottom,
    FlexibleLayoutYTypeCenter,
};

@interface UIView(FlexibleLayoutViewInfo)

@property (nonatomic, assign) CGFloat  flexibleLayoutViewLeftMargin; // 单个view距离左边的距离
@property (nonatomic, assign) CGFloat  flexibleLayoutViewRightMargin;    // 单个view距离右边的距离
@property (nonatomic, assign) FlexibleLayoutYType  flexibleLayoutViewYType; // 单个view y轴的位置

@property (nonatomic, assign) CGFloat  flexibleLayoutViewMinWidthLimit; // 针对adjustView可伸缩view的最小缩短宽度

@end

@interface FDFlexibleLayoutView : UIView

@property (nonatomic, strong) UIView *adjustView;
@property (nonatomic, strong) NSArray<UIView *> *fixedViews;

- (void)reloadUI;

@end

NS_ASSUME_NONNULL_END
