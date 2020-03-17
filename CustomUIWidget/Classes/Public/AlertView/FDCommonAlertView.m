//
//  FDCommonAlertView.m
//  funnydate
//
//  Created by hexiang on 2019/3/30.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "FDCommonAlertView.h"
#import "FDCommonButtonView.h"
#import <YYText/YYText.h>
#import "FDCustomUIWidgetDef.h"

static CGFloat const kAlertViewContentMargin = 25;
static NSInteger const kTagForLabelInTitleView = 1000;

static NSInteger const kTagForCancelButton = 1001;
static NSInteger const kTagForConfirmButton = 1002;

@implementation FDCommonAlertViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.confirmTitle = @"确认";
        self.cancelTitle = @"取消";
        self.content = @"";
        self.content = @"";
        self.isNeedCloseButton = NO;
        self.isOnlyConfirmButton = NO;
        
        self.isNeedTimer = NO;
        self.countDownTime = 15;
        self.isTimerInCancelButton = NO;
    }
    return self;
}

@end

@interface FDCommonAlertView ()
{
    NSTimer *_timer;
    NSInteger _currentSeconds;
}

@property (nonatomic, strong) FDCommonAlertViewConfig *viewConfig;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) YYLabel *subContentLabel;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation FDCommonAlertView

#pragma mark - Public Interface

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDCommonAlertViewConfig *)config customView:(UIView * __nullable)customView {
    self = [super initWithFrame:frame];
    if (self) {
        self.customView = customView;
        self.viewConfig = config;
        [self setupUI];
    }
    return self;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andConfig:[FDCommonAlertViewConfig new] customView:nil];
}

- (void)dealloc {
    NSLog(@"%s: ", __func__);
    [self stopTimer];
}

#pragma mark - Event Response

- (void)closeButtonClickAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    if (self.clickBlock) {
        self.clickBlock(weakSelf, FDAlertViewClickTypeClose);
    }
}

- (void)cancelButtonClickAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    if (self.clickBlock) {
        self.clickBlock(weakSelf, FDAlertViewClickTypeCancel);
    }
}

- (void)timerEndAction:(id)sender {
    _currentSeconds++;
    
    if (_currentSeconds > self.viewConfig.countDownTime) {
        [self stopTimer];
        __weak typeof(self)weakSelf = self;
        if (self.clickBlock) {
            self.clickBlock(weakSelf, FDAlertViewClickTypeTimeout);
        }
        return;
    }
    
    NSInteger leftSeconds = self.viewConfig.countDownTime - _currentSeconds;
    [self updateCountDownUI:leftSeconds];
}

#pragma mark - Private Methods

#pragma mark -- 定时器

- (void)startTimer:(NSInteger)interval {
    [self stopTimer];
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerEndAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (nil != _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark -- UI

- (void)updateCountDownUI:(NSInteger)leftSeconds {

    if (self.viewConfig.isTimerInCancelButton) {
        UIButton *cancelButton = [self viewWithTag:kTagForCancelButton];
        [cancelButton setTitle:[NSString stringWithFormat:@"%@(%ld)", self.viewConfig.cancelTitle, (long)leftSeconds] forState:UIControlStateNormal];
    } else {
        FDCommonButtonView *confirmButton = [self viewWithTag:kTagForConfirmButton];
        confirmButton.mainTitleLabel.text = [NSString stringWithFormat:@"%@(%ld)", self.viewConfig.confirmTitle, (long)leftSeconds];
    }
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 9;
    self.layer.masksToBounds = YES;
    
    BOOL isShowTitle = (0 == self.viewConfig.title.length ? NO : YES);
    if (isShowTitle) {
        // title的样式
        [self layoutTitleStyleType];
    } else {
        //
        [self layoutNoTitleStyleType];
    }
    
    if (self.viewConfig.isNeedTimer) {
        [self updateCountDownUI:self.viewConfig.countDownTime];
        [self startTimer:1];
    }
}

- (void)layoutContentStyleType:(NSAttributedString *)attText {
    
    CGFloat maxWidth = self.width;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) insets:UIEdgeInsetsMake(0, kAlertViewContentMargin, 0, kAlertViewContentMargin)];
    container.maximumNumberOfRows = 3;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attText];
    self.contentLabel.textLayout = layout;
    self.contentLabel.size = CGSizeMake(layout.container.size.width, layout.textBoundingSize.height);
    self.contentLabel.centerX = self.width / 2.0f;
}

- (void)layoutSubContentStyleType:(NSAttributedString *)attText {
    
    CGFloat maxWidth = self.width;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) insets:UIEdgeInsetsMake(0, kAlertViewContentMargin, 0, kAlertViewContentMargin)];
    container.maximumNumberOfRows = 3;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attText];
    self.subContentLabel.textLayout = layout;
    self.subContentLabel.size = CGSizeMake(layout.container.size.width, layout.textBoundingSize.height);
    self.subContentLabel.centerX = self.width / 2.0f;
}

- (void)layoutTitleStyleType {
    CGFloat maxWidth = self.width;
    CGFloat height = 0.0f;
    CGFloat contentTopMargin = 8 ;
    CGFloat buttonTopMargin = 15 ;
    CGFloat buttonBottomMargin = 16;
    
    [self addSubview:self.titleView];
    UILabel *titleLabel = [self.titleView viewWithTag:kTagForLabelInTitleView];
    titleLabel.text = self.viewConfig.title;
    
    CGFloat buttonTopYPos = 0.0f;
    if (nil == self.customView) {
        NSAttributedString *attText = ( nil != self.viewConfig.attributedContent ? self.viewConfig.attributedContent : [self getContentAttrWithTitle]);
        [self layoutContentStyleType:attText];
        
        self.contentLabel.top = CGRectGetMaxY(self.titleView.frame) + contentTopMargin;
        [self addSubview:self.contentLabel];
        
        buttonTopYPos = CGRectGetMaxY(self.contentLabel.frame) + buttonTopMargin;
        BOOL isShowSubContent = (0 == self.viewConfig.subContent.length ? NO : YES);
        if (isShowSubContent) {
            [self layoutSubContentStyleType:( nil != self.viewConfig.subAttributedContent ? self.viewConfig.subAttributedContent : [self getSubContentAttrText])];
            self.subContentLabel.top = CGRectGetMaxY(self.contentLabel.frame) + 15;
            [self addSubview:self.contentLabel];
            buttonTopYPos = CGRectGetMaxY(self.subContentLabel.frame) + 15;
        }
    } else {
        self.customView.width = MIN(self.customView.width, self.width - 2 * kAlertViewContentMargin);
        self.customView.centerX = self.width / 2.0f;
        self.customView.top = CGRectGetMaxY(self.titleView.frame) + contentTopMargin;
        [self addSubview:self.customView];
        buttonTopYPos = CGRectGetMaxY(self.customView.frame) + buttonTopMargin;
    }

    height = [self layoutButtons:maxWidth topOffset:buttonTopYPos];
    height = height + buttonBottomMargin;
    
    self.height = height;
}

- (void)layoutNoTitleStyleType {
    CGFloat maxWidth = self.width;
    CGFloat height = 0.0f;
    CGFloat contentTopMargin = 40;
    CGFloat buttonTopMargin = 20;
    CGFloat buttonBottomMargin = 25;
    //
    CGFloat contentTopYPos = contentTopMargin;
    if (self.viewConfig.isNeedCloseButton) {
        self.closeButton.right = self.width - 8;
        self.closeButton.top = 8;
        [self addSubview:self.closeButton];
    } else {
        contentTopYPos = 25;
    }
    
    CGFloat buttonTopYPos = 0.0f;
    if (nil == self.customView) {
        NSAttributedString *attText = ( nil != self.viewConfig.attributedContent ? self.viewConfig.attributedContent : [self getContentAttrWithNoTitle]);
        [self layoutContentStyleType:attText];
        
        self.contentLabel.top = contentTopYPos;
        [self addSubview:self.contentLabel];
        
        buttonTopYPos = CGRectGetMaxY(self.contentLabel.frame) + buttonTopMargin;
        BOOL isShowSubContent = (0 == self.viewConfig.subContent.length ? NO : YES);
        if (isShowSubContent) {
            [self layoutSubContentStyleType:( nil != self.viewConfig.subAttributedContent ? self.viewConfig.subAttributedContent : [self getSubContentAttrText])];
            self.subContentLabel.top = CGRectGetMaxY(self.contentLabel.frame) + 15;
            [self addSubview:self.subContentLabel];
            buttonTopYPos = CGRectGetMaxY(self.subContentLabel.frame) + 15;
        }
    } else {
        self.customView.width = MIN(self.customView.width, self.width - 2 * kAlertViewContentMargin);
        self.customView.centerX = self.width / 2.0f;
        self.customView.top = contentTopYPos;
        [self addSubview:self.customView];
        buttonTopYPos = CGRectGetMaxY(self.customView.frame) + buttonTopMargin;
    }
    
    height = [self layoutButtons:maxWidth topOffset:buttonTopYPos];
    height = height + buttonBottomMargin;
    
    self.height = height;
}

- (CGFloat)layoutButtons:(CGFloat)maxWidth topOffset:(CGFloat)buttonTopYPos {
    CGFloat buttonWidth = (maxWidth - 2 * kAlertViewContentMargin);
    CGSize  buttonSize = CGSizeMake(buttonWidth, gFDCommonButtonViewDefaultHeight);
    if (!self.viewConfig.isOnlyConfirmButton) {
        // 有两个按钮，按钮的间距为10， 高度为40
        buttonWidth = (maxWidth - 2 * kAlertViewContentMargin - 10 ) / 2.0f;
        buttonSize = CGSizeMake(buttonWidth, 40);
        
        UIButton *cancelButton = [self createCancelButton:buttonSize];
        [cancelButton setTitle:self.viewConfig.cancelTitle forState:UIControlStateNormal];
        cancelButton.left = kAlertViewContentMargin;
        cancelButton.top = buttonTopYPos;
        [self addSubview:cancelButton];
    }
    
    FDCommonButtonViewConfigure *config = [FDCommonButtonViewConfigure new];
    config.title = self.viewConfig.confirmTitle;
    config.subTitle = self.viewConfig.confirmSubTitle;
    config.subtitleColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6f];
    config.buttonTopMargin = 5;
    config.buttonBottomMargin = 3.5;
    FDCommonButtonView *confirmView = [[FDCommonButtonView alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height) andConfig:config];
    confirmView.top = buttonTopYPos;
    confirmView.right = maxWidth - kAlertViewContentMargin;
    @weakify(self);
    confirmView.clickBlock = ^(FDCommonButtonView * _Nonnull buttonView) {
        @strongify(self);
        if (self.clickBlock) {
            self.clickBlock(self, FDAlertViewClickTypeConfirm);
        }
    };
    confirmView.tag = kTagForConfirmButton;
    [self addSubview:confirmView];
    
    return CGRectGetMaxY(confirmView.frame);
}

- (UIButton *)createCancelButton:(CGSize)size {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [button setTitleColor:[UIColor colorWithRed:133.0/255.0f green:112.0/255.0f blue:241.0/255.0f alpha:1.0f] forState:UIControlStateNormal];
    button.titleLabel.font = FONT_REGULAR_WITH_SIZE(15);
    button.backgroundColor = [UIColor clearColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = size.height / 2.0f;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithRed:133.0/255.0f green:112.0/255.0f blue:241.0/255.0f alpha:1.0f].CGColor;
    [button addTarget:self action:@selector(cancelButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = kTagForCancelButton;
    return button;
}

- (NSAttributedString *)getContentAttrWithTitle {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:self.viewConfig.content];
    attText.yy_font = FONT_REGULAR_WITH_SIZE(15);
    attText.yy_color = UIColorHex(666666);
    attText.yy_lineSpacing = 4;
    attText.yy_alignment = NSTextAlignmentCenter;
    [attText addAttribute:NSKernAttributeName value:@(1) range:attText.yy_rangeOfAll];
    return attText;
}

- (NSAttributedString *)getContentAttrWithNoTitle {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:self.viewConfig.content];
    attText.yy_font = FONT_REGULAR_WITH_SIZE(15);
    attText.yy_color = UIColorHex(333333);
    attText.yy_lineSpacing = 4;
    attText.yy_alignment = NSTextAlignmentCenter;
    [attText addAttribute:NSKernAttributeName value:@(1) range:attText.yy_rangeOfAll];
    return attText;
}

- (NSAttributedString *)getSubContentAttrText {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:self.viewConfig.subContent];
    attText.yy_font = FONT_REGULAR_WITH_SIZE(14);
    attText.yy_color = UIColorHex(FF2E7F);
    attText.yy_lineSpacing = 4;
    attText.yy_alignment = NSTextAlignmentCenter;
    [attText addAttribute:NSKernAttributeName value:@(1) range:attText.yy_rangeOfAll];
    return attText;
}

#pragma mark - Setter or Getter

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            YYLabel *label = [[YYLabel alloc] init];
            label.displaysAsynchronously = YES;
            label.ignoreCommonProperties = YES;
            label.fadeOnAsynchronouslyDisplay = NO;
            label.fadeOnHighlight = NO;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _contentLabel;
}

- (YYLabel *)subContentLabel {
    if (!_subContentLabel) {
        _subContentLabel = ({
            YYLabel *label = [[YYLabel alloc] init];
            label.displaysAsynchronously = YES;
            label.ignoreCommonProperties = YES;
            label.fadeOnAsynchronouslyDisplay = NO;
            label.fadeOnHighlight = NO;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _subContentLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            UIImage *image = [UIImage imageNamed:@"icon_XiangQin_close_gray" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _closeButton;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = ({
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
            
            CGFloat margin = 10;
            UILabel *titleLabel = ({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.width - 2 * margin, containerView.height)];
                label.left = margin;
                label.backgroundColor = [UIColor clearColor];
                label.textColor = UIColorHex(333333);
                label.font = [UIFont systemFontOfSize:18];
                label.textAlignment = NSTextAlignmentCenter;
                label.tag = kTagForLabelInTitleView;
                label;
            });
            UIView *lineView = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerView.width, 1)];
                view.backgroundColor = UIColorHex(F5F5F5);
                view;
            });
            
            lineView.bottom = containerView.height;
            self.closeButton.right = containerView.width - 8;
            self.closeButton.top = 8;
            
            [containerView addSubview:titleLabel];
            [containerView addSubview:lineView];
            if (self.viewConfig.isNeedCloseButton) {
                [containerView addSubview:self.closeButton];
            }
            
            containerView;
        });
    }
    return _titleView;
}

@end
