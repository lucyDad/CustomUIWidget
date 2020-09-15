//
//  FDCollectionCellView.h
//  funnydate
//
//  Created by hexiang on 2019/11/6.
//  Copyright © 2019 zhenai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSInteger const gTagForCollectionCellView;       ///> 每个子view的初始tag

typedef NS_ENUM(NSUInteger, CellViewFillType) {
    CellViewFillTypeNone,   // 不进行填充
    CellViewFillTypeAll,    // 剩余部分全部填充
    CellViewFillTypeSingle, // 剩余部分按照cell单个去填充
};

@interface FDCollectionCellViewConfig : NSObject<NSCopying, NSCoding>

@property (nonatomic, assign) NSInteger  columnNumber; ///> 有多少列
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;  ///> 整体内容的偏移

@property (nonatomic, strong) UIColor *lineColor;      ///> 线的颜色(即整个内容的背景颜色)
@property (nonatomic, assign) CGFloat  lineWidth;      ///> 线的宽度

@property (nonatomic, assign) CellViewFillType  fillType; ///> 填充类型（内容本身刚好填满的时候自动不需要， 默认CellViewFillTypeAll）
@property (nonatomic, strong) UIColor *fillViewColor;   ///> 填充view的颜色

@property (nonatomic, assign) BOOL  adapteInteger;  ///> 宽高自动适配整数(默认YES)

@end

@class FDCollectionCellView;
@protocol FDCollectionCellViewDataSource <NSObject>

@required
- (NSInteger)numOfCellViewInCollection:(FDCollectionCellView *)weakCellView;
- (CGFloat)heightOfCellViewInCollection:(FDCollectionCellView *)weakCellView;
- (UIView *)singleCellViewInCollection:(CGSize)viewSize cellIndex:(NSInteger)cellIndex;

@end

@interface FDCollectionCellView : UIView

@property (nonatomic, weak) id<FDCollectionCellViewDataSource> dataSource;

@property (nonatomic, strong, readonly) FDCollectionCellViewConfig *viewConfig;

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth
                          config:(FDCollectionCellViewConfig *)config;

- (void)reloadViewConfig:(FDCollectionCellViewConfig *)viewConfig;

- (void)reloadUI;

@end

NS_ASSUME_NONNULL_END
