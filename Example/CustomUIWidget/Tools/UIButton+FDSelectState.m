//
//  UIButton+FDSelectState.m
//  funnydate
//
//  Created by hexiang on 2019/3/27.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import "UIButton+FDSelectState.h"

@interface UIButton ()

@property (nonatomic, assign) CGFloat  selectBorderWidth;

@end

@implementation UIButton (FDSelectState)

+ (instancetype)FDSelectStateButton {
    return [self FDSelectStateButton:CGSizeMake(gFDSelectStateButtonDefaultWidth, gFDSelectStateButtonDefaultHeight) borderWidth:2.0f];
}

+ (instancetype)FDSelectStateButton:(CGSize)size borderWidth:(CGFloat)borderWidth {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = size.height / 2.0f;
    button.layer.borderWidth = borderWidth;
    button.width = size.width;
    button.height = size.height;
    button.selectBorderWidth = borderWidth;
    button.buttonStateType = FDSelectStateButtonTypeDefault;
    return button;
}

- (void)setButtonStateType:(FDSelectStateButtonType)buttonStateType {
    objc_setAssociatedObject(self, @selector(buttonStateType), @(buttonStateType), OBJC_ASSOCIATION_RETAIN);
    
    UIButton *button = self;
    switch (buttonStateType) {
        case FDSelectStateButtonTypeDefault:
        {
            button.layer.borderColor = UIColorHex(CCCCCC).CGColor;
            button.layer.borderWidth = self.selectBorderWidth;
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
        case FDSelectStateButtonTypeSelected:
        {
            button.layer.borderColor = nil;
            button.layer.borderWidth = 0.0f;
            UIImage *image = [UIImage imageNamed:@"Common_cellSelect"];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (FDSelectStateButtonType)buttonStateType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (CGFloat)selectBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSelectBorderWidth:(CGFloat)selectBorderWidth {
    objc_setAssociatedObject(self, @selector(selectBorderWidth), @(selectBorderWidth), OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)selectButtonBGImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageWithColors:@[(id)UIColorHex(FF3182).CGColor, (id)UIColorHex(FF6A40).CGColor] size:CGSizeMake(gFDSelectStateButtonDefaultWidth, gFDSelectStateButtonDefaultHeight) cornerRadius:gFDSelectStateButtonDefaultHeight / 2.0f];
    });
    return img;
}

@end
