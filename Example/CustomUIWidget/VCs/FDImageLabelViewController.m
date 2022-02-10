//
//  FDImageLabelViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/28.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDImageLabelViewController.h"
#import "CustomUIWidget.h"
#import <Masonry/Masonry.h>

@interface FDImageLabelViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) NSArray *arrDatas;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FDImageLabelView *imageLabelView;
@end

@implementation FDImageLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.arrDatas = @[@"调整spacing", @"调整image"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *superView = self.view;
    [superView addSubview:self.containerView];
    [superView addSubview:self.stepper];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(10);
        make.left.right.equalTo(superView);
        make.height.mas_equalTo(100);
    }];
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom);
        make.left.equalTo(superView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    self.pickerView.frame = CGRectMake(10, 300, 200, 100);
    [self testOnlyText];
}

- (void)testOnlyText {
    self.imageLabelView = ({
        FDImageLabelView *labelView = [FDImageLabelView new];
        labelView.backgroundColor = [UIColor orangeColor];
        labelView.spacing = 10;
        labelView.style = FDImagePositionStyleRight;
        labelView.isRelyOnImage = NO;
        labelView.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
        labelView;
    });
    self.imageLabelView.text = @"hello world";
    self.imageLabelView.left = 10;
    self.imageLabelView.top = 100;
    [self.view addSubview:self.imageLabelView];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.arrDatas.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.arrDatas[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == row) {
        self.imageLabelView.spacing = 0;
    } else {
        UIImage *image = [UIImage imageNamed:@"icon_1" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        self.imageLabelView.iconImageView.image = image;
        [self.imageLabelView reloadData];
    }
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = ({
            UIView *view = [UIView new];
            view;
        });
    }
    return _containerView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = ({
            UIPickerView *view = [UIPickerView new];
            view.dataSource = self;
            view.delegate = self;
            view;
        });
    }
    return _pickerView;
}

- (UIStepper *)stepper {
    if (!_stepper) {
        _stepper = ({
            UIStepper *view = [UIStepper new];
            view;
        });
    }
    return _stepper;
}

@end
