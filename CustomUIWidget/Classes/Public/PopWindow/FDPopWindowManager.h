//
//  FDPopWindowManager.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FDDissmissStrategy) {
    FDDissmissStrategyPageChange,       ///> 切换到不同页面时便消失
    FDDissmissStrategyNotInWhiteList,   ///> 不在白名单时就消失
};

@protocol FDPopWindowManagerProtocol;
@class FDPopWindowEventModel;
@interface FDPopWindowManagerConfig : NSObject

@property (nonatomic, assign) NSInteger  windowLevel;   ///> 当前弹框管理类window级别(默认UIWindowLevelAlert+1)
@property (nonatomic, assign) CGFloat  maxTime;         ///> 轮询定时器最大时长(默认60s)
@property (nonatomic, assign) CGFloat  cacheTime;       ///> view在队列的缓存时长(默认40s,不会超过maxTime)
@property (nonatomic, assign) CGFloat  showTime;        ///> view展示的默认时长(默认15s,不会超过maxTime)
@property (nonatomic, assign) FDDissmissStrategy  strategy; ///> 页面切换策略

@end

@interface FDPopWindowManager : NSObject

@property (nonatomic, strong, readonly) FDPopWindowManagerConfig *config;

/// 初始化弹框管理
/// @param config 配置信息
- (instancetype)initWithConfig:(FDPopWindowManagerConfig *)config;

/// 添加需要处理的对象
/// @param handler 符合FDPopWindowManagerProtocol协议的对象
- (NSInteger)addHandlers:(id<FDPopWindowManagerProtocol>)handler;

/// 根据添加时返回的处理ID删除对应的对象
/// @param handleId 处理的对象ID
- (void)removeHandler:(NSInteger)handleId;

/// 删除所有的处理对象和待处理对象
- (void)removeAllHandler;

/// 根据处理ID获取对应的对象
/// @param handleId 处理对象
- (FDPopWindowEventModel *)getShowHandlerByHandleID:(NSInteger)handleId;

/// 获取当前显示的对象
- (FDPopWindowEventModel *)getCurrentShowHandler;

@end

NS_ASSUME_NONNULL_END
