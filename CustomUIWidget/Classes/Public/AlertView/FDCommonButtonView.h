//
//  FDCommonButtonView.h
//  funnydate
//
//  Created by hexiang on 2019/3/27.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define gFDCommonButtonViewDefaultWidth   212
#define gFDCommonButtonViewDefaultHeight  50

@class FDCommonButtonView;
typedef void(^FDCommonButtonClickBlock)(FDCommonButtonView *buttonView);

@interface FDCommonButtonViewConfigure : NSObject

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, strong) UIColor *subtitleColor;

@property (nonatomic, strong) UIColor *startGradientColor;
@property (nonatomic, strong) UIColor *endGradientColor;

@property (nonatomic, assign) CGFloat  buttonTopMargin;
@property (nonatomic, assign) CGFloat  buttonBottomMargin;

@end

@interface FDCommonButtonView : UIView

@property (nonatomic, strong) FDCommonButtonClickBlock clickBlock;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *mainTitleLabel;
@property (nonatomic, strong, readonly) UILabel *detailInfoLabel;

+ (instancetype)FDCommonButtonViewWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDCommonButtonViewConfigure *)config;

@end

NS_ASSUME_NONNULL_END
