//
//  FDAutoPlaceViewProtocol.h
//  CustomUIWidget
//
//  Created by hexiang on 2020/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FDAutoPlaceViewProtocol <NSObject>

@required
- (NSArray<UIView *> *)viewsInAutoPlaceView;    // 返回一个view的集合

@end

@interface NSObject(AutoPlacePositionInfo)

@property (nonatomic, strong) NSArray<UIView *> *autoPlaceViews;    // 挂载用户缓存view集合的对象

@end

@interface UIView(AutoPlacePositionInfo)

@property (nonatomic, assign) CGFloat  placeViewLeftMargin; // 单个view距离左边的距离
@property (nonatomic, assign) CGFloat  placeViewRightMargin;    // 单个view距离右边的距离

@property (nonatomic, assign, readonly) NSInteger  rowForAutoPlaceView; // 挂载单个view处于第几行数据

@end

NS_ASSUME_NONNULL_END
