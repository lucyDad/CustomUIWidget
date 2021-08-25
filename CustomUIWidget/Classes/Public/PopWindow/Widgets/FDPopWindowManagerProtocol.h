//
//  FDPopWindowManagerProtocol.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FDViewDismissType) {
    FDViewDismissTypeTimeOutRemove,     ///>超时自动删除view
    FDViewDismissTypeWhiteListRemove,   ///>不在显示白名单自动删除view
    FDViewDismissTypeForceRemove,       ///>优先展示其他view，当前view被干掉
    FDViewDismissTypeUserRemove,        ///>用户手动移除
};

@class FDPopWindowEventModel;
@protocol FDPopWindowManagerProtocol <NSObject>

@required

/**
 需要显示的弹框View
 
 @return 弹框View
 */
- (UIView *)popViewInPopWindowManager;

@optional

#pragma mark - 显示页面设置

/**
 能够显示的页面VC字符串名称集合
 
 @return VC字符串名称
 */
- (NSArray<NSString *> *)canShowPageListInPopWindowManager;

/**
 不能够显示的页面VC字符串名称集合

 @return VC字符串名称
 */
- (NSArray<NSString *> *)canNotShowPageListInPopWindowManager;

/**
 在白名单内更细致的判断是否需要显示

 @return 根据各自逻辑处理是否显示
 */
- (BOOL)isNeedShowInPopWindowManager:(NSString *)currentWhitePage;

#pragma mark - 显示相关设置

/**
 需要显示的优先级(数值越大优先级越高)
 
 @return 优先级
 */
- (NSInteger)priorityLevelInPopWindowManager;

/**
 需要显示的view的停留时长(管理类已有默认值，如需单独处理，可实现此方法)
 
 @return 停留时长
 */
- (NSInteger)popViewStopTimeInPopWindowManager;

/**
 弹框view在缓存队列中的缓存时间(管理类已有默认值，如需单独处理，可实现此方法)
 
 @return 缓存时间
 */
- (NSInteger)cacheTimeInPopWindowManager;

/**
 弹框view消失的回调（不在白名单或者显示时间超时，或者外部自动移除了）

 @param dismissType 消失的类型
 */
- (void)popViewDismissInPopWindowManager:(FDViewDismissType)dismissType event:(FDPopWindowEventModel *)event;

#pragma mark - 动画设置

/// 动画消失时需要的时长
- (CGFloat)dismissAnimtionTimeInPopWindowManager;
/**
 弹框view显示的动画
 */
- (void)showPopViewInPopWindowManager:(NSString *)currentShowPage;

/**
 弹框view消失的动画
 
 @param completeBlock 消失的回调
 */
- (void)dismissPopViewInPopWindowManager:(void(^)(void))completeBlock;

#pragma mark - 过滤相关设置

/**
 添加时(当上面这个为YES时)是否需要自动过滤黑名单列表(默认YES)

 @return 是否需要自动过滤黑名单列表
 */
- (BOOL)isNeedAutoFilterBlackListInPopWindowManager;

/**
 在切换页面时是否需要移除当前页面(仅当window config.strategy配置为FDDissmissStrategyPageChange时有效）
 
 @return VC字符串名称
 */
- (BOOL)isNeedRemoveWhenPageChange:(NSString *)currentPage event:(FDPopWindowEventModel *)event;

#pragma mark - 点击相关设置

/// 返回可点击的范围（默认是view大小，即不透传，返回CGRectZero则全部透传）
- (CGRect)canClickRectInPopWindowManager;

@end

NS_ASSUME_NONNULL_END
