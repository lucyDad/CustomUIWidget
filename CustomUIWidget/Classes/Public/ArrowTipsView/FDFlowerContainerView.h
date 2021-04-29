//
//  FDFlowerContainerView.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDFlowerContainerViewConfig : NSObject

@property (nonatomic, assign) BOOL  isOval;

@property (nonatomic, assign) UIEdgeInsets  contentEdgeInsets;

@property (nonatomic, strong) CAGradientLayer *gradientBackgroundLayer; ///> 渐变层，可根据提供的工具函数生成传入，有默认渐变颜色的配置

+ (CAGradientLayer *)gradientLayerWith:(NSArray<UIColor *> *)colors
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint;

@end

@interface FDFlowerContainerView : UIView

@property (nonatomic, strong, readonly) FDFlowerContainerViewConfig *viewConfig;

+ (instancetype)flowerContainerView:(NSAttributedString *)attrString backgroundColor:(UIColor *)backgroundColor;

- (instancetype)initWithConfig:(FDFlowerContainerViewConfig *)config customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
