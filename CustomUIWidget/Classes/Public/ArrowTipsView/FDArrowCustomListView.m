//
//  FDArrowCustomListView.m
//  ZAIssue
//
//  Created by hexiang on 2019/12/9.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "FDArrowCustomListView.h"
#import "FDCustomUIWidgetDef.h"

static NSString *kTableViewCellReuseIdentifier =  @"kTableViewCellReuseIdentifier";

typedef NS_ENUM(NSInteger, FDArrowPopViewCellStyle) {
    FDArrowPopViewCellStyleText,
    FDArrowPopViewCellStyleIconAndText,
};

@interface FDArrowCustomListViewConfig ()
{
    
}

@property (nonatomic, assign) FDArrowPopViewCellStyle  styleType;

@end

@implementation FDArrowCustomListViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.iconEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.labelEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.titleFont = FONT_REGULAR_WITH_SIZE(16);
        self.titleColor = [UIColor blackColor];
    }
    return self;
}

- (FDArrowPopViewCellStyle)styleType {
    if (0 != self.images.count) {
        return FDArrowPopViewCellStyleIconAndText;
    }
    return FDArrowPopViewCellStyleText;
}

@end

@interface FDArrowCustomListViewCell : UITableViewCell

@property (nonatomic, strong) FDArrowCustomListViewConfig *config;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FDArrowCustomListViewCell

- (void)setConfig:(FDArrowCustomListViewConfig *)config {
    _config = config;
    
    UIView *superView = self.contentView;
    switch (config.styleType) {
        case FDArrowPopViewCellStyleText:
        {
            self.iconImageView.hidden = YES;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView).offset(self.config.labelEdgeInsets.left);
                make.right.equalTo(superView).offset(-self.config.labelEdgeInsets.right);
                make.top.equalTo(superView).offset(self.config.labelEdgeInsets.top);
                make.bottom.equalTo(superView).offset(-self.config.labelEdgeInsets.bottom);
            }];
            break;
        }
        case FDArrowPopViewCellStyleIconAndText:
        {
            self.iconImageView.hidden = NO;
            [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView).offset(self.config.iconEdgeInsets.left);
                make.top.equalTo(superView).offset(self.config.iconEdgeInsets.top);
                make.bottom.equalTo(superView).offset(-self.config.iconEdgeInsets.bottom);
                make.width.equalTo(self.iconImageView.mas_height);
            }];
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconImageView.mas_right).offset(self.config.iconEdgeInsets.right + self.config.labelEdgeInsets.left);
                make.right.equalTo(superView).offset(-self.config.labelEdgeInsets.right);
                make.top.equalTo(superView).offset(self.config.labelEdgeInsets.top);
                make.bottom.equalTo(superView).offset(-self.config.labelEdgeInsets.bottom);
            }];
            break;
        }
        default:
            break;
    }
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(superView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorHex(333333);
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    self.iconImageView = ({
        UIImageView *imageView = [UIImageView new];
        
        imageView;
    });
    self.lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.3f];
        view;
    });
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.lineView];
}

@end

@interface FDArrowCustomListView ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) FDArrowCustomListViewConfig *viewConfig;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FDArrowCustomListView

#pragma mark - Public Interface

- (instancetype)initWithFrame:(CGRect)frame withConfig:(FDArrowCustomListViewConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewConfig = config;
        if (0 != config.titles.count) {
            if (0.0 == config.cellHeight) {
                config.cellHeight = frame.size.height  / config.titles.count;
            } else {
                self.height = config.cellHeight * config.titles.count;
            }
        }
        [self setupUI];
    }
    return self;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withConfig:[FDArrowCustomListViewConfig new]];
}

- (void)dealloc {
    LOGGO_INFO(@"");
}

#pragma mark - Delegates

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewConfig.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FDArrowCustomListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    NSString *name = self.viewConfig.titles[indexPath.row];
    cell.titleLabel.text = name;
    cell.titleLabel.font = self.viewConfig.titleFont;
    cell.titleLabel.textColor = self.viewConfig.titleColor;
    
    cell.iconImageView.image = ( indexPath.row < self.viewConfig.images.count ? self.viewConfig.images[indexPath.row] : nil);
    
    cell.config = self.viewConfig;
    
    if (indexPath.row == self.viewConfig.titles.count - 1) {
        // last one
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.viewConfig.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self)weakSelf = self;
    if (self.clickBlock) {
        self.clickBlock(weakSelf, indexPath.row);
    }
}

#pragma mark - Private Methods

- (void)setupUI {

    UIView *superView = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

#pragma mark - Setter or Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] init];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.scrollEnabled = NO;
            [tableView registerClass:[FDArrowCustomListViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
            tableView.dataSource = self;
            tableView.delegate   = self;
            tableView;
        });
    }
    return _tableView;
}

@end


