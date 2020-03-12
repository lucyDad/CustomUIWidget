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

@interface FDMarqueeViewConfig : NSObject

@property (nonatomic, strong) UIView *customView;   //自定义的视图

@property (nonatomic, assign) NSInteger  frameInterval; //多少帧回调一次，一帧时间1/60秒 (值越大速度越慢，默认1帧)
@property (nonatomic, assign) CGFloat  contentMargin;   //两个视图之间的间隔（默认30）
@property (nonatomic, assign) CGFloat  pointsPerFrame;  //每次回调移动多少点(值越小 速度越慢，默认0.5)

@property (nonatomic, assign) CGFloat  maxTimeLimit;    //滚动的最大时长
@property (nonatomic, assign) CGFloat  scrollPauseTime; //滚动一遍暂停的时长（默认0即不暂停）

@property (nonatomic, assign) FDMarqueeViewScrollDirection  scrollDirection;    //滚动方向

@end

@interface FDMarqueeView : UIView

@property (nonatomic, strong) void(^scrollCompleteBlock)(FDMarqueeView *fdMarqueeView); // 滚动完成自动停止

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDMarqueeViewConfig *)config;

- (void)startMarquee;

@end

NS_ASSUME_NONNULL_END
