//
//  FDSettingViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/20.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDSettingViewController.h"

@interface FDSettingViewController ()

@property (nonatomic, strong) UIImageView *tintedImageView;
@property (nonatomic, strong) UIView *colorView;

@end

@implementation FDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Load the image
    UIImage *shinobiHead = [UIImage imageNamed:@"icon_male"];
    // Set the rendering mode to respect tint color
    shinobiHead = [shinobiHead imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // And set to the image view
    self.tintedImageView.image = shinobiHead;
    self.tintedImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *superView = self.view;
    [superView addSubview:self.tintedImageView];
    [superView addSubview:self.colorView];
    [self.tintedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.right.equalTo(superView).offset(-10);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView);
        make.left.equalTo(superView).offset(-10);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    
    self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    //self.dimTintSwitch.on = NO;
}

- (IBAction)changeColorHandler:(id)sender {
    // Generate a random color
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.tintColor = color;
    [self updateProgressViewTint];
}

- (IBAction)dimTintHandler:(id)sender {
//    if(self.dimTintSwitch.isOn) {
//        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
//    } else {
//        self.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
//    }
    [self updateProgressViewTint];
    
}

- (void)updateProgressViewTint
{
    //self.progressView.progressTintColor = self.view.tintColor;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = ({
            UIView *view = [UIView new];
            view;
        });
    }
    return _colorView;
}

- (UIImageView *)tintedImageView {
    if (!_tintedImageView) {
        _tintedImageView = ({
            UIImageView *view = [UIImageView new];
            view;
        });
    }
    return _tintedImageView;
}

@end
