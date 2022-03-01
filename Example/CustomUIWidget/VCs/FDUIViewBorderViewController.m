//
//  FDUIViewBorderViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/1/24.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import "FDUIViewBorderViewController.h"
#import "UIView+UIBorder.h"
#import "FDSelectListView.h"

static CGFloat const kContentMargin = 15;
static CGFloat const kShowViewHeight = 120;
static CGFloat const kHeightCell = 50;
static NSUInteger const kDefaultBorderColorIndex = 0;
static CGFloat const kDefaultBorderWidth = 10.0f;
static CGFloat const kDefaultCornerRadius = 15.0f;

@interface FDUIViewBorderViewController ()

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, strong) UIScrollView *scrollView;
// Datas
@property (nonatomic, strong) FDOrderedDictionary *dicPosition;
@property (nonatomic, strong) FDOrderedDictionary *dicCorners;
@end

@implementation FDUIViewBorderViewController

#pragma mark - Public Interface

+ (NSString *)componetName {
    return @"UIView边框";
}

+ (UIView *)exampleShowView:(CGSize)containerSize {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    CGFloat minValue = MIN(containerSize.width, containerSize.height);
    view.size = CGSizeMake(minValue, minValue);
    
    view.layer.cornerRadius = kDefaultCornerRadius;
    view.fdui_borderLocation = FDUIViewBorderLocationInside;
    view.fdui_borderWidth = kDefaultBorderWidth;
    view.fdui_borderColor = UIColorHex(#6A94DB);
    view.fdui_borderPosition = FDUIViewBorderPositionTop | FDUIViewBorderPositionBottom | FDUIViewBorderPositionLeft | FDUIViewBorderPositionRight;
    return view;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - Event Response

- (void)borderLocationValueChanged:(UISegmentedControl *)sender {
    self.targetView.fdui_borderLocation = sender.selectedSegmentIndex;
}

- (void)borderColorValueChanged:(UISegmentedControl *)sender {
    UIColor *borderColor = [self getColor:sender.selectedSegmentIndex];
    self.targetView.fdui_borderColor = borderColor;
}

- (void)borderWidthTextFieldChangedEvent:(UITextField *)textField {
    self.targetView.fdui_borderWidth = [textField.text floatValue];
}

- (void)cornerRadiusTextFieldChangedEvent:(UITextField *)textField {
    self.targetView.layer.cornerRadius = [textField.text floatValue];
}

#pragma mark - Private Methods

- (UIColor *)themeColor {
    return UIColorHex(#6A94DB);
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupScrollView];
    
    UIView *superView = self.view;
    [superView addSubview:self.targetView];
    CGFloat yPos = CGRectGetMaxY(self.targetView.frame);
    self.scrollView.size = CGSizeMake(ScreenBoundsSize.width, ScreenBoundsSize.height - yPos);
    self.scrollView.top = yPos;
    [superView addSubview:self.scrollView];
}

- (void)setupScrollView {
    UIView *superView = self.scrollView;
    
    CGFloat yPos = 0;
    // location
    {
        UIView *view = [self createLocationView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    
    // position
    {
        UIView *view = [self createPositionView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    
    // borderWidth
    {
        UIView *view = [self createWidthView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    
    // borderColor
    {
        UIView *view = [self createBorderColorView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    
    // cornerRadius
    {
        UIView *view = [self createCornerRadiusView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    
    // maskedCorner
    {
        UIView *view = [self createMaskedCornersView];
        view.top = yPos;
        [superView addSubview:view];
        yPos = CGRectGetMaxY(view.frame);
    }
    self.scrollView.contentSize = CGSizeMake(ScreenBoundsSize.width, yPos);
}

- (UIView *)createMaskedCornersView {
    UIView *superView = [self createCommonView:@"maskedCorners"];
    CGFloat margin = 20;
    FDSelectListView *view = [FDSelectListView selectListView:self.dicCorners width:superView.width - margin];
    @weakify(self);
    view.clickListCell = ^(FDSelectListView * _Nonnull weakListView, NSInteger index, FDOrderedDictionary<NSString *,NSNumber *> * _Nonnull updateDatas) {
        @strongify(self);
        CACornerMask cornerMask = [self getCorners:updateDatas];
        self.targetView.layer.maskedCorners = cornerMask;
    };
    view.top = kHeightCell;
    view.left = margin;
    superView.height = CGRectGetMaxY(view.frame);
    [superView addSubview:view];
    return superView;
}

- (UIView *)createCornerRadiusView {
    UIView *superView = [self createCommonView:@"cornerRadius"];
    UITextField *textField = ({
        UITextField *textField = [self createTextField];
        textField.text = @(kDefaultCornerRadius).stringValue;
        [textField addTarget:self action:@selector(cornerRadiusTextFieldChangedEvent:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });
    textField.centerY = superView.height / 2.0f;
    textField.right = superView.width;
    [superView addSubview:textField];
    return superView;
}

- (UIView *)createBorderColorView {
    UIView *superView = [self createCommonView:@"borderColor"];
    UISegmentedControl *segmentedControl = ({
        UISegmentedControl *view = [[UISegmentedControl alloc] initWithItems:@[@"Translucence", @"Opacity", @"Black"]];
        view.selectedSegmentIndex = kDefaultBorderColorIndex;
        [view addTarget:self action:@selector(borderColorValueChanged:) forControlEvents:UIControlEventValueChanged];
        view;
    });
    segmentedControl.top = kHeightCell;
    segmentedControl.right = superView.width;
    
    superView.height = kHeightCell * 2;
    [superView addSubview:segmentedControl];
    return superView;
}

- (UIView *)createWidthView {
    UIView *superView = [self createCommonView:@"borderWidth"];
    UITextField *textField = ({
        UITextField *textField = [self createTextField];
        textField.text = @(kDefaultBorderWidth).stringValue;
        [textField addTarget:self action:@selector(borderWidthTextFieldChangedEvent:) forControlEvents:UIControlEventEditingChanged];
        textField;
    });;
    textField.centerY = superView.height / 2.0f;
    textField.right = superView.width;
    [superView addSubview:textField];
    return superView;
}

- (UIView *)createPositionView {
    UIView *superView = [self createCommonView:@"borderPosition"];
    CGFloat margin = 20;
    FDSelectListView *view = [FDSelectListView selectListView:self.dicPosition width:superView.width - margin];
    @weakify(self);
    view.clickListCell = ^(FDSelectListView * _Nonnull weakListView, NSInteger index, FDOrderedDictionary<NSString *,NSNumber *> * _Nonnull updateDatas) {
        @strongify(self);
        FDUIViewBorderPosition position = [self getPosition:updateDatas];
        self.targetView.fdui_borderPosition = position;
    };
    view.top = kHeightCell;
    view.left = margin;
    superView.height = CGRectGetMaxY(view.frame);
    [superView addSubview:view];
    return superView;
}

- (UIView *)createLocationView {
    UIView *superView = [self createCommonView:@"borderLocation"];
    UISegmentedControl *segmentedControl = ({
        UISegmentedControl *view = [[UISegmentedControl alloc] initWithItems:@[@"Inside", @"Center", @"Outside"]];
        view.selectedSegmentIndex = FDUIViewBorderLocationInside;
        [view addTarget:self action:@selector(borderLocationValueChanged:) forControlEvents:UIControlEventValueChanged];
        view;
    });
    segmentedControl.centerY = superView.height / 2.0f;
    segmentedControl.right = superView.width;
    [superView addSubview:segmentedControl];
    return superView;
}

- (UIView *)createCommonView:(NSString *)text {
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorHex(333333);
        label.font = FONT_REGULAR_WITH_SIZE(14);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = text;
        [label sizeToFit];
        label.left = 0;
        label.centerY = kHeightCell / 2.0f;
        label;
    });
    UIView *superView = [UIView new];
    CGFloat margin = kContentMargin;
    superView.left = margin;
    superView.size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * margin, kHeightCell);
    [superView addSubview:titleLabel];
    return superView;
}

- (UITextField *)createTextField {
    UITextField *textField = [UITextField new];
    textField.font = FONT_REGULAR_WITH_SIZE(12);
    textField.layer.borderWidth = PixelOne;
    textField.layer.borderColor = UIColorHex(999999).CGColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = self.themeColor;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.size = CGSizeMake(44, 32);
    return textField;
}

#pragma mark - Datas

- (CACornerMask)getCorners:(FDOrderedDictionary<NSString *,NSNumber *> *)datas {
    __block CACornerMask cornerMask = 0;
    [datas.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"MinXMinY"] && [datas[obj] boolValue]) {
            cornerMask |= kCALayerMinXMinYCorner;
        }
        if ([obj isEqualToString:@"MaxXMinY"] && [datas[obj] boolValue]) {
            cornerMask |= kCALayerMaxXMinYCorner;
        }
        if ([obj isEqualToString:@"MinXMaxY"] && [datas[obj] boolValue]) {
            cornerMask |= kCALayerMinXMaxYCorner;
        }
        if ([obj isEqualToString:@"MaxXMaxY"] && [datas[obj] boolValue]) {
            cornerMask |= kCALayerMaxXMaxYCorner;
        }
    }];
    if (0 == cornerMask) {
        // 全部都没有说明是allCorner
        cornerMask = (kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner);
    }
    return cornerMask;
}

- (FDUIViewBorderPosition)getPosition:(FDOrderedDictionary<NSString *,NSNumber *> *)datas {
    __block FDUIViewBorderPosition position = FDUIViewBorderPositionNone;
    [datas.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"Top"] && [datas[obj] boolValue]) {
            position |= FDUIViewBorderPositionTop;
        }
        if ([obj isEqualToString:@"Bottom"] && [datas[obj] boolValue]) {
            position |= FDUIViewBorderPositionBottom;
        }
        if ([obj isEqualToString:@"Left"] && [datas[obj] boolValue]) {
            position |= FDUIViewBorderPositionLeft;
        }
        if ([obj isEqualToString:@"Right"] && [datas[obj] boolValue]) {
            position |= FDUIViewBorderPositionRight;
        }
    }];
    return position;
}

- (UIColor *)getColor:(NSUInteger)index {
    UIColor *borderColor = nil;
    switch (index) {
        case 0:
        {
            borderColor = [self.themeColor colorWithAlphaComponent:.5];
            break;
        }
        case 1:
        {
            borderColor = self.themeColor;
            break;
        }
        case 2:
        default:
        {
            borderColor = [UIColor blackColor];
            break;
        }
    }
    return borderColor;
}

#pragma mark - Setter or Getter

- (UIView *)targetView {
    if (!_targetView) {
        _targetView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor greenColor];
            view.size = CGSizeMake(kShowViewHeight, kShowViewHeight);
            view.top = StatusBarHeight + kNavigationBarHeight + 20;
            view.centerX = [UIScreen mainScreen].bounds.size.width / 2.0f;
            
            view.layer.cornerRadius = kDefaultCornerRadius;
            view.fdui_borderLocation = FDUIViewBorderLocationInside;
            view.fdui_borderWidth = kDefaultBorderWidth;
            view.fdui_borderColor = [self getColor:kDefaultBorderColorIndex];
            view.fdui_borderPosition = [self getPosition:self.dicPosition];
            
            view;
        });
    }
    return _targetView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [UIScrollView new];
            view;
        });
    }
    return _scrollView;
}

- (FDOrderedDictionary *)dicPosition {
    if (!_dicPosition) {
        _dicPosition = ({
            FDOrderedDictionary *dic = [FDOrderedDictionary new];
            [dic addObject:@(YES) forKey:@"Top"];
            [dic addObject:@(YES) forKey:@"Bottom"];
            [dic addObject:@(YES) forKey:@"Left"];
            [dic addObject:@(YES) forKey:@"Right"];
            dic;
        });
    }
    return _dicPosition;
}

- (FDOrderedDictionary *)dicCorners {
    if (!_dicCorners) {
        _dicCorners = ({
            FDOrderedDictionary *dic = [FDOrderedDictionary new];
            [dic addObject:@(YES) forKey:@"MinXMinY"];
            [dic addObject:@(YES) forKey:@"MaxXMinY"];
            [dic addObject:@(YES) forKey:@"MinXMaxY"];
            [dic addObject:@(YES) forKey:@"MaxXMaxY"];
            dic;
        });
    }
    return _dicCorners;
}

@end
