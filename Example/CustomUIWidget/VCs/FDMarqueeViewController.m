//
//  FDMarqueeViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/21.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDMarqueeViewController.h"
#import "CustomUIWidget.h"
#import <Masonry/Masonry.h>

@interface FDMarqueeViewController ()

@end

@implementation FDMarqueeViewController

+ (NSString *)componetName {
    return @"跑马灯";
}

+ (UIView *)exampleShowView:(CGSize)containerSize {

    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"跑马灯示例,详细使用点击进入";
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        label;
    });
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig new];
    config.customView = titleLabel;
    config.scrollDirection = FDMarqueeViewScrollDirectionLeft;
    config.maxTimeLimit = 100;
    config.scrollPauseTime = 1;
    config.yPosition = FDMarqueeCustomViewYPositionTop;
    
    FDMarqueeView *view = [[FDMarqueeView alloc] initWithFrame:CGRectMake(0, 0, containerSize.width, 20) andConfig:config];
    view.backgroundColor = [UIColor redColor];
    
    [view startMarquee];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testNormal];
}

- (void)testNormal {
    CGFloat allWidth = self.view.bounds.size.width;
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig new];
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"CocoaPods是iOS，Mac下优秀的第三方包管理工具，类似于java的maven，给我们项目管理带来了极大的方便。个人或公司在开发过程中，会积累很多可以复用的代码包，有些我们不想开源，又想像开源库一样在CocoaPods中管理它们，那么通过私有仓库来管理就很必要";
        [label sizeToFit];
        label;
    });
    
    config.customView = titleLabel;
    config.scrollDirection = FDMarqueeViewScrollDirectionLeft;
    config.maxTimeLimit = 100;
    config.scrollPauseTime = 1;
    config.yPosition = FDMarqueeCustomViewYPositionTop;
    
    CGFloat leftMargin = allWidth * 0.32;
    CGFloat rightMargin = allWidth * 0.12;
    CGFloat viewWidth = allWidth - leftMargin - rightMargin;
    CGFloat viewHeight = config.customView.bounds.size.height;
    
    FDMarqueeView *view = [[FDMarqueeView alloc] initWithFrame:CGRectZero andConfig:config];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    view.scrollCompleteBlock = ^(FDMarqueeView * _Nonnull fdMarqueeView) {
        [fdMarqueeView removeFromSuperview];
    };
    
    UIView *superView = self.view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(200);
        make.left.equalTo(superView).offset(100);
        make.right.equalTo(superView).offset(-100);
        make.height.mas_equalTo(30);
    }];
    [view startMarquee];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        titleLabel.text = @"有些我们不想开源，又想像开源库一样在CocoaPods中管理它们";
        [titleLabel sizeToFit];
        [view reloadData];
        [view startMarquee];
    });
}

- (void)testAutoLayout {
    
    CGFloat allWidth = self.view.bounds.size.width;
    CGFloat contentViewHeight = 300;
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig new];
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.text = nil;//@"优秀的第三方包管理工具";
        //label.text = @"CocoaPods是iOS，Mac下优秀的第三方包管理工具，类似于java的maven，给我们项目管理带来了极大的方便。个人或公司在开发过程中，会积累很多可以复用的代码包，有些我们不想开源，又想像开源库一样在CocoaPods中管理它们，那么通过私有仓库来管理就很必要";
        [label sizeToFit];
        label;
    });
    
    config.customView = titleLabel;
    config.scrollDirection = FDMarqueeViewScrollDirectionLeft;
    config.maxTimeLimit = 100;
    config.scrollPauseTime = 1;
    config.isLessLengthScroll = YES;
    config.yPosition = FDMarqueeCustomViewYPositionTop;
    
    CGFloat leftMargin = allWidth * 0.32;
    CGFloat rightMargin = allWidth * 0.12;
    CGFloat viewWidth = allWidth - leftMargin - rightMargin;
    CGFloat viewHeight = config.customView.bounds.size.height;
    
    FDMarqueeView *view = [[FDMarqueeView alloc] initWithFrame:CGRectZero andConfig:config];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    view.scrollCompleteBlock = ^(FDMarqueeView * _Nonnull fdMarqueeView) {
        [fdMarqueeView removeFromSuperview];
    };
    
    UIView *superView = self.view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(200);
        make.left.equalTo(superView).offset(100);
        make.right.equalTo(superView).offset(-100);
        make.height.mas_equalTo(30);
    }];
    [view startMarquee];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        titleLabel.text = @"有些我们不想开源，又想像开源库一样在CocoaPods中管理它们";
        [titleLabel sizeToFit];
        [view reloadData];
        [view startMarquee];
    });
}

@end
