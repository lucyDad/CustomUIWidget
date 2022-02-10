//
//  FDSelectListView.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/1/24.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import "FDSelectListView.h"
#import "UIButton+FDSelectState.h"

@interface FDSelectListView ()
{
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FDOrderedDictionary<NSString *, NSNumber *> *arrOriginDatas;
@end

@implementation FDSelectListView

#pragma mark - Public Method

+ (instancetype)selectListView:(FDOrderedDictionary<NSString *, NSNumber *> *)datas width:(CGFloat)width {
    FDSelectListView *view = [FDSelectListView new];
    view.width = width;
    view.arrOriginDatas = datas;
    [view setupUI];
    return view;
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

- (void)layoutSubviews {
    
}

#pragma mark - Event Response

- (void)clickButtonAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    sender.buttonStateType = !sender.buttonStateType;

    NSString *key = self.arrOriginDatas.allKeys[index];
    [self.arrOriginDatas setObject:@(sender.buttonStateType) forKey:key];
    __weak typeof(self)weakSelf = self;
    if (self.clickListCell) {
        self.clickListCell(weakSelf, index, weakSelf.arrOriginDatas);
    }
}

#pragma mark - Private Methods

- (void)setupUI {
    if (0 == self.arrOriginDatas.count) {
        return;
    }
    [self removeAllSubviews];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.frame), 40);
    __block CGFloat yPos = 0;
    [self.arrOriginDatas.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isSelect = [self.arrOriginDatas[obj] boolValue];
        UIView *view = [self generateSingleView:obj index:idx isSelect:isSelect];
        view.size = size;
        view.top = yPos;
        yPos += size.height;
        
        [self addSubview:view];
    }];
    
    self.height = yPos;
}

- (UIView *)generateSingleView:(NSString *)text index:(NSUInteger)index isSelect:(BOOL)isSelect {
    
    UIView *superView = [UIView new];
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorHex(999999);
        label.font = FONT_REGULAR_WITH_SIZE(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = text;
        label;
    });
    UIButton *selectButton = [UIButton FDSelectStateButton];
    selectButton.buttonStateType = (isSelect ? FDSelectStateButtonTypeSelected : FDSelectStateButtonTypeDefault);
    selectButton.tag = index;
    [selectButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:titleLabel];
    [superView addSubview:selectButton];
    
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.right.equalTo(superView);
        make.size.mas_equalTo(selectButton.size);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(superView);
        make.right.equalTo(selectButton.mas_left).offset(-10);
    }];
    return superView;
}

#pragma mark - Setter or Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorHex(333333);
            label.font = FONT_REGULAR_WITH_SIZE(14);
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _titleLabel;
}

@end
