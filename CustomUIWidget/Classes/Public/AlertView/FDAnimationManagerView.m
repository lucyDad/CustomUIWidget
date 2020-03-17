//
//  FDAnimationManagerView.m
//  funnydate
//
//  Created by hexiang on 2019/3/29.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "FDAnimationManagerView.h"
#import <YYCategories/YYCategories.h>

@implementation FDAnimationManagerViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.4f];
        self.animationTime = 0.3f;
        self.isNeedAnimation = YES;
        self.managerType = FDAnimationManagerShowTypeBottom;
        self.centerPoint = CGPointZero;
    }
    return self;
}

@end

@interface FDAnimationManagerView ()
{
    
}

@property (nonatomic, strong, readwrite) FDAnimationManagerViewConfig *config;

@property (nonatomic, strong, readwrite) UIButton *backgroundButton;

@end

@implementation FDAnimationManagerView

#pragma mark - Public Interface

+ (instancetype)FDAnimationManagerView:(UIView *)animationView {
    FDAnimationManagerViewConfig *config = [FDAnimationManagerViewConfig new];
    config.animationContainerView = animationView;
    FDAnimationManagerView *view = [[FDAnimationManagerView alloc] initWithFrame:[UIScreen mainScreen].bounds andConfig:config];
    
    return view;
}

- (void)showAnimationManagerView:(void(^)(void))completeBlock {
    
    switch (self.config.managerType) {
        case FDAnimationManagerShowTypeBottom:
        {
            if (self.config.isNeedAnimation) {
                [self startBottomAnimation:completeBlock];
            } else{
                UIView *animationView = self.config.animationContainerView;
                CGFloat totalHeight = self.frame.size.height;
                CGFloat contentHeight = animationView.frame.size.height;
                self.config.animationContainerView.top = totalHeight - contentHeight;
            }
            break;
        }
        case FDAnimationManagerShowTypeMiddle:
        {
            if (self.config.isNeedAnimation) {
                [self startMiddleAnimation:completeBlock];
            } else{
                self.config.animationContainerView.center = self.config.centerPoint;
            }
            break;
        }
        default:
            break;
    }
}

- (void)dismissAnimationManagerView:(void(^)(void))completeBlock {
    
    switch (self.config.managerType) {
        case FDAnimationManagerShowTypeBottom:
        {
            if (self.config.isNeedAnimation) {
                [self dismissBottomAnimation:completeBlock];
            } else {
                [self dealWithDismissBlock:completeBlock];
            }
            break;
        }
        case FDAnimationManagerShowTypeMiddle:
        {
            if (self.config.isNeedAnimation) {
                [self dismissMiddleAnimation:completeBlock];
            } else {
                [self dealWithDismissBlock:completeBlock];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDAnimationManagerViewConfig *)config {
    if (CGRectIsEmpty(frame)) {
        frame = [UIScreen mainScreen].bounds;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        if (CGPointEqualToPoint(self.config.centerPoint, CGPointZero)) {
            self.config.centerPoint = CGPointMake(self.width / 2.0f, self.height / 2.0f);
        }
        self.clipsToBounds = YES;
        [self addSubview:self.backgroundButton];
        config.animationContainerView.top = self.height;
        [self addSubview:config.animationContainerView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andConfig:[FDAnimationManagerViewConfig new]];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark -- 动画显示

- (void)startBottomAnimation:(void(^)(void))completeBlock {
    
    [self startBackgroundAnimation:nil];
    
    UIView *animationView = self.config.animationContainerView;
    CGFloat totalHeight = self.height;
    CGFloat contentHeight = animationView.height;
    animationView.top = totalHeight;
    [UIView animateWithDuration:self.config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        animationView.top = totalHeight - contentHeight;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)dismissBottomAnimation:(void(^)(void))completeBlock {
    
    [self dismissBackgroundAnimation:nil];
    
    UIView *animationView = self.config.animationContainerView;
    CGFloat totalHeight = self.height;
    CGFloat contentHeight = animationView.height;
    animationView.top = totalHeight - contentHeight;
    @weakify(self);
    [UIView animateWithDuration:self.config.animationTime animations:^{
        animationView.top = totalHeight;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self dealWithDismissBlock:completeBlock];
    }];
}

- (void)startMiddleAnimation:(void(^)(void))completeBlock {
    
    [self startBackgroundAnimation:nil];
    
    self.config.animationContainerView.center = self.config.centerPoint;
    self.config.animationContainerView.alpha = 0.0f;
    [UIView animateWithDuration:self.config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.config.animationContainerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)dismissMiddleAnimation:(void(^)(void))completeBlock {
    [self dismissBackgroundAnimation:nil];
    
    self.config.animationContainerView.alpha = 1.0f;
    @weakify(self);
    [UIView animateWithDuration:self.config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.config.animationContainerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self dealWithDismissBlock:completeBlock];
    }];
}

- (void)startBackgroundAnimation:(void(^)(void))completeBlock {
    self.backgroundButton.alpha = 0.0f;
    [UIView animateWithDuration:self.config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)dismissBackgroundAnimation:(void(^)(void))completeBlock {
    self.backgroundButton.alpha = 1.0f;
    [UIView animateWithDuration:self.config.animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (void)dealWithDismissBlock:(void(^)(void))completeBlock {
    if (completeBlock) {
        completeBlock();
    } else {
        // 外部调用dismiss调用completeBlock的话默认移除
        [self removeFromSuperview];
    }
}

#pragma mark - Event Response

- (void)backgroundButtonClickAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    if (self.clickBackgroundBlock) {
        self.clickBackgroundBlock(weakSelf);
    } else {
        @weakify(self);
        [self dismissAnimationManagerView:^{
            @strongify(self);
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Private Methods

#pragma mark - Setter or Getter

- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
            button.backgroundColor = self.config.backgroundColor;
            [button addTarget:self action:@selector(backgroundButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _backgroundButton;
}

@end
