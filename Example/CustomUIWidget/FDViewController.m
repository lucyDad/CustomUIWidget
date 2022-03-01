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
#import <YYWebImage/YYWebImage.h>
#import "FDAutoPlaceView.h"
#import "FDUserInfoModel.h"
#import "FDCollectionCellViewHelper.h"
#import "CustomUIWidget.h"
#import "UIImage+FRColor.h"
#import "FDWindowHandler.h"
#import "FDKTVAnnouncementView.h"
#import "FDTestViewController.h"

static NSString *kTableViewCellReuseIdentifier =  @"kTableViewCellReuseIdentifier";
static NSInteger const kTagForShowView = 1111;

@interface FDViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIWindow *_tmpWindow;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) FDCollectionCellViewHelper *cellHelper;
@property (nonatomic, strong) FDPopWindowManager *windowManager;
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

#pragma mark - Test11

- (void)testFunction11 {
    FDTestViewController *vc = [FDTestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ImageLabel10

- (void)testFunction10 {

    FDImageLabelView *labelView = ({
        FDImageLabelView *view = [FDImageLabelView new];
//        view.left = 10;
//        view.top = 100;
        view.style = FDImagePositionStyleDefault;
        view.spacing = 10;
        view.contentEdgeInsets = UIEdgeInsetsMake(2, 6, 2, 6);
        view.titleLabel.text = @"hexiang";
        view.titleLabel.textColor = [UIColor blackColor];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view.iconImageView.image = [UIImage imageNamed:@"icon_vip"];
    //    [view.iconImageView yy_setImageWithURL:[NSURL URLWithString:@"https://photo.zastatic.com/images/cms/banner/20211126/2569261469449706.png"] placeholder:nil];
        view.backgroundColor = [UIColor redColor];
        view;
    });
    
    UIView *containerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor greenColor];
        view;
    });

    containerView.tag = kTagForShowView;
    [self.view addSubview:containerView];
    UIView *superView = self.view;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(100);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
        make.left.equalTo(superView).offset(10);
    }];
    
    [containerView addSubview:labelView];
}

#pragma mark - 弹框管理9

- (void)testFunction9 {
    FDWindowHandler *handler = [FDWindowHandler new];
    [self.windowManager addHandlers:handler];
}

#pragma mark - 渐变边框view8

- (void)testFunction8 {

    FDGradientBorderView *borderView = ({
        FDGradientBorderView *view = [FDGradientBorderView new];
        view.lineWidth = 20;
        view.cornerRadius = 20;
        view.tag = kTagForShowView;
        view;
    });
    [self.view addSubview:borderView];
    UIView *superView = self.view;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(200);
        make.bottom.equalTo(superView).offset(-200);
        make.left.equalTo(superView).offset(100);
        make.right.equalTo(superView).offset(-100);
    }];
}

#pragma mark - 花瓣形状view7

- (void)testFunction7 {

    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"视频审核状态：未审核--->不通过：删除，这个要发通知吗？【现在是没有发】不通过：删除--->通过A、过B，这个要发通知吗？【现在是发了" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.attributedText = attrString;
        label;
    });

    CGFloat maxWidth = 200;//[UIScreen mainScreen].bounds.size.width - config.contentEdgeInsets.left - config.contentEdgeInsets.right;
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    titleLabel.size = size;

    FDFlowerContainerViewConfig *config = [FDFlowerContainerViewConfig new];
    CGFloat radius = size.height / 2.0f;
    config.contentEdgeInsets = UIEdgeInsetsMake(radius, radius, radius, radius);
    config.isOval = YES;
    config.gradientBackgroundLayer = [FDFlowerContainerViewConfig gradientLayerWith:@[[UIColor redColor], [UIColor greenColor]] startPoint:CGPointZero endPoint:CGPointMake(1, 0)];
    
    FDFlowerContainerView *view = [[FDFlowerContainerView alloc] initWithConfig:config customView:titleLabel];

    view.tag = kTagForShowView;
    view.left = 50;
    view.top = 100;
    [self.view addSubview:view];
}


#pragma mark - 单行自动缩放view6

- (void)testFunction6 {

    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"红娘真心宝贝";
        [label sizeToFit];
        //label.flexibleLayoutViewLeftMargin = 10;
        //label.flexibleLayoutViewRightMargin = 15;
        //label.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
        //label.flexibleLayoutViewMinWidthLimit = 30;
        label;
    });

    CGSize size = CGSizeMake(300, 80);
    FDFlexibleLayoutView *layoutView = [FDFlexibleLayoutView new];
    layoutView.backgroundColor = [UIColor redColor];
    layoutView.left = 100;
    layoutView.top = 200;
    layoutView.size = size;
    layoutView.adjustView = titleLabel;
    
    UIImageView *matchmakerImageView = ({
        UIImageView *imageView = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"icon_matckmaker"];
        imageView.image = image;
        [imageView sizeToFit];
        imageView.flexibleLayoutViewLeftMargin = 20;
        imageView;
    });
    
    layoutView.fixedViews = @[matchmakerImageView];//[self generateViews];
    [layoutView reloadUI];
    layoutView.tag = kTagForShowView;
    [self.view addSubview:layoutView];
    
    
    __block MASConstraint *sizeConstraint = nil;
    UIView *superView = self.view;
    [layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(200);
        make.left.equalTo(superView).offset(100);
        sizeConstraint = make.size.mas_equalTo(CGSizeZero);
    }];
    [sizeConstraint setSizeOffset:size];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [sizeConstraint setSizeOffset:CGSizeMake(350, 50)];
    }];
    [layoutView addGestureRecognizer:tapGes];
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
    titleLabel.tag = kTagForShowView;
    
    // 示例二: UIWindow
    _tmpWindow = nil;
    
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
    
    self.cellHelper.cellView.tag = kTagForShowView;
}

#pragma mark - 自动换行排列view3

- (void)testFunction3 {
    
    CGFloat maxWidth = 300;
    FDAutoPlaceViewConfig *config = [FDAutoPlaceViewConfig new];
    config.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 20);
    config.contentSingleViewInterval = 5;
    config.contentEachLineInterval = 5;
    config.isAutoUpdateWidth = YES;
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
    
    placeView.tag = kTagForShowView;
    [self.view addSubview:placeView];
    placeView.centerX = self.view.width / 2.0f;
}

#pragma mark - 箭头view2

- (void)testFunction2 {
    
    FDArrowTipsViewConfig *config = [FDArrowTipsViewConfig new];
    config.contentCornerRadius = 8;
    config.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12);
    config.originDirection = FDArrowDirection_Right;
    config.gradientBackgroundLayer = [FDArrowTipsViewConfig gradientLayerWith:@[[UIColor colorWithRed:66.0 / 255.0 green:61.0 / 255.0 blue:98.0 / 255.0 alpha:0.65], [UIColor colorWithRed:66.0 / 255.0 green:61.0 / 255.0 blue:98.0 / 255.0 alpha:0.65]]];
    config.arrowSize = CGSizeMake(6, 12);

    NSInteger i = 1;
    switch (i) {
        case 0:
        {
            [self testCustomArrow:config];
            break;
        }
        case 1:
        {
            [self testDefaultCustomView:config];
            break;
        }
        case 2:
        {
            [self testCustomView:config];
            break;
        }
        default:
            break;
    }
    
}

- (NSMutableAttributedString *)defaultArrowTipsViewAttributedString:(NSString *)text {
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
    attText.yy_font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    attText.yy_color = [UIColor whiteColor];
    attText.yy_alignment = NSTextAlignmentCenter;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;

//    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    attText.yy_paragraphStyle = paragraphStyle;
    return attText;
}

- (UIBezierPath *)getTrianglePath:(CGSize)viewSize
                     cornerRadius:(CGFloat)cornerRadius
                        arrowSize:(CGSize)arrowSize {

    UIBezierPath *path = [UIBezierPath bezierPath];
    // 画左上角圆弧
    [path addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5 *M_PI clockwise:YES];
    // 添加到右上角线
    [path addLineToPoint:CGPointMake(viewSize.width - cornerRadius - arrowSize.width, 0)];
    // 画右上角圆弧
    [path addArcWithCenter:CGPointMake(viewSize.width - cornerRadius - arrowSize.width, cornerRadius) radius:cornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:YES];
    // 添加到右箭头
    [path addLineToPoint:CGPointMake(viewSize.width - arrowSize.width, viewSize.height - cornerRadius)];
    [path addLineToPoint:CGPointMake(viewSize.width, viewSize.height)];
    [path addLineToPoint:CGPointMake(cornerRadius, viewSize.height)];
    // 画左下角圆弧
    [path addArcWithCenter:CGPointMake(cornerRadius, viewSize.height - cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path closePath];
    
    return path;
}

- (void)testCustomArrow:(FDArrowTipsViewConfig *)config {
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:@"感兴趣的" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    
    FDArrowTipsView *arrowView = [self.view showArrowTipsViewWithConfig:config andText:attrText andRealSize:CGSizeMake(0, 0) andActionBlock:^void(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        if ( actionType == FDArrowTipsViewActionTypeClick ) {
            [arrowTipsView dismissTipsView:1.0f autoRemove:YES];
        }
        NSLog(@"actionType = %ld", actionType);
    }];
    arrowView.left = 100;
    arrowView.top = 200;
    arrowView.customBezierPath = [self getTrianglePath:arrowView.size cornerRadius:[arrowView getCornerRadius] arrowSize:config.arrowSize];
    arrowView.tag = kTagForShowView;
}

- (void)testCustomView:(FDArrowTipsViewConfig *)config {
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = @"简简单单\n浮浮雷达继熬了副科级的\n奋达科技阿里肯德基";
        [label sizeToFit];
        label;
    });
    FDArrowTipsView *arrowView = [[FDArrowTipsView alloc] initWithFrame:CGRectZero andConfig:config andCustomView:titleLabel];
    arrowView.left = 100;
    arrowView.top = 200;
    arrowView.actionBlock = ^void(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        switch (actionType) {
            case FDArrowTipsViewActionTypeClick:
            {
                [arrowTipsView dismissTipsView:1.0f autoRemove:YES];
                break;
            }
            default:
                break;
        }
        NSLog(@"actionType = %lu", (unsigned long)actionType);
    };
    [self.view addSubview:arrowView];
    arrowView.arrowCenterOffset = 1000;
    [arrowView startViewAnimation:1.0f];
    arrowView.tag = kTagForShowView;
}

- (void)testDefaultCustomView:(FDArrowTipsViewConfig *)config {

    FDArrowTipsView *arrowView = [self.view showArrowTipsViewWithConfig:config andText:[self defaultArrowTipsViewAttributedString:@"简简单单\n浮浮雷达继熬了副科级的\n奋达科技阿里肯德基"] andRealSize:CGSizeZero andActionBlock:^(FDArrowTipsView * _Nonnull arrowTipsView, FDArrowTipsViewActionType actionType) {
        NSLog(@"actionType = %lu", (unsigned long)actionType);
    }];
    arrowView.left = 100;
    arrowView.top = 200;
    arrowView.tag = kTagForShowView;
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
    
    view.tag = kTagForShowView;
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
    
    [[self.view viewWithTag:kTagForShowView] removeFromSuperview];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"testFunction%ld", indexPath.row]) withObject:nil];
#pragma clang diagnostic pop
    
}

#pragma mark - Private Methods

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
    
//    matchmakerImageView.flexibleLayoutViewLeftMargin = 5;
//    matchmakerImageView.flexibleLayoutViewRightMargin = 5;
//    //matchmakerImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
//
//    vipImageView.flexibleLayoutViewLeftMargin = 5;
//    vipImageView.flexibleLayoutViewRightMargin = 5;
//    //vipImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
//
//    sexImageView.flexibleLayoutViewLeftMargin = 5;
//    sexImageView.flexibleLayoutViewRightMargin = 5;
//    //sexImageView.flexibleLayoutViewYType = FlexibleLayoutYTypeCenter;
//
//    addressView.flexibleLayoutViewLeftMargin = 5;
//    addressView.flexibleLayoutViewRightMargin = 5;
//    //addressView.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
//
//    timeLabel.flexibleLayoutViewLeftMargin = 2;
//    timeLabel.flexibleLayoutViewRightMargin = 2;
//    //timeLabel.flexibleLayoutViewYType = FlexibleLayoutYTypeBottom;
    
    return flagViews;
}

#pragma mark - Setter or Getter

- (FDPopWindowManager *)windowManager {
    if (!_windowManager) {
        _windowManager = ({
            FDPopWindowManagerConfig *config = [FDPopWindowManagerConfig new];
            config.windowLevel = UIWindowLevelStatusBar + 1;
            config.showTime = 10;
            config.strategy = FDDissmissStrategyPageChange;
            FDPopWindowManager *manager = [[FDPopWindowManager alloc] initWithConfig:config];
            manager;
        });
    }
    return _windowManager;
}

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
            NSArray *view = @[@"自定义跑马灯0", @"自定义弹框1", @"箭头view2", @"自动换行排列view3", @"格子view4", @"长按拖动view5", @"单行自动缩放view6", @"花瓣形状view7", @"渐变边框view8", @"弹框管理9", @"ImageLabel10", @"Test11"];
            view;
        });
    }
    return _arrData;
}

@end

