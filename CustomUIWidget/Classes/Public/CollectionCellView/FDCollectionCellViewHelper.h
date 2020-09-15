//
//  FDCollectionCellViewHelper.h
//  CustomUIWidget
//
//  Created by hexiang on 2020/9/14.
//

#import <Foundation/Foundation.h>
#import "FDCollectionCellView.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const gCollectionCellLocalIconNameDataKey;
UIKIT_EXTERN NSString *const gCollectionCellIconUrlDataKey;
UIKIT_EXTERN NSString *const gCollectionCellNameDataKey;
UIKIT_EXTERN NSString *const gCollectionCellDescriptionDataKey;

@interface FDCollectionCellViewHelperConfig : NSObject

@property (nonatomic, assign) CGFloat  maxWidth;    ///> 默认屏幕宽度
@property (nonatomic, assign) CGFloat  heightOfCell;   ///> 单个cell的高度

@property (nonatomic, strong) UIColor *titleColor;  ///> 主标题的文本颜色
@property (nonatomic, strong) UIFont *titleFont;    ///> 主标题的文本字体
@property (nonatomic, strong) UIColor *selectTitleColor;  ///> 选中主标题的文本颜色
@property (nonatomic, strong) UIFont *selectTitleFont;    ///> 选中主标题的文本字体

@property (nonatomic, strong) UIColor *subTitleColor;  ///> 副标题的文本颜色
@property (nonatomic, strong) UIFont *subTitleFont;    ///> 副标题的文本字体
@property (nonatomic, strong) UIColor *selectSubTitleColor;  ///> 选中副标题的文本颜色
@property (nonatomic, strong) UIFont *selectSubTitleFont;    ///> 选中副标题的文本字体

@property (nonatomic, assign) BOOL  isAllowSelect;      ///> 是否允许选择 （默认不允许）
@property (nonatomic, assign) BOOL  isAllowCancelSelect;///> 是否允许取消选择 （默认不允许）
@property (nonatomic, strong) UIImage *unselectImage;   ///> 背景图片
@property (nonatomic, strong) UIImage *selectImage;     ///> 选中的背景图片

@end

@interface FDCollectionCellViewHelper : NSObject

@property (nonatomic, strong, readonly) FDCollectionCellView *cellView;

@property (nonatomic, strong) void(^clickSelectCellBlock)(NSDictionary *selectData, BOOL isSelect);

- (instancetype)initWithConfig:(FDCollectionCellViewHelperConfig *)config;

- (void)reloadArrDatas:(NSArray<NSDictionary *> *)arrDatas;

@end

NS_ASSUME_NONNULL_END
