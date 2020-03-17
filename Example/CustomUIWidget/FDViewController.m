//
//  FDViewController.m
//  CustomUIWidget
//
//  Created by lucyDad on 03/11/2020.
//  Copyright (c) 2020 lucyDad. All rights reserved.
//

#import "FDViewController.h"
#import <Masonry/Masonry.h>
#import "FDMarqueeView.h"
#import "UIView+FDAlertView.h"

static NSString *kTableViewCellReuseIdentifier =  @"kTableViewCellReuseIdentifier";

@interface FDViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;

@end

@implementation FDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

#pragma mark - 自定义弹框1

- (void)testFunction1 {
    FDCommonAlertViewConfig *config = [FDCommonAlertViewConfig new];
    config.content = @"优秀的第三方包管理工具";
    [self.view showFDAlertViewWithConfig:config customView:nil clickBlock:^(FDAlertViewClickType clickType) {
        if (FDAlertViewClickTypeConfirm == clickType) {
            
        }
    }];
}

#pragma mark - 自定义跑马灯0

- (void)testFunction0 {
    CGFloat allWidth = self.view.bounds.size.width;
    CGFloat contentViewHeight = 300;
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
    
    CGFloat leftMargin = allWidth * 0.32;
    CGFloat rightMargin = allWidth * 0.12;
    CGFloat viewWidth = allWidth - leftMargin - rightMargin;
    CGFloat viewHeight = config.customView.bounds.size.height;
    
    FDMarqueeView *view = [[FDMarqueeView alloc] initWithFrame:CGRectMake(leftMargin, (contentViewHeight - viewHeight) / 2.0f, viewWidth, viewHeight) andConfig:config];
    [self.view addSubview:view];
    view.scrollCompleteBlock = ^(FDMarqueeView * _Nonnull fdMarqueeView) {
        [fdMarqueeView removeFromSuperview];
    };
    [view startMarquee];
}

#pragma mark - Delegates

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    NSString *text = self.arrData[indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"testFunction%ld", indexPath.row]) withObject:nil];
#pragma clang diagnostic pop
    
}

#pragma mark - Private Methods

#pragma mark - Setter or Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
            tableView.dataSource = self;
            tableView.delegate   = self;
            tableView;
        });
    }
    return _tableView;
}

- (NSArray *)arrData {
    if (!_arrData) {
        _arrData = ({
            NSArray *view = @[@"自定义跑马灯0", @"自定义弹框1"];
            view;
        });
    }
    return _arrData;
}

@end

