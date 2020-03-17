//
//  FDAnimationManagerView.h
//  funnydate
//
//  Created by hexiang on 2019/3/29.
//  Copyright © 2019 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FDAnimationManagerShowType) {
    FDAnimationManagerShowTypeBottom,   ///> 从底部弹起的动画
    FDAnimationManagerShowTypeMiddle,   ///> 从中间隐入的动画
};

@interface FDAnimationManagerViewConfig : NSObject

@property (nonatomic, assign) BOOL  isNeedAnimation; ///> 是否需要动画 默认YES
@property (nonatomic, assign) FDAnimationManagerShowType  managerType;  ///> 显示位置 默认Bottom
@property (nonatomic, strong) UIColor *backgroundColor; // 默认[UIColor colorWithHexString:@"000000" alpha:0.4]
@property (nonatomic, assign) CGFloat  animationTime;   // 默认0.3
@property (nonatomic, assign) CGPoint  centerPoint;     // 中间点的位置(FDAnimationManagerShowTypeMiddle时才有效, 默认屏幕中间)

@property (nonatomic, strong) UIView *animationContainerView; // 需要动画的view

@end

@class FDAnimationManagerView;
typedef void(^FDAnimationManagerViewClickBlock)(FDAnimationManagerView *animationView);

@interface FDAnimationManagerView : UIView

@property (nonatomic, strong, readonly) FDAnimationManagerViewConfig *config; ///> 配置参数
/**
 点击背景处理的回调，不传则内部默认会remove，外部自己实现了的话需自己手动移除
 */
@property (nonatomic, strong) FDAnimationManagerViewClickBlock clickBackgroundBlock;

/**
 快捷初始化方法，使用默认的配置参数

 @param animationView 需要动画的view
 @return 背景+动画处理实例
 */
+ (instancetype)FDAnimationManagerView:(UIView *)animationView;

/**
 初始化方法

 @param frame 整个背景view的frame
 @param config 配置参数
 @return 背景+动画处理实例
 */
- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDAnimationManagerViewConfig *)config;

/**
 显示传入容器view的动画

 @param completeBlock 动画完成回调
 */
- (void)showAnimationManagerView:(void(^)(void))completeBlock;

/**
 消失传入容器view的动画

 @param completeBlock 动画完成回调
 */
- (void)dismissAnimationManagerView:(void(^)(void))completeBlock;

@end
