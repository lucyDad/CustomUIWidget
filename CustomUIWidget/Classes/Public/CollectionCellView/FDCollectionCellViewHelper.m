//
//  FDCollectionCellViewHelper.m
//  CustomUIWidget
//
//  Created by hexiang on 2020/9/14.
//

#import "FDCollectionCellViewHelper.h"
#import "FDCollectionCellView.h"
#import <Masonry/Masonry.h>
#import <YYCategories/NSArray+YYAdd.h>
#import <YYCategories/UIControl+YYAdd.h>
#import <YYWebImage/UIImageView+YYWebImage.h>
#import "FDCustomUIWidgetDef.h"

NSString *const gCollectionCellLocalIconNameDataKey = @"localIconName";
NSString *const gCollectionCellIconUrlDataKey = @"iconUrl";
NSString *const gCollectionCellNameDataKey = @"name";
NSString *const gCollectionCellDescriptionDataKey = @"description";

static CGSize const kSizeOfIconIV = (CGSize){40, 40};
static CGFloat const kHeightOfTitleLabel = 20;
static CGFloat const kHeightOfSubTitleLabel = 15;
static CGFloat const kTopMarginOfTitleLabel = 10;
static CGFloat const kTopMarginOfSubTitleLabel = 3;

@interface FDCollectionSingleCellView : UIButton

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *cellIconImageView;
@property (nonatomic, strong) UILabel *cellNameLabel;
@property (nonatomic, strong) UILabel *cellSubTitleLabel;

@property (nonatomic, strong) NSDictionary *originData;

@property (nonatomic, strong) MASConstraint *iconSizeConstraint;
@property (nonatomic, strong) MASConstraint *containerHeightConstraint;

@end

@implementation FDCollectionSingleCellView

- (void)updateNoIconLayout {
    [self.iconSizeConstraint setSizeOffset:CGSizeMake(kSizeOfIconIV.width, 0)];
    
    CGFloat height = kHeightOfTitleLabel + kHeightOfSubTitleLabel + kTopMarginOfSubTitleLabel;
    [self.containerHeightConstraint setOffset:height];
}

- (void)updateIconLayout {
    [self.iconSizeConstraint setSizeOffset:kSizeOfIconIV];
    
    CGFloat height = kSizeOfIconIV.height + kHeightOfTitleLabel + kHeightOfSubTitleLabel + kTopMarginOfTitleLabel + kTopMarginOfSubTitleLabel;
    [self.containerHeightConstraint setOffset:height];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *superView = self.containerView;
    [superView addSubview:self.cellIconImageView];
    [superView addSubview:self.cellNameLabel];
    [superView addSubview:self.cellSubTitleLabel];
    
    [self.cellIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.centerX.equalTo(superView);
        self.iconSizeConstraint = make.size.mas_equalTo(kSizeOfIconIV);
    }];
    [self.cellNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellIconImageView.mas_bottom).offset(kTopMarginOfSubTitleLabel);
        make.left.equalTo(superView).offset(5);
        make.right.equalTo(superView).offset(-5);
        make.height.equalTo(@(kHeightOfTitleLabel));
    }];
    [self.cellSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellNameLabel.mas_bottom).offset(kTopMarginOfSubTitleLabel);
        make.left.right.equalTo(self.cellNameLabel);
        make.height.equalTo(@(kHeightOfSubTitleLabel));
    }];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        self.containerHeightConstraint = make.height.equalTo(@(130));
    }];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = ({
            UIView *view = [UIView new];
            view.userInteractionEnabled = NO;
            view;
        });
    }
    return _containerView;
}

- (UIImageView *)cellIconImageView {
    if (!_cellIconImageView) {
        _cellIconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _cellIconImageView;
}

- (UILabel *)cellNameLabel {
    if (!_cellNameLabel) {
        _cellNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _cellNameLabel;
}

- (UILabel *)cellSubTitleLabel {
    if (!_cellSubTitleLabel) {
        _cellSubTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _cellSubTitleLabel;
}

@end


@implementation FDCollectionCellViewHelperConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxWidth = [UIScreen mainScreen].bounds.size.width;
        self.heightOfCell = 130;
        
        self.titleFont = FONT_REGULAR_WITH_SIZE(14);
        self.titleColor = UIColorHex(333333);
        self.selectTitleFont = FONT_REGULAR_WITH_SIZE(16);
        self.selectTitleColor = UIColorHex(FFFFFF);
        
        self.subTitleFont = FONT_REGULAR_WITH_SIZE(11);
        self.subTitleColor = UIColorHex(999999);
        self.selectSubTitleFont = FONT_REGULAR_WITH_SIZE(13);
        self.selectSubTitleColor = UIColorHex(FFFFFF);
        
        self.unselectImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.selectImage = [UIImage imageWithColor:[UIColor redColor]];
    }
    return self;
}

@end

@interface FDCollectionCellViewHelper ()<FDCollectionCellViewDataSource>
{
    
}
@property (nonatomic, strong) FDCollectionCellViewHelperConfig *config;
@property (nonatomic, strong) FDCollectionCellView *cellView;

@property (nonatomic, strong) NSArray<NSDictionary *> *arrDatas;

@end

@implementation FDCollectionCellViewHelper

#pragma mark - Public Interface

- (void)reloadArrDatas:(NSArray<NSDictionary *> *)arrDatas {
    _arrDatas = arrDatas;
    
    [self.cellView reloadUI];
}

#pragma mark - Life Cycle

- (instancetype)initWithConfig:(FDCollectionCellViewHelperConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        [self setupInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInit];
    }
    return [self initWithConfig:[FDCollectionCellViewHelperConfig new]];
}

#pragma mark - Event Response

#pragma mark -- FDCollectionCellViewDataSource

- (NSInteger)numOfCellViewInCollection:(FDCollectionCellView *)weakCellView {
    return self.arrDatas.count;
}

- (CGFloat)heightOfCellViewInCollection:(FDCollectionCellView *)weakCellView {
    return self.config.heightOfCell;
}

- (UIView *)singleCellViewInCollection:(CGSize)viewSize cellIndex:(NSInteger)cellIndex {
    FDCollectionSingleCellView *cellView = [[FDCollectionSingleCellView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [cellView setBackgroundImage:self.config.unselectImage forState:UIControlStateNormal];
    [cellView setBackgroundImage:self.config.selectImage forState:UIControlStateSelected];
    
    NSDictionary *data = [self.arrDatas objectOrNilAtIndex:cellIndex];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSString *localIconName = data[gCollectionCellLocalIconNameDataKey];
        NSString *iconUrl = data[gCollectionCellIconUrlDataKey];
        NSString *titleName = data[gCollectionCellNameDataKey];
        NSString *subTitleName = data[gCollectionCellDescriptionDataKey];
        
        cellView.originData = data;
        if ( nil != localIconName ) {
            // 优先使用本地图片数据
            UIImage *image = [UIImage imageNamed:localIconName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            cellView.cellIconImageView.image = image;
        } else {
            [cellView.cellIconImageView yy_setImageWithURL:[NSURL URLWithString:iconUrl] placeholder:nil];
        }
        
        cellView.cellNameLabel.textColor = self.config.titleColor;
        cellView.cellNameLabel.font = self.config.titleFont;
        cellView.cellNameLabel.text = titleName;
        
        cellView.cellSubTitleLabel.textColor = self.config.subTitleColor;
        cellView.cellSubTitleLabel.font = self.config.subTitleFont;
        cellView.cellSubTitleLabel.text = subTitleName;
        
        @weakify(self);
        [cellView addBlockForControlEvents:UIControlEventTouchUpInside block:^(FDCollectionSingleCellView * _Nonnull sender) {
            @strongify(self);
            [self dealWithSelectEvent:sender];
        }];
        
        if (nil != localIconName || nil != iconUrl) {
            [cellView updateIconLayout];
        } else {
            [cellView updateNoIconLayout];
        }
    }
    return cellView;
}

#pragma mark - Private Methods

- (void)dealWithSelectEvent:(FDCollectionSingleCellView *)sender {
    if (!self.config.isAllowSelect) {
        return;
    }

    if (sender.selected && !self.config.isAllowCancelSelect) {
        // 已经选择并且不允许取消
        return;
    }
    
    sender.selected = !sender.selected;
    [self updateSelectState:sender];
    
    if (sender.selected) {
        // 更新其他选择
        [self.arrDatas enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FDCollectionSingleCellView *singleCellView = [self.cellView viewWithTag:(gTagForCollectionCellView + idx)];
            if ([singleCellView isKindOfClass:[FDCollectionSingleCellView class]] && singleCellView != sender) {
                singleCellView.selected = NO;
                
                [self updateSelectState:singleCellView];
            }
        }];
    }
    
    if (self.clickSelectCellBlock) {
        self.clickSelectCellBlock(sender.originData, sender.selected);
    }
}

- (void)updateSelectState:(FDCollectionSingleCellView *)cellView {
    if (cellView.selected) {
        cellView.cellNameLabel.textColor = self.config.selectTitleColor;
        cellView.cellNameLabel.font = self.config.selectTitleFont;
        cellView.cellSubTitleLabel.textColor = self.config.selectSubTitleColor;
        cellView.cellSubTitleLabel.font = self.config.selectSubTitleFont;
    } else {
        cellView.cellNameLabel.textColor = self.config.titleColor;
        cellView.cellNameLabel.font = self.config.titleFont;
        cellView.cellSubTitleLabel.textColor = self.config.subTitleColor;
        cellView.cellSubTitleLabel.font = self.config.subTitleFont;
    }
}

- (void)setupInit {
    self.cellView = ({
        FDCollectionCellViewConfig *config = [FDCollectionCellViewConfig new];
        FDCollectionCellView *view = [[FDCollectionCellView alloc] initWithMaxWidth:self.config.maxWidth config:config];
        view.dataSource = self;
        view;
    });
}

#pragma mark - Setter or Getter

@end
