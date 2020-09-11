//
//  FDUserInfoModel.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2020/9/11.
//  Copyright © 2020 lucyDad. All rights reserved.
//

#import "FDUserInfoModel.h"
#import <YYCategories/YYCategories.h>

@implementation FDUserInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.nickName = @"这是一个独立的程序，并不依赖于具体app，专门用于app clips所必需的功能";
        self.gender = 1;
        self.age = 25;
        self.workcity = @"广东深圳";
        self.height = 178;
        self.medalInfos = @[@"kobe", @"wade", @"dirk"];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (NSArray<UIView *> *)viewsInAutoPlaceView {
    if (nil != self.autoPlaceViews) {
        return self.autoPlaceViews;
    }
    NSMutableArray *arrViews = [NSMutableArray array];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.nickName;
        [label sizeToFit];
        label;
    });
    
    UIImageView *genderImageView = ({
        NSString *iconName = (self.gender ? @"icon_male": @"icon_female");
        UIImage *image = [UIImage imageNamed:iconName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.placeViewLeftMargin = 0;
        imageView.placeViewRightMargin = 0;
        imageView;
    });
    UIImageView *guardImageView = ({
        UIImage *image = [UIImage imageNamed:@"icon_guard" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.placeViewLeftMargin = 0;
        imageView.placeViewRightMargin = 0;
        imageView;
    });
    UIImageView *vipImageView = ({
        UIImage *image = [UIImage imageNamed:@"icon_vip" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.placeViewLeftMargin = 0;
        imageView.placeViewRightMargin = 0;
        imageView;
    });
    UIButton *charmButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 16)];
        UIImage *image = [UIImage imageNamed:@"icon_charm" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
        }];
        button.placeViewLeftMargin = 0;
        button.placeViewRightMargin = 0;
        button;
    });
    UIButton *guardkingButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 105)];
        UIImage *image = [UIImage imageNamed:@"icon_guardking" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
        }];
        button.placeViewLeftMargin = 0;
        button.placeViewRightMargin = 0;
        button;
    });
    
    [arrViews addObjectsFromArray:@[titleLabel, genderImageView, guardkingButton, guardImageView, vipImageView, charmButton]];
    [self.medalInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = obj;
        [label sizeToFit];
        
        [arrViews addObject:label];
    }];
    
    UILabel *contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%@ | %@ | %@", self.workcity, @(self.age), @(self.height)];
        [label sizeToFit];
        label.width = kScreenWidth;  // 需要独占一行
        label;
    });
    [arrViews addObject:contentLabel];
    
    self.autoPlaceViews = arrViews;
    return self.autoPlaceViews;
}

@end
