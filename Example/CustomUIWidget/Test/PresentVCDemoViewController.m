//
//  PresentVCDemoViewController.m
//  ZAIssue
//
//  Created by hexiang on 2022/11/25.
//  Copyright © 2022 MAC. All rights reserved.
//

#import "PresentVCDemoViewController.h"
#import "UIColor+YYAdd.h"

@interface PresentVCDemoViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *clickButton;
@end

@implementation PresentVCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *superView = self.view;
    [superView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(10);
        make.top.equalTo(superView).offset(80);
    }];
    [superView addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superView);
    }];
}

- (void)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickButtonAction:(id)sender {
    PresentVCDemoViewController *vc = [PresentVCDemoViewController new];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:vc];
   
    NSLog(@"self = %@, ing = %@, ed = %@", self, self.presentingViewController, self.presentedViewController);
    [self presentViewController:nav animated:YES completion:nil];
}

zx_getter(UIButton *, clickButton, ({
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.backgroundColor = [UIColor redColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    button;
}))

zx_getter(UIButton *, backButton, ({
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    button.backgroundColor = [UIColor greenColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    button;
}))

@end
