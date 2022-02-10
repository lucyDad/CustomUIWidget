//
//  FDImageLabelView.m
//  funnydate
//
//  Created by hexiang on 2021/11/29.
//  Copyright © 2021 zhenai. All rights reserved.
//

#import "FDImageLabelView.h"
#import <Masonry/Masonry.h>

@interface FDImageLabelView ()
{
    
}

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FDImageLabelView

#pragma mark - Public Interface

- (void)reloadData {
    [self updateStyle];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
    [self updateStyle];
}

- (void)setStyle:(FDImagePositionStyle)style {
    _style = style;
    
    [self updateStyle];
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    
    [self updateStyle];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    
    [self updateStyle];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _spacing = 2.0f;
        _style = FDImagePositionStyleDefault;
        _contentEdgeInsets = UIEdgeInsetsZero;
        _isRelyOnImage = YES;
        
        [self setupUI];
    }
    return self;
}

- (void)dealloc {

}

#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change = %@", change);
    [self updateStyle];
}

#pragma mark - Private Methods

- (void)setupUI {

    UIView *superView = self;
    [superView addSubview:self.iconImageView];
    [superView addSubview:self.titleLabel];
}

- (void)updateStyle {
    [self.iconImageView sizeToFit];
    CGSize imageSize = self.iconImageView.frame.size;
    [self.titleLabel sizeToFit];
    CGSize labelSize = self.titleLabel.frame.size;
    
    if (CGSizeEqualToSize(labelSize, CGSizeZero)) {
        return;
    }
    
    CGFloat viewWidth = self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    CGFloat viewHeight = self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    switch (self.style) {
        case FDImagePositionStyleDefault:
        default:
        {
            viewWidth += CGRectGetWidth(self.iconImageView.frame) + self.spacing + CGRectGetWidth(self.titleLabel.frame);
            CGFloat maxHeight = (self.isRelyOnImage ? CGRectGetHeight(self.iconImageView.frame):  MAX(CGRectGetHeight(self.iconImageView.frame), CGRectGetHeight(self.titleLabel.frame)));
            viewHeight += maxHeight;
            
            self.iconImageView.frame = CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top + (maxHeight - imageSize.height) / 2.0f, imageSize.width, imageSize.height);
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + self.spacing, self.contentEdgeInsets.top + (maxHeight - labelSize.height) / 2.0f, labelSize.width, labelSize.height);
            break;
        }
        case FDImagePositionStyleRight:
        {
            viewWidth += CGRectGetWidth(self.iconImageView.frame) + self.spacing + CGRectGetWidth(self.titleLabel.frame);
            CGFloat maxHeight = (self.isRelyOnImage ? CGRectGetHeight(self.iconImageView.frame):  MAX(CGRectGetHeight(self.iconImageView.frame), CGRectGetHeight(self.titleLabel.frame)));
            viewHeight += maxHeight;
            
            self.titleLabel.frame = CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top + (maxHeight - labelSize.height) / 2.0f, labelSize.width, labelSize.height);
            self.iconImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + self.spacing, self.contentEdgeInsets.top + (maxHeight - imageSize.height) / 2.0f, imageSize.width, imageSize.height);
            break;
        }
        case FDImagePositionStyleTop:
        {
            viewHeight += CGRectGetHeight(self.iconImageView.frame) + self.spacing + CGRectGetHeight(self.titleLabel.frame);
            CGFloat maxWidth = MAX(CGRectGetWidth(self.iconImageView.frame), CGRectGetWidth(self.titleLabel.frame));
            viewWidth += maxWidth;
            
            self.iconImageView.frame = CGRectMake(self.contentEdgeInsets.left + (maxWidth - imageSize.width) / 2.0f, self.contentEdgeInsets.top, imageSize.width, imageSize.height);
            self.titleLabel.frame = CGRectMake(self.contentEdgeInsets.left + (maxWidth - labelSize.width) / 2.0f, CGRectGetMaxY(self.iconImageView.frame) + self.spacing, labelSize.width, labelSize.height);
            break;
        }
        case FDImagePositionStyleBottom:
        {
            viewHeight += CGRectGetHeight(self.iconImageView.frame) + self.spacing + CGRectGetHeight(self.titleLabel.frame);
            CGFloat maxWidth = MAX(CGRectGetWidth(self.iconImageView.frame), CGRectGetWidth(self.titleLabel.frame));
            viewWidth += maxWidth;
            
            self.titleLabel.frame = CGRectMake(self.contentEdgeInsets.left + (maxWidth - labelSize.width) / 2.0f, self.contentEdgeInsets.top, labelSize.width, labelSize.height);
            self.iconImageView.frame = CGRectMake(self.contentEdgeInsets.left +(maxWidth - imageSize.width) / 2.0f, CGRectGetMaxY(self.titleLabel.frame) + self.spacing, imageSize.width, imageSize.height);

            break;
        }
    }

    CGSize viewSize = CGSizeMake(viewWidth, viewHeight);
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, viewSize.width, viewSize.height);
}

#pragma mark - Setter or Getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = ({
            UIImageView *view = [UIImageView new];
            view;
        });
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _titleLabel;
}

@end
