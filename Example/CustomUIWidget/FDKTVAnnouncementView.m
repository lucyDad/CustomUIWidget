//
//  FDKTVAnnouncementView.m
//  funnydate
//
//  Created by hexiang on 2021/12/6.
//  Copyright © 2021 zhenai. All rights reserved.
//

#import "FDKTVAnnouncementView.h"
#import <Masonry/Masonry.h>

static UIEdgeInsets const kContentEdgeInsets = (UIEdgeInsets){15, 15, 24, 15};
static CGFloat const kContentMaxHeight = 150;

@interface FDKTVAnnouncementView ()
{
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) MASConstraint *contentSizeConstraint;
@end

@implementation FDKTVAnnouncementView

#pragma mark - Public Method

- (void)updateContent:(NSString *)content {
    self.contentLabel.text = content;
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - kContentEdgeInsets.left - kContentEdgeInsets.right, CGFLOAT_MAX)];
    [self.contentSizeConstraint setSizeOffset:size];
    
    CGSize contentSize = CGSizeMake(ceil(size.width), ceil(size.height) );
    self.scrollView.contentSize = contentSize;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    //DLog(@"%s: ", __func__);
}

#pragma mark - Event Response

- (void)closeButtonClickAction:(UIButton *)sender {
    
}

#pragma mark - Private Methods

- (void)setupUI {
    UIView *superView = self;
    superView.backgroundColor = [UIColor whiteColor];
    
    [superView addSubview:self.titleLabel];
    [superView addSubview:self.closeButton];
    [superView addSubview:self.lineView];
    [superView addSubview:self.scrollView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(superView);
        make.height.mas_equalTo(42);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView).offset(-8);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(kContentEdgeInsets.left);
        make.top.equalTo(self.lineView.mas_bottom).offset(kContentEdgeInsets.top);
        make.right.equalTo(superView).offset(-kContentEdgeInsets.right);
        make.bottom.equalTo(superView).offset(-kContentEdgeInsets.bottom);
    }];
}

#pragma mark - Setter or Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *superView = [UIScrollView new];
            superView.alwaysBounceVertical = YES;
            [superView addSubview:self.contentLabel];
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.equalTo(superView);
                self.contentSizeConstraint = make.size.mas_equalTo(CGSizeZero);
            }];
            superView;
        });
    }
    return _scrollView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorHex(#666666);
            label.font = FONT_REGULAR_WITH_SIZE(15);
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label;
        });
    }
    return _contentLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.size = CGSizeMake(30, 30);
            UIImage *image = [UIImage imageNamed:@"icon_XiangQin_close_gray" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _closeButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColorHex(#F4F4F4);
            view;
        });
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorHex(#333333);
            label.font = FONT_REGULAR_WITH_SIZE(16);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"房间公告";
            label;
        });
    }
    return _titleLabel;
}

@end
