//
//  FDArrowCustomListView.h
//  ZAIssue
//
//  Created by hexiang on 2019/12/9.
//  Copyright © 2019 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDArrowCustomListViewConfig : NSObject

@property (nonatomic, assign) CGFloat  cellHeight;  ///> 默认50

@property (nonatomic, assign) UIEdgeInsets  iconEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets  labelEdgeInsets;

@property (nonatomic, strong) UIFont  *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<UIImage *>  *images;

@end

@class FDArrowCustomListView;
typedef void(^FDArrowCustomListViewClickBlock)(FDArrowCustomListView *morePopView, NSInteger index);

@interface FDArrowCustomListView : UIView

@property (nonatomic, strong) FDArrowCustomListViewClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame withConfig:(FDArrowCustomListViewConfig *)config;

@end

NS_ASSUME_NONNULL_END
