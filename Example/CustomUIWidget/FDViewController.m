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
#import "UIView+ArrowTipsView.h"
#import <YYCategories/YYCategories.h>
#import <YYText/YYText.h>
#import "FDAutoPlaceView.h"
#import "FDUserInfoModel.h"

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

#pragma mark - 自动换行排列view3

- (void)testFunction3 {
    CGFloat maxWidth = kScreenWidth;
    FDAutoPlaceViewConfig *config = [FDAutoPlaceViewConfig new];
    config.contentEdgeInsets = UIEdgeInsetsMake(30, 5, 50, 20);
    config.contentRowInterval = 10;
    config.contentColumnInterval = 10;
    FDAutoPlaceView *placeView = [[FDAutoPlaceView alloc] initWithMaxWidth:maxWidth andConfig:config];
    placeView.left = 0;
    placeView.top = 80;
    placeView.backgroundColor = [UIColor redColor];
    
    FDUserInfoModel *model = [FDUserInfoModel new];
    CGFloat height = [FDAutoPlaceView allHeightOfAutoPlaceView:maxWidth config:config viewProtocol:model];
    NSLog(@"height = %f", height);
    placeView.placeViewProtocol = model;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    @weakify(placeView);
    [tapGes addActionBlock:^(id  _Nonnull sender) {
        @strongify(placeView);
        [placeView removeFromSuperview];
    }];
    [placeView addGestureRecognizer:tapGes];
    [self.view addSubview:placeView];
}

#pragma mark - 箭头view2

- (void)testFunction2 {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    FDArrowTipsViewConfig *config = [FDArrowTipsViewConfig new];
    config.contentCornerRadius = 10;
    config.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    config.originDirection = FDArrowDirection_Top;
    config.gradientBackgroundLayer = [FDArrowTipsViewConfig gradientLayerWith:@[UIColorHex(FF8754), UIColorHex(FF2475)]];
    config.arrowSize = CGSizeMake(6, 4);
    config.isStartTimer = NO;
    config.autoTimeOutClose = YES;
    config.timeOutTime = 5;
    config.animationTime = 0.0f;
    config.autoAdjustPos = YES;
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@"限时开放" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    attrText.yy_alignment = NSTextAlignmentCenter;
    
    CGPoint point = CGPointMake(100, 80);
//    [cell showArrowTipsViewWithConfig:config andText:attrText andRealSize:CGSizeMake(0, 0) andArrowPoint:point andActionBlock:^BOOL(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
//        NSLog(@"actionType = %ld", actionType);
//        return YES;
//    }];
    
    [cell showArrowTipsBackgroundViewWithConfig:config andText:attrText andRealSize:CGSizeMake(0, 0) andArrowPoint:point andActionBlock:^BOOL(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        NSLog(@"actionType = %ld", actionType);
        return YES;
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
    
    return 88;
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
            NSArray *view = @[@"自定义跑马灯0", @"自定义弹框1", @"箭头view2", @"自动换行排列view3"];
            view;
        });
    }
    return _arrData;
}

@end

