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
#import "FDCollectionCellViewHelper.h"
#import "CustomUIWidget.h"

static NSString *kTableViewCellReuseIdentifier =  @"kTableViewCellReuseIdentifier";

@interface FDViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIWindow *_tmpWindow;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) FDCollectionCellViewHelper *cellHelper;

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

- (NSArray<UIView *> *)generateViews {
    
    UIImageView *matchmakerImageView = ({
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"icon_matckmaker"];
        imageView.image = image;
        [imageView sizeToFit];
        imageView;
    });
    UIImageView *vipImageView = ({
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"icon_vip"];
        imageView.image = image;
        [imageView sizeToFit];
        imageView;
    });
    UIImageView *sexImageView = ({
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"icon_male"];
        imageView.image = image;
        [imageView sizeToFit];
        imageView;
    });
    UIView *addressView = ({
        UIView *superView = [UIView new];
        superView.backgroundColor = UIColorHex(F4F4F4);
        UILabel *addressLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorHex(999999);
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        addressLabel.text = @"28.广东";
        [addressLabel sizeToFit];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        addressLabel.left = edgeInsets.left;
        addressLabel.top = edgeInsets.top;
        
        [superView addSubview:addressLabel];
        CGSize size = CGSizeMake(edgeInsets.left + edgeInsets.right + addressLabel.width, edgeInsets.top + edgeInsets.bottom + addressLabel.height);
        superView.size = size;
        superView.layer.cornerRadius = size.height / 2.0f;
        superView.layer.masksToBounds = YES;
        superView;
    });
    
    UILabel *timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorHex(333333);
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"2020年12月24";
        [label sizeToFit];
        label;
    });
    
    NSMutableArray *flagViews = [NSMutableArray array];
    if (NO) {
        [flagViews addObject:matchmakerImageView];
    }
    if (YES) {
        [flagViews addObject:vipImageView];
    }
    if (NO) {
        [flagViews addObject:addressView];
    }
    if (YES) {
        [flagViews addObject:sexImageView];
    }
    if (YES) {
        [flagViews addObject:timeLabel];
    }
    
    matchmakerImageView.flexibleLayoutViewLeftMargin = 5;
    matchmakerImageView.flexibleLayoutViewRightMargin = 5;
    matchmakerImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
    
    vipImageView.flexibleLayoutViewLeftMargin = 5;
    vipImageView.flexibleLayoutViewRightMargin = 5;
    vipImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
    
    sexImageView.flexibleLayoutViewLeftMargin = 5;
    sexImageView.flexibleLayoutViewRightMargin = 5;
    sexImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
    
    addressView.flexibleLayoutViewLeftMargin = 5;
    addressView.flexibleLayoutViewRightMargin = 5;
    addressView.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
    
    timeLabel.flexibleLayoutViewLeftMargin = 2;
    timeLabel.flexibleLayoutViewRightMargin = 2;
    timeLabel.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
    
    return flagViews;
}

#pragma mark - 单行自动缩放view6

- (void)testFunction6 {
    CGSize size = CGSizeMake(300, 80);
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"红娘真心宝贝";
        [label sizeToFit];
        label.flexibleLayoutViewLeftMargin = 10;
        label.flexibleLayoutViewRightMargin = 5;
        label.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
        label.flexibleLayoutViewMinWidthLimit = 30;
        label;
    });
    [[self.view viewWithTag:9999] removeFromSuperview];

    FDFlexibleLayoutView *layoutView = [FDFlexibleLayoutView new];
    layoutView.backgroundColor = [UIColor redColor];
    layoutView.left = 100;
    layoutView.top = 200;
    layoutView.size = size;
    layoutView.adjustView = titleLabel;
    layoutView.fixedViews = [self generateViews];
    [layoutView reloadUI];
    layoutView.tag = 9999;
    [self.view addSubview:layoutView];
}

#pragma mark - 长按拖动view5

- (void)testFunction5 {
    // 示例一: UIView
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor redColor];
        label.size = CGSizeMake(80, 80);
        label.top = 200;
        label.left = 20;
        label.userInteractionEnabled = YES;
        label;
    });
    [self.view addSubview:titleLabel];
    titleLabel.longPressDragEdgeInsets = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height + 10, 10, 40, 10);
    [titleLabel addLongPressDragGestureRecognizer];
    
    // 示例二: UIWindow
    UIWindow *view = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    view.backgroundColor = [UIColor redColor];
    view.windowLevel = UIWindowLevelAlert + 10;
    view.hidden = NO;
    view.clipsToBounds = YES;
    view.right = [UIScreen mainScreen].bounds.size.width - 20;
    view.top = 200;
    view.longPressDragEdgeInsets = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height + 10, 10, 40, 10);
    [view addLongPressDragGestureRecognizer];
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.size = CGSizeMake(40, 40);
    [view addSubview:greenView];
    
    _tmpWindow = view;
}

#pragma mark - 格子view4

- (void)testFunction4 {
    FDCollectionCellViewHelperConfig *config = [FDCollectionCellViewHelperConfig new];
    config.maxWidth = 300;
    config.titleColor = [UIColor redColor];
    config.titleFont = [UIFont boldSystemFontOfSize:16];
    config.isAllowSelect = YES;
    config.isAllowCancelSelect = YES;
    config.selectImage = [UIImage imageWithColor:[UIColor systemPinkColor]];
    self.cellHelper = [[FDCollectionCellViewHelper alloc] initWithConfig:config];
    
    FDCollectionCellViewConfig *cellConfig = [FDCollectionCellViewConfig new];
    cellConfig.lineWidth = 0.5f;
    cellConfig.lineColor = [UIColor redColor];
    cellConfig.contentEdgeInsets = UIEdgeInsetsMake(cellConfig.lineWidth, cellConfig.lineWidth, cellConfig.lineWidth, cellConfig.lineWidth);
    cellConfig.fillType = CellViewFillTypeSingle;
    [self.cellHelper.cellView reloadViewConfig:cellConfig];
    
    NSDictionary *dic1 = ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[gCollectionCellIconUrlDataKey] = @"https://quyuehui-1251661065.image.myqcloud.com/photo/user/53956999/8c98345634904a42b5aa543f570ed956.jpg";
        dic[gCollectionCellNameDataKey] = @"简简单单";
        dic[gCollectionCellDescriptionDataKey] = @"广东 | 深圳";
        dic;
    });
    NSDictionary *dic2 = ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[gCollectionCellIconUrlDataKey] = @"https://quyuehui-1251661065.image.myqcloud.com/photo/user/64111992/ceb73d0f2a074712aa56a93a8b192e5c.jpg";
        dic[gCollectionCellNameDataKey] = @"金金";
        dic[gCollectionCellDescriptionDataKey] = @"湖南 | 株洲";
        dic;
    });
    NSArray *arrData = @[dic1, dic2, dic1, dic2, dic1];
    [self.cellHelper reloadArrDatas:arrData];
    
    self.cellHelper.cellView.top = 50;
    
    @weakify(self);
    self.cellHelper.clickSelectCellBlock = ^(NSDictionary * _Nonnull selectData, BOOL isSelect) {
        @strongify(self);
        NSLog(@"selectData = %@, isSelect = %d", selectData, isSelect);
        //[self.cellHelper.cellView removeFromSuperview];
    };
    [self.view addSubview:self.cellHelper.cellView];
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
            NSArray *view = @[@"自定义跑马灯0", @"自定义弹框1", @"箭头view2", @"自动换行排列view3", @"格子view4", @"长按拖动view5", @"单行自动缩放view6"];
            view;
        });
    }
    return _arrData;
}

@end

