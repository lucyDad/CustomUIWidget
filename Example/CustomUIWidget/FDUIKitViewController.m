//
//  FDUIKitViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDUIKitViewController.h"
#import "FDGridView.h"
#import "UIButton+LXMImagePosition.h"
#import "FDOrderedDictionary.h"
#import "FDViewControllerDefine.h"

@interface FDUIKitViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FDGridView *gridView;

@property (nonatomic, strong) FDOrderedDictionary *arrDic;
@end

@implementation FDUIKitViewController

#pragma mark - Public Interface

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
}

#pragma mark - Event Response

- (void)handleGridButtonEvent:(UIButton *)button {
    NSString *keyName = self.arrDic.allKeys[button.tag];
    
    UIViewController *vc = [self generateViewController:keyName];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods

- (UIButton *)generateButton:(NSUInteger)index {
    UIButton *button = [[UIButton alloc] init];
    button.size = CGSizeMake(50, 50);
    [button setImagePosition:LXMImagePositionTop spacing:6];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.backgroundColor = [UIColor clearColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.tag = index;
    [button addTarget:self action:@selector(handleGridButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gridView = [[FDGridView alloc] init];
    self.gridView.width = [UIScreen mainScreen].bounds.size.width;
    NSArray *arrKeys = self.arrDic.allKeys;
    for (NSUInteger i = 0, l = arrKeys.count; i < l; i++) {
        UIButton *button = [self generateButton:i];
        [button setTitle:arrKeys[i] forState:UIControlStateNormal];
        [self.gridView addSubview:button];
    }
    [self.scrollView addSubview:self.gridView];
    
    CGFloat minimumItemWidth = flat([UIScreen mainScreen].bounds.size.width / 3.0);
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = minimumItemWidth;
    [self.gridView sizeToFit];
    
    UIView *superView = self.view;
    [superView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

- (void)setupData {
    [self.arrDic addObject:@"1" forKey:@"UIStackView"];
    [self.arrDic addObject:@"2" forKey:@"UIView"];
}

- (UIViewController *)generateViewController:(NSString *)name {
    UIViewController *vc = nil;
    if ([name isEqualToString:@"UIStackView"]) {
        vc = [FDUIStackViewViewController new];
    }
    vc.title = name;
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

#pragma mark - Setter or Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [UIScrollView new];
            view;
        });
    }
    return _scrollView;
}

- (FDOrderedDictionary *)arrDic {
    if (!_arrDic) {
        _arrDic = ({
            FDOrderedDictionary *arr = [FDOrderedDictionary new];
            arr;
        });
    }
    return _arrDic;
}

@end
