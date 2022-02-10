//
//  CALayer+FDUI.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (FDUI)

@property(nonatomic, assign) CGFloat fdui_originCornerRadius;
@property(nonatomic, assign) CACornerMask fdui_originMaskedCorners;
/**
 *  把某个 sublayer 移动到当前所有 sublayers 的最后面
 *  @param sublayer 要被移动的 layer
 *  @warning 要被移动的 sublayer 必须已经添加到当前 layer 上
 */
- (void)fdui_sendSublayerToBack:(CALayer *)sublayer;

/**
 *  把某个 sublayer 移动到当前所有 sublayers 的最前面
 *  @param sublayer 要被移动的layer
 *  @warning 要被移动的 sublayer 必须已经添加到当前 layer 上
 */
- (void)fdui_bringSublayerToFront:(CALayer *)sublayer;

@end

NS_ASSUME_NONNULL_END
