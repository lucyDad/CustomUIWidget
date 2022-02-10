//
//  FDComponentsViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDComponentsViewController.h"
#import "FDGridView.h"
#import "UIButton+LXMImagePosition.h"
#import "FDOrderedDictionary.h"
#import "FDViewControllerDefine.h"

static CGFloat const kHeightLabel = 20;

@interface FDComponentsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FDGridView *gridView;

@property (nonatomic, strong) FDOrderedDictionary *arrDic;
@end

@implementation FDComponentsViewController

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
    
    NSString *vcName = self.arrDic[keyName];
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods

- (UIView *)generateShowView:(NSUInteger)index {
    
    NSString *keyName = self.arrDic.allKeys[index];
    NSString *vcName = self.arrDic[keyName];
    
    Class class = NSClassFromString(vcName);
    if ([class respondsToSelector:@selector(exampleShowView:)]) {
        CGFloat width = [self minimunItemWidth];
        CGFloat margin = 10;
        return [class exampleShowView:CGSizeMake(width - 2 *margin, width - kHeightLabel - 2 * margin)];
    }
    return nil;
}

- (UIButton *)generateButton:(NSUInteger)index {
    UIButton *button = [[UIButton alloc] init];

    CGFloat minimumItemWidth = [self minimunItemWidth];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.width = minimumItemWidth;
        label.height = kHeightLabel;
        label.bottom = minimumItemWidth;
        label.tag = 1000;
        label;
    });
    [button addSubview:titleLabel];
    
    UIView *showView = [self generateShowView:index];
    if (nil != showView) {
        showView.userInteractionEnabled = NO;
        showView.center = CGPointMake(minimumItemWidth / 2.0f, minimumItemWidth / 2.0f);
        [button addSubview:showView];
    }
    
    button.tag = index;
    [button addTarget:self action:@selector(handleGridButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGFloat)minimunItemWidth {
    CGFloat minimumItemWidth = flat([UIScreen mainScreen].bounds.size.width / 3.0);
    return minimumItemWidth;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gridView = [[FDGridView alloc] init];
    self.gridView.width = [UIScreen mainScreen].bounds.size.width;
    CGFloat minimumItemWidth = [self minimunItemWidth];
    
    NSArray *arrKeys = self.arrDic.allKeys;
    for (NSUInteger i = 0, l = arrKeys.count; i < l; i++) {
        UIButton *button = [self generateButton:i];
        UILabel *titleLabel = (UILabel *)[button viewWithTag:1000];
        titleLabel.text = arrKeys[i];
        [self.gridView addSubview:button];
    }
    [self.scrollView addSubview:self.gridView];
    
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = minimumItemWidth;
    self.gridView.separatorWidth = PixelOne;
    [self.gridView sizeToFit];
    
    UIView *superView = self.view;
    [superView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

- (void)setupData {
    
    NSArray<Class> *lists = [self getAllClasses];
    [lists enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(componetName)]) {
            NSString *key = [obj componetName];
            if (0 != key.length) {
                [self.arrDic addObject:NSStringFromClass(obj) forKey:key];
            }
        }
    }];
}

- (NSArray<Class> *)getAllClasses {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class*)malloc(sizeof(Class) * numClasses);
    
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for(NSInteger i=0; i < numClasses; i++) {
        Class cls = classes[i];
        
        /*
         查找某个基类下的子类
         do{
         cls = class_getSuperclass(cls);
         }while(cls && cls != parentClass);
         
         if(cls){
         [result addObject:classes[i]];
         }
         */

        if ( [NSStringFromClass(cls) hasPrefix:@"FD"] && [cls conformsToProtocol:@protocol(FDComponentProtocol)]) {
            //NSLog(@"%@", NSStringFromClass(cls));
            [result addObject:cls];
        }
    }
    free(classes);
    return [result copy];
}

- (id<FDComponentProtocol>)getViewController:(NSString *)name {
    __block id<FDComponentProtocol> result = nil;
    NSArray<Class> *lists = [self getAllClasses];
    [lists enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<FDComponentProtocol> vc = [[obj alloc] init];
        if ([[vc componetName] isEqualToString:name]) {
            result = vc;
        }
    }];
    return result;
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
