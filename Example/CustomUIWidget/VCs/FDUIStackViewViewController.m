//
//  FDUIStackViewViewController.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/24.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDUIStackViewViewController.h"
#import <Masonry/Masonry.h>

static CGFloat const kLabelLeftMargin = 10;
static CGSize const kSizeOfIconImageView = (CGSize){55, 55};

@interface FDUIStackViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *avatarImageView;
@property (nonatomic, strong) UIStackView *contentStackView;

@end

@interface FDUIStackViewCell ()
{
    
}
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *vipImageView;
@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, strong) UIView *placeView;
@end

@implementation FDUIStackViewCell

#pragma mark - Public Interface

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

#pragma mark - Event Response

- (void)selectButtonAction:(UIButton *)sender {
    
}

#pragma mark - Private Methods

- (void)setupUI {
    
    self.vipImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_vip" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        imageView.image = image;
        imageView;
    });
    self.genderImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_male" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        imageView.image = image;
        imageView;
    });
    UIImageView *guardImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_guard" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        imageView.image = image;
        imageView;
    });
    UIImageView *mmImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_matckmaker" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        imageView.image = image;
        imageView;
    });
    UIImageView *charmImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"icon_charm" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        imageView.image = image;
        imageView;
    });
    
    self.placeView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor greenColor];
        [view setContentHuggingPriority:UILayoutPriorityDefaultLow- 1 forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisHorizontal];
        view;
    });
    
    [self.contentStackView addArrangedSubview:self.nameLabel];
    [self.contentStackView addArrangedSubview:self.vipImageView];
    [self.contentStackView addArrangedSubview:self.genderImageView];
    [self.contentStackView addArrangedSubview:guardImageView];
    [self.contentStackView addArrangedSubview:mmImageView];
    //[self.contentStackView addArrangedSubview:charmImageView];
    [self.contentStackView addArrangedSubview:self.placeView];
    
    NSLog(@"%f", [self.genderImageView contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal]);
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.contentStackView];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.lineView];
    [self configSubView];
}

- (void)configSubView {
    
    UIView *superView = self.contentView;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(11);
        make.left.equalTo(superView).offset(10);
        make.size.equalTo(@(kSizeOfIconImageView));
    }];
    [self.contentStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_top);
        make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelLeftMargin);
        make.right.equalTo(superView).offset(-10);
        make.height.equalTo(@(23));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.nameLabel.mas_right);
        make.height.equalTo(@(17));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.bottom.equalTo(superView);
        make.height.equalTo(@(1));
    }];
}

#pragma mark - Setter or Getter

- (UIStackView *)contentStackView {
    if (!_contentStackView) {
        _contentStackView = ({
            UIStackView *view = [UIStackView new];
            view.axis = UILayoutConstraintAxisHorizontal;
            view.distribution = UIStackViewDistributionFill;
            view.alignment = UIStackViewAlignmentCenter;
            view.spacing = 6;
            view;
        });
    }
    return _contentStackView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = kSizeOfIconImageView.width / 2.0f;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = UIColorHex(000000);
            label.font = FONT_REGULAR_WITH_SIZE(16);
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = UIColorHex(999999);
            label.font = FONT_REGULAR_WITH_SIZE(12);
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColorHex(EEEEEE);
            view;
        });
    }
    return _lineView;
}

@end

static NSString *kTableViewCellReuseIdentifier =  @"kTableViewCellReuseIdentifier";

@interface FDUIStackViewViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FDUIStackViewViewController

#pragma mark - Public Interface

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - Delegates

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FDUIStackViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    
    cell.avatarImageView.backgroundColor = [UIColor redColor];
    cell.nameLabel.text = @"kobe反对垃圾发电看来减肥啦对方的世界";
    cell.detailLabel.text = @"24";
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Private Methods

- (void)setupUI {
    [self.view addSubview:self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

- (void)setupData {
    
}

#pragma mark - Setter or Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[FDUIStackViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
            tableView.dataSource = self;
            tableView.delegate   = self;
            tableView;
        });
    }
    return _tableView;
}

@end
