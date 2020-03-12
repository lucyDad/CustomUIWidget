//
//  FDCommonButtonView.m
//  funnydate
//
//  Created by hexiang on 2019/3/27.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import "FDCommonButtonView.h"
#import <Masonry/Masonry.h>
#import "FDCustomUIWidgetDef.h"

static CGSize const kSizeOfIconImageView = (CGSize){40, 40};

@implementation FDCommonButtonViewConfigure

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleFont = FONT_REGULAR_WITH_SIZE(15);
        self.titleColor = [UIColor whiteColor];
        
        self.subtitleFont = FONT_REGULAR_WITH_SIZE(12);
        self.subtitleColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8f];
        
        self.startGradientColor = [UIColor colorWithRed:253.0/255.0f green:142.0/255.0f blue:110.0/255.0f alpha:1.0f];
        self.endGradientColor = [UIColor colorWithRed:255.0/255.0f green:46.0/255.0f blue:127.0/255.0f alpha:1.0f];
        
        self.buttonTopMargin = 9;
        self.buttonBottomMargin = 9;
    }
    return self;
}

@end

@interface FDCommonButtonView ()
{
    
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@property (nonatomic, strong, readwrite) UILabel *mainTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *detailInfoLabel;

@property (nonatomic, strong) FDCommonButtonViewConfigure *viewConfig;

@end

@implementation FDCommonButtonView

#pragma mark - Public Interface

+ (instancetype)FDCommonButtonViewWithFrame:(CGRect)frame andTitle:(NSString *)title {
    FDCommonButtonViewConfigure *config = [FDCommonButtonViewConfigure new];
    config.title = title;
    FDCommonButtonView *view = [[FDCommonButtonView alloc] initWithFrame:frame andConfig:config];
    return view;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDCommonButtonViewConfigure *)config {
    CGRect newFrame = frame;
    if (CGSizeEqualToSize(CGSizeZero, frame.size)) {
        newFrame.size = CGSizeMake(gFDCommonButtonViewDefaultWidth, gFDCommonButtonViewDefaultHeight);
    }
    self = [super initWithFrame:newFrame];
    if (self) {
        self.viewConfig = config;
        [self setupUI];
        
        [self setupData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andConfig:[FDCommonButtonViewConfigure new]];
}

- (void)dealloc {
    //DLog(@"%s: ", __func__);
}

#pragma mark - Event Response

- (void)selectButtonAction:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    if (self.clickBlock) {
        self.clickBlock(weakSelf);
    }
}

#pragma mark - Private Methods

- (void)setupUI {
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (nil != self.viewConfig.iconImage) {
        [self layoutHadImage];
    } else {
        [self layoutNoImage];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupData {
    UIImage *gradientImage = [UIImage imageWithColors:@[(id)self.viewConfig.startGradientColor.CGColor, (id)self.viewConfig.endGradientColor.CGColor] size:self.bounds.size cornerRadius:self.bounds.size.height / 2.0f];
    self.backgroundImageView.image = gradientImage;
    
    self.iconImageView.image = self.viewConfig.iconImage;
    
    self.mainTitleLabel.text = self.viewConfig.title;
    
    self.detailInfoLabel.text = self.viewConfig.subTitle;
}

- (void)layoutNoImage {
    
    UIView *superView = self;
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.mainTitleLabel];
    if ( 0 != self.viewConfig.subTitle.length) {
        self.detailInfoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailInfoLabel];
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.top.equalTo(superView).offset(self.viewConfig.buttonTopMargin);
            make.height.equalTo(@(16));
        }];
        [self.detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.mainTitleLabel);
            make.bottom.equalTo(superView).offset(-self.viewConfig.buttonBottomMargin);
            make.height.equalTo(@(12));
        }];
        
    } else {
        
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView);
            make.right.equalTo(superView);
            make.top.bottom.equalTo(superView);
        }];
    }
}

- (void)layoutHadImage {
    
    UIView *superView = self;
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(superView).offset(5);
        make.bottom.equalTo(superView).offset(-5);
        make.width.equalTo(self.iconImageView.mas_height);
    }];
    
    [self addSubview:self.mainTitleLabel];
    if (0 != self.viewConfig.subTitle.length) {
        [self addSubview:self.detailInfoLabel];
        
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(5);
            make.top.equalTo(self.iconImageView.mas_top).offset(3);
            make.right.equalTo(superView);
            make.height.equalTo(@(21));
        }];
        [self.detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.mainTitleLabel);
            make.top.equalTo(self.mainTitleLabel.mas_bottom);
            make.height.equalTo(@(17));
        }];
        
    } else {
        
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(5);
            make.centerY.equalTo(self.iconImageView.mas_centerY);
            make.right.equalTo(superView);
            make.height.equalTo(@(21));
        }];
    }
}

#pragma mark - Setter or Getter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _backgroundImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = kSizeOfIconImageView.width / 2.0f;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _iconImageView;
}

- (UILabel *)mainTitleLabel {
    if (!_mainTitleLabel) {
        _mainTitleLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = self.viewConfig.titleColor;
            label.font = self.viewConfig.titleFont;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _mainTitleLabel;
}

- (UILabel *)detailInfoLabel {
    if (!_detailInfoLabel) {
        _detailInfoLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = self.viewConfig.subtitleColor;
            label.font = self.viewConfig.subtitleFont;
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _detailInfoLabel;
}

@end
