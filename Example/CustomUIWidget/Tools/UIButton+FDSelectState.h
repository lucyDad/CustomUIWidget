//
//  UIButton+FDSelectState.h
//  funnydate
//
//  Created by hexiang on 2019/3/27.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define gFDSelectStateButtonDefaultWidth   24
#define gFDSelectStateButtonDefaultHeight  24

typedef NS_ENUM(NSInteger, FDSelectStateButtonType) {
    FDSelectStateButtonTypeDefault,
    FDSelectStateButtonTypeSelected
};

@interface UIButton (FDSelectState)

+ (instancetype)FDSelectStateButton;

+ (instancetype)FDSelectStateButton:(CGSize)size borderWidth:(CGFloat)borderWidth;

@property (nonatomic, assign) FDSelectStateButtonType  buttonStateType;

@end

NS_ASSUME_NONNULL_END
