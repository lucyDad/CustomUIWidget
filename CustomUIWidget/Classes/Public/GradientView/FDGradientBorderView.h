//
//  FDGradientView.h
//  ZAIssue
//
//  Created by hexiang on 2021/4/15.
//  Copyright © 2021 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDGradientBorderView : UIView

// 
@property (nonatomic, strong, readonly) CAGradientLayer * gradientLayer;

// 边框宽度
@property (nonatomic, assign) CGFloat  lineWidth;
// 圆角
@property (nonatomic, assign) CGFloat  cornerRadius;

// 自定义path
@property (nonatomic, strong) UIBezierPath *customPath;

@end

NS_ASSUME_NONNULL_END
