//
//  FDMarqueeView.h
//  funnydate
//
//  Created by hexiang on 2020/2/21.
//  Copyright © 2020 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FDMarqueeViewScrollDirection) {
    FDMarqueeViewScrollDirectionLeft,   // 往左滚动
    FDMarqueeViewScrollDirectionRight,  // 往右滚动
};

typedef NS_ENUM(NSUInteger, FDMarqueeCustomViewYPosition) {
    FDMarqueeCustomViewYPositionCenter, // 默认居中
    FDMarqueeCustomViewYPositionTop,    // 贴顶
    FDMarqueeCustomViewYPositionBottom, // 贴底
};

@interface FDMarqueeViewConfig : NSObject

@property (nonatomic, strong) UIView *customView;   //自定义的视图(必须有大小)
@property (nonatomic, assign) FDMarqueeCustomViewYPosition  yPosition;  // 自定义视图y轴位置

@property (nonatomic, assign) NSInteger  frameInterval; //多少帧回调一次，一帧时间1/60秒 (值越大速度越慢，默认1帧)
@property (nonatomic, assign) CGFloat  contentMargin;   //两个视图之间的间隔（默认30）
@property (nonatomic, assign) CGFloat  pointsPerFrame;  //每次回调移动多少点(值越小 速度越慢，默认0.5)

@property (nonatomic, assign) CGFloat  maxTimeLimit;    //滚动的最大时长
@property (nonatomic, assign) CGFloat  scrollPauseTime; //滚动一遍暂停的时长（默认0即不暂停）

@property (nonatomic, assign) FDMarqueeViewScrollDirection  scrollDirection;    //滚动方向

@property (nonatomic, assign) BOOL  isLessLengthScroll; // customView宽度小于本身view是否可滚动（默认YES）

@end

@interface FDMarqueeView : UIView

@property (nonatomic, strong) void(^scrollCompleteBlock)(FDMarqueeView *fdMarqueeView); // 滚动完成自动停止

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDMarqueeViewConfig *)config;

- (void)startMarquee;

- (void)stopMarquee;

/// 自定义view大小有变动的时候，需要重新reload
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
