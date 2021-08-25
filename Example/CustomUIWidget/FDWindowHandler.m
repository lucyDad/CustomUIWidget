//
//  FDWindowHandler.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/8/23.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDWindowHandler.h"
#import "FDPopWindowEventModel.h"

@interface FDWindowHandler ()
{
    
}

@property (nonatomic, strong) UIButton *clickButton;

@end

@implementation FDWindowHandler

- (UIView *)popViewInPopWindowManager {
    return self.clickButton;
}

/**
 能够显示的页面VC字符串名称集合
 
 @return VC字符串名称
 */
- (NSArray<NSString *> *)canShowPageListInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return nil;
}

/**
 不能够显示的页面VC字符串名称集合

 @return VC字符串名称
 */
- (NSArray<NSString *> *)canNotShowPageListInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return nil;
}

/**
 在白名单内更细致的判断是否需要显示

 @return 根据各自逻辑处理是否显示
 */
- (BOOL)isNeedShowInPopWindowManager:(NSString *)currentWhitePage {
    NSLog(@"handler>>>currentWhitePage = %@", currentWhitePage);
    return YES;
}

/**
 需要显示的优先级(数值越大优先级越高)
 
 @return 优先级
 */
- (NSInteger)priorityLevelInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return 10;
}

/**
 需要显示的view的停留时长(管理类已有默认值，如需单独处理，可实现此方法)
 
 @return 停留时长
 */
- (NSInteger)popViewStopTimeInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return 15;
}

/**
 弹框view在缓存队列中的缓存时间(管理类已有默认值，如需单独处理，可实现此方法)
 
 @return 缓存时间
 */
- (NSInteger)cacheTimeInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return 30;
}

/**
 弹框view显示的动画
 */
- (void)showPopViewInPopWindowManager:(NSString *)currentShowPage {
    NSLog(@"handler>>>%s, currentShowPage = %@", __func__, currentShowPage);
    self.clickButton.alpha = 0.0f;
    [UIView animateWithDuration:3.0f animations:^{
        self.clickButton.alpha = 1.0f;
    }];
}

/**
 弹框view消失的动画
 
 @param completeBlock 消失的回调
 */
- (void)dismissPopViewInPopWindowManager:(void(^)(void))completeBlock {
    NSLog(@"handler>>>%s", __func__);
    self.clickButton.alpha = 1.0f;
    [UIView animateWithDuration:3.0f animations:^{
        self.clickButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (completeBlock) {
            completeBlock();
        }
    }];
}

- (CGFloat)dismissAnimtionTimeInPopWindowManager {
    return 3.0f;
}

/**
 弹框view消失的回调（不在白名单或者显示时间超时，或者外部自动移除了）

 @param dismissType 消失的类型
 */
- (void)popViewDismissInPopWindowManager:(FDViewDismissType)dismissType event:(nonnull FDPopWindowEventModel *)event {
    NSLog(@"handler>>>%s, dismissType = %ld, sequenceId = %ld", __func__, dismissType, event.sequenceId);
}

#pragma mark - 是否需要添加进队列的规则

/**
 添加时(当上面这个为YES时)是否需要自动过滤黑名单列表(默认YES)

 @return 是否需要自动过滤黑名单列表
 */
- (BOOL)isNeedAutoFilterBlackListInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return YES;
}

/**
 在切换页面时是否需要移除当前页面(仅当window config.strategy配置为FDDissmissStrategyPageChange时有效）
 
 @return VC字符串名称
 */
- (BOOL)isNeedRemoveWhenPageChange:(NSString *)currentPage event:(FDPopWindowEventModel *)event {
    NSLog(@"handler>>>%s, currentPage = %@, sequenceId = %ld", __func__, currentPage, event.sequenceId);
    return YES;
}

/// 返回可点击的范围（默认是view大小，即不透传，返回CGRectZero则全部透传）
- (CGRect)canClickRectInPopWindowManager {
    NSLog(@"handler>>>%s", __func__);
    return CGRectZero;
}

- (void)clickButtonAction:(UIButton *)sender {
    
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = ({
            CGRect frame = CGRectMake(50, 200, 100, 100);
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            [button setTitle:@"click" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            button.backgroundColor = [UIColor redColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _clickButton;
}

@end
