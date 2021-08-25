//
//  FDPopWindowManager.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import "FDPopWindowManager.h"
#import "FDPopWindow.h"
#import "FDPopWindowEventModel.h"
#import "UIView+FDPopWindow.h"
#import "FDPopWindowManagerProtocol.h"
#import <libextobjc/extobjc.h>

/*
 约束:
 1. 显示的消息有最大显示时间
 2. 待显示的消息有最大保留时间
 边界场景:
 1. 需显示消息的显示时间大于当前定时器剩余时间，需要重启定时器
 2. 需要对showTime非0做处理，显示过一次之后不能在显示，防止外部自动remove，但是数据还在就会重复显示的问题
 3. 缓存需显示的view，因为内部对view绑定了sequenceId，如果外部模块返回的popView是变动的则会出问题
 
 问题:
 1. 消失问题(如果外部实现了消失方法，但是没有移除，同时回调没有调用, 则只能等待显示超时时间结束)
 */

// 消息配置信息
static NSInteger kPopHandlerSquenceId = 100;  ///> 队列ID

static NSString* const kListResultKey    = @"kListResultKey";
static NSString* const kWhiteListPageKey = @"kWhiteListPageKey";
static NSString* const kBlackListPageKey = @"kBlackListPageKey";

@implementation FDPopWindowManagerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxTime = 60;  // 默认最大定时器时长
        self.showTime = 15; // 默认view展示时长
        self.cacheTime = 40;// 默认view在队列的缓存时长
        self.windowLevel = UIWindowLevelAlert + 1; // 默认的window层级
        self.strategy = FDDissmissStrategyNotInWhiteList;
    }
    return self;
}

@end

@interface FDPopWindowManager ()
{
    
}
// Configs
@property (nonatomic, strong) FDPopWindowManagerConfig *config; ///> 当前弹框管理类配置信息
// Datas
@property (nonatomic, strong) NSMutableArray *arrAllHandlers;   ///> 缓存消息队列
@property (nonatomic, strong) dispatch_source_t countDownTimer; ///> 倒计时Timer
@property (nonatomic, assign) NSInteger  leftSeconds;           ///> 倒计时剩余秒数
// Views
@property (nonatomic, strong) FDPopWindow *containerWindow;     ///> 容器window

@end

@implementation FDPopWindowManager

#pragma mark - Public Interface

- (NSInteger)addHandlers:(id<FDPopWindowManagerProtocol>)handler {
    if (nil == handler) {
        [self log:@"添加消息到队列ERROR: 传入的handler为空"];
        return -1;
    }
    if ([self isNeedAutoFilterBlackList:handler]) {
        NSDictionary *resultDic = [self isInBlackPageList:handler];
        if ( [resultDic[kListResultKey] boolValue] ) {
            [self log:@"添加消息到队列ERROR: 当前页面在黑名单不添加到队列"];
            return -1;
        }
    }
    
    [self log:@"添加到缓存列表"];
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    FDPopWindowEventModel *model = [FDPopWindowEventModel new];
    model.receiveTime = currentTime;
    model.handler = handler;
    model.priorityLevel = [self getPriorityLevel:handler];
    model.sequenceId = kPopHandlerSquenceId;
    UIView *needPopView = [self getPopView:handler];
    //model.cachePopView = needPopView;
    if (nil != needPopView) {
        needPopView.sequenceId = model.sequenceId;
        [self.arrAllHandlers addObject:model];
        kPopHandlerSquenceId++;
        [self startCountDown:model];
        return model.sequenceId;
    }
    [self log:@"需要传入非空的显示view"];
    return -1;
}

- (void)removeHandler:(NSInteger)handleId {
    
    if (nil != _containerWindow && _containerWindow.subviews.count > 0) {
        [_containerWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.sequenceId == handleId) {
                [self log:@"当前显示的view启动删除"];
                [self removePopWindowManager:obj dismissType:FDViewDismissTypeUserRemove useCustomDismiss:NO];
            } else {
                [self log:@"当前显示的view和需要删除的ID不一致 handleId = %ld, currentView.sequenceId = %ld", handleId, obj.sequenceId];
            }
        }];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %ld", @"sequenceId", handleId];
    NSArray *arrFilter = [self.arrAllHandlers filteredArrayUsingPredicate:predicate];
    if (0 != arrFilter.count) {
        [self log:@"删除队列中的消息arrFilter = %@", arrFilter];
        [self.arrAllHandlers removeObjectsInArray:arrFilter];
    }
}

- (void)removeAllHandler {
    
    if (nil != _containerWindow && _containerWindow.subviews.count > 0) {
        [_containerWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removePopWindowManager:obj dismissType:FDViewDismissTypeForceRemove useCustomDismiss:NO];
        }];
        [self resetWindowData];
    }
    [self log:@"删除队列中的所有消息arrAllHandlers = %@", self.arrAllHandlers];
    [self.arrAllHandlers removeAllObjects];
}

- (FDPopWindowEventModel *)getShowHandlerByHandleID:(NSInteger)handleId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %ld", @"sequenceId", handleId];
    NSArray *arrFilter = [self.arrAllHandlers filteredArrayUsingPredicate:predicate];
    if (0 != arrFilter.count) {
        FDPopWindowEventModel *model = [arrFilter firstObject];
        return model;
    }
    return nil;
}

- (FDPopWindowEventModel *)getCurrentShowHandler {
    if (nil != _containerWindow && _containerWindow.subviews.count > 0) {
        UIView *currentView = [_containerWindow.subviews lastObject];
        FDPopWindowEventModel *model = [self getCurrentManagerModelBy:currentView.sequenceId];
        return model;
    }
    return nil;
}

#pragma mark - Life Cycle

- (instancetype)initWithConfig:(FDPopWindowManagerConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (instancetype)init {
    return [self initWithConfig:[FDPopWindowManagerConfig new]];
}

#pragma mark - Event Response

#pragma mark - Private Methods

#pragma mark -- Message Handler

- (void)dealWithMessageHanlder {
    
    // 1. 有view正在显示
    if (nil != _containerWindow && _containerWindow.subviews.count > 0) {
        
        UIView *currentView = [_containerWindow.subviews firstObject];
        FDPopWindowEventModel *currentManagerModel = [self getCurrentManagerModelBy:currentView.sequenceId];
        if (nil == currentManagerModel) {
            [self log:@"Warning: 当前有显示的view但是没有对应的handler, 需重置window"];
            [self resetWindowData];
            return;
        }
        if([self isNeedRemoveShowView:currentManagerModel]) {
            [self log:@"当前显示的view已经不在白名单，启动删除"];
            [self removePopWindowManager:currentView dismissType:FDViewDismissTypeWhiteListRemove useCustomDismiss:NO];
        } else {
            if (currentView.isViewWillDisappear) {
                [self log:@"当前显示的view正在动画移除中"];
                return;
            }
            // 检测view是否超时
            NSInteger showAllTime = [self getStopTime:currentManagerModel.handler];
            NSInteger currentTime = [NSDate date].timeIntervalSince1970;
            if (currentTime - currentManagerModel.showTime >= showAllTime) {
                [self log:@"当前显示的view在白名单但是超过显示总时长(%ds)，需删除", showAllTime];
                [self removePopWindowManager:currentView dismissType:FDViewDismissTypeTimeOutRemove useCustomDismiss:YES];
            }
        }
        return;
    }
    // 2. window中没有子views时， 1. window重置 2. 处理已经显示消息 3. 是否停止定时器
    [self resetWindowData];
    
    // 处理掉已经显示的view
    NSMutableIndexSet *hadShowIndexSet = [NSMutableIndexSet indexSet];
    [self.arrAllHandlers enumerateObjectsUsingBlock:^(FDPopWindowEventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.showTime > 0) {
            // 已经展示过的需要删除
            [self log:@"删除已经显示过的view = %@", obj];
            [hadShowIndexSet addIndex:idx];
        }
    }];
    if (hadShowIndexSet.count) {
        [self.arrAllHandlers removeObjectsAtIndexes:hadShowIndexSet];
    }
    
    // 队列中没有可处理的消息
    if (0 == self.arrAllHandlers.count) {
        [self stopCountDownTimer];
        return;
    }
    // 3. 获取可用列表(在当前页面的白名单内)
    NSArray *arrAvailable = [self getAvailableLists];
    NSArray *arrFilters = [self getPriorityLevelLists:arrAvailable];
    if (0 != arrFilters.count) {
        // 处理优先级高的
        [self dealWithSquenceEvent:arrFilters];
    } else {
        [self dealWithSquenceEvent:arrAvailable];
    }
    // 此处再次处理一遍，因为dealWithSquenceEvent内部可能会对数组操作，直接判断无需等到定时器下一秒
    if (0 == self.arrAllHandlers.count) {
        [self stopCountDownTimer];
        return;
    }
    
    // 4. 处理过期的队列消息
    NSMutableIndexSet *hadOverdueIndexSet = [NSMutableIndexSet indexSet];
    NSInteger currentTime = [NSDate date].timeIntervalSince1970;
    [self.arrAllHandlers enumerateObjectsUsingBlock:^(FDPopWindowEventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger cacheTime = [self getCacheTime:obj.handler];
        if (currentTime - obj.receiveTime >= cacheTime) {
            [self log:@"删除过期消息, 接收的时间 = %ld, 过期时间(s) = %ld", obj.receiveTime, cacheTime];
            [hadOverdueIndexSet addIndex:idx];
        }
    }];
    if (hadOverdueIndexSet.count) {
        [self.arrAllHandlers removeObjectsAtIndexes:hadOverdueIndexSet];
    }
}

/**
 处理队列中优先级最高的事件
 
 @param arrLists 事件队列
 */
- (void)dealWithSquenceEvent:(NSArray *)arrLists {
    if (0 == arrLists.count) {
        return;
    }
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"sequenceId" ascending:NO];
    NSArray *sortedArray = [arrLists sortedArrayUsingDescriptors:@[sortDes]];
    FDPopWindowEventModel* model = [sortedArray firstObject];
    
    if (model.showTime > 0) {
        // 已经展示过的需要删除
        [self log:@"将要显示的view已经显示过，需要删除"];
        [self.arrAllHandlers removeObject:model];
        return;
    }
    
    [self showPopWindowManager:model];
    // 将要展示的view的时间小于定时器时间时，需要重启定时器(1. 定时器结束外部view显示还在; )
    NSInteger showTime = [self getStopTime:model.handler];
    if (showTime >= self.leftSeconds ) {
        [self log:@"将要显示的view的显示时间%ld>=倒计时剩余时间%ld，需重启倒计时", showTime, self.leftSeconds];
        [self startCountDown:model];
    }
}

#pragma mark -- Window Manager

- (void)showPopWindowManager:(FDPopWindowEventModel *)manager {
    UIView *popView = [self getPopView:manager.handler];//manager.cachePopView;
    CGRect frame = popView.frame;
    
    // 因为window是包含popView的，frame的x，y坐标只是针对window的位置，popView在window中位置是{0, 0}
    CGRect clickRect = CGRectMake(0, 0, frame.size.width, frame.size.height); // 默认是全部点击范围（即不允许透传）
    if ([manager.handler respondsToSelector:@selector(canClickRectInPopWindowManager)]) {
        clickRect = [manager.handler canClickRectInPopWindowManager];
    }
    
    _containerWindow = [self createContainerWindow:clickRect];
    // popView的x，y用于window，所以popView的x，y需要重置为0
    popView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    [_containerWindow addSubview:popView];
    _containerWindow.frame = frame;
    NSString *currentPage = [self getCurrentShowPage];
    if ([manager.handler respondsToSelector:@selector(showPopViewInPopWindowManager:)]) {
        [manager.handler showPopViewInPopWindowManager:currentPage];
    }
    manager.showTime = [NSDate date].timeIntervalSince1970;
    manager.currentShowPage = currentPage;
    [self log:@"显示view model = %@， _containerWindow.subviews.count = %d", manager, _containerWindow.subviews.count];
}

- (void)removePopWindowManager:(UIView *)currentView
                   dismissType:(FDViewDismissType)dismissType
              useCustomDismiss:(BOOL)useCustomDismiss {
    
    @weakify(currentView, self);
    FDPopWindowEventModel *currentManagerModel = [self getCurrentManagerModelBy:currentView.sequenceId];
    
    if(useCustomDismiss && [currentManagerModel.handler respondsToSelector:@selector(dismissPopViewInPopWindowManager:)]){
        [self log:@"使用自定义移除当前显示View开始"];
        currentView.viewWillDisappear = YES;
        [currentManagerModel.handler dismissPopViewInPopWindowManager:^{
            @strongify(currentView, self);
            [self log:@"使用自定义移除当前显示View结束"];
            [currentView removeFromSuperview];
            currentView.viewWillDisappear = NO;
            [self resetWindowData];
            // view删除的同时，需要删除数据
            [self.arrAllHandlers removeObject:currentManagerModel];
        }];
        // 启动延迟移除，因为外部可能不会回调block，所以不强依赖外部的调用，此处为兼容确保机制
        NSInteger dismissAnimationTime = [self getDismissAnimationTime:currentManagerModel.handler];
        if (dismissAnimationTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((dismissAnimationTime + 1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // view删除的同时，需要删除数据
                [self log:@"使用自定义移除View,但是外部未回调, 保护机制启动删除"];
                if ([self.arrAllHandlers containsObject:currentManagerModel]) {
                    [self.arrAllHandlers removeObject:currentManagerModel];
                }
            });
        }
    } else {
        [self log:@"使用默认移除当前显示View"];
        [currentView removeFromSuperview];
        [self resetWindowData];
        // view删除的同时，需要删除数据
        [self.arrAllHandlers removeObject:currentManagerModel];
    }

    // 回调通知handler
    if([currentManagerModel.handler respondsToSelector:@selector(popViewDismissInPopWindowManager:event:)]) {
        NSInteger showTime = currentManagerModel.showTime;
        NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
        NSTimeInterval hadShowTime = currentTime - showTime;
        [self log:@"回调通知handler页面消失类型 dismissType = %zd, hadShowTime = %f", dismissType, hadShowTime];
        [currentManagerModel.handler popViewDismissInPopWindowManager:dismissType event:currentManagerModel];
    }
}

- (void)resetWindowData {
    [_containerWindow removeAllSubviews];
    _containerWindow.frame = CGRectZero;
    _containerWindow = nil;
}

- (FDPopWindow *)createContainerWindow:(CGRect)clickRect {
    
    FDPopWindow *view = [[FDPopWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    view.clickRect = clickRect;
    view.windowLevel = self.config.windowLevel;
    view.hidden = NO;
    view.clipsToBounds = YES;
    //[view makeKeyAndVisible]; //千万不能成为keywindow
    return view;
}

#pragma mark -- Count Down Timer

- (void)startCountDown:(FDPopWindowEventModel *)model {
    NSInteger dismissAnimationTime = [self getDismissAnimationTime:model.handler];
    NSInteger allTime = self.config.maxTime + dismissAnimationTime + 3; ///> 倒计时总时间(3s为增加的容错时间)
    
    [self startCountDownTimer:allTime];
}

- (void)startCountDownTimer:(NSInteger)allTime {
    
    [self stopCountDownTimer];
    
    __block NSInteger second = allTime; ///> 倒计时总时间
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);  // NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [self log:@"定时器%zd倒计时second = %zd", self.config.windowLevel, second];
                second--;
            } else {
                dispatch_source_cancel(timer);
                [self log:@"定时器%zd到时，取消", self.config.windowLevel];
                self.countDownTimer = nil;
            }
            self.leftSeconds = second;
            [self dealWithMessageHanlder];
        });
    });
    dispatch_resume(timer);
    _countDownTimer = timer;
    [self log:@"定时器%zd启动", self.config.windowLevel];
}

- (void)stopCountDownTimer {
    if (_countDownTimer) {
        [self log:@"定时器%zd停止", self.config.windowLevel];
        dispatch_source_cancel(_countDownTimer);
        _countDownTimer = nil;
    }
}

#pragma mark -- Logics

/// 是否需要删除已经在展示的view
/// @param event 当前事件
- (BOOL)isNeedRemoveShowView:(FDPopWindowEventModel *)event {
    BOOL result = NO;
    switch (self.config.strategy) {
        case FDDissmissStrategyPageChange:
        {
            // 页面切换策略时
            NSString *currentPage = [self getCurrentShowPage];
            if ( ![currentPage isEqualToString:event.currentShowPage]) {
                // 询问用户是否处理，未处理则使用默认策略
                if ( [event.handler respondsToSelector:@selector(isNeedRemoveWhenPageChange:event:)]) {
                    result = [event.handler isNeedRemoveWhenPageChange:currentPage event:event];
                }
            } 
            break;
        }
        case FDDissmissStrategyNotInWhiteList:
        {
            if(![self isHandlerCanShow:event.handler]) {
                result = YES;
            }
            break;
        }
        default:
            break;
    }
    return result;
}

- (BOOL)isHandlerCanShow:(id<FDPopWindowManagerProtocol>)handler {
    NSDictionary *resultDic = [self isInWhitePageList:handler];
    if ( [resultDic[kListResultKey] boolValue] ) {
        
        NSDictionary *balckResultDic = [self isInBlackPageList:handler];
        if ( [balckResultDic[kListResultKey] boolValue] ) {
            // 在黑名单列表不显示
            NSString *blackPage = resultDic[kBlackListPageKey];
            [self log:@"当前页面在黑名单列表页%@, 不显示", blackPage];
            return NO;
        }
        
        NSString *currentPage = resultDic[kWhiteListPageKey];
        BOOL isNeed = YES; // 默认显示
        if ( [handler respondsToSelector:@selector(isNeedShowInPopWindowManager:)]) {
            isNeed = [handler isNeedShowInPopWindowManager:currentPage];
        }
        return isNeed;
    }
    return NO;
}

- (NSDictionary *)isInWhitePageList:(id<FDPopWindowManagerProtocol>)handler {
    
    NSString *topClass = [self getCurrentShowPage];
    return [self isInWhitePageList:handler showPage:topClass];
}

- (NSDictionary *)isInBlackPageList:(id<FDPopWindowManagerProtocol>)handler {
    
    NSMutableArray *arrLists = [NSMutableArray arrayWithArray:[self getBlackListsByUserData:handler]];
    if (0 == arrLists.count) {
        // 未设置黑名单显示列表
        return @{kListResultKey: @(NO)};
    }
    NSString *topClass = [self getCurrentShowPage];
    //[self log:@"当前显示最顶部的 topVC = %@, class = %@", topVC, topClass];
    if ( [arrLists containsObject:topClass] ) {
        return @{kListResultKey: @(YES), kBlackListPageKey: (topClass ? topClass: @"")};
    }
    return @{kListResultKey: @(NO)};
}

- (NSDictionary *)isInWhitePageList:(id<FDPopWindowManagerProtocol>)handler showPage:(NSString *)showPage {
    
    NSString *topClass = showPage;
    NSMutableArray *arrLists = [NSMutableArray arrayWithArray:[self getWhiteListsByUserData:handler]];
    if (0 == arrLists.count) {
        // 未设置白名单显示列表，默认全显示
        return @{kListResultKey: @(YES), kWhiteListPageKey: (topClass ? topClass: @"")};
    }
    //[self log:@"当前显示最顶部的 topVC = %@, class = %@", topVC, topClass];
    if ( [arrLists containsObject:topClass] ) {
        return @{kListResultKey: @(YES), kWhiteListPageKey: (topClass ? topClass: @"")};
    }
    return @{kListResultKey: @(NO), kWhiteListPageKey: (topClass ? topClass: @"")};
}

- (BOOL)isNeedAutoFilterBlackList:(id<FDPopWindowManagerProtocol>)handler {
    BOOL isNeed = YES; // 默认值
    if ( [handler respondsToSelector:@selector(isNeedAutoFilterBlackListInPopWindowManager)]) {
        isNeed = [handler isNeedAutoFilterBlackListInPopWindowManager];
    }
    return isNeed;
}

#pragma mark -- Datas

- (NSArray *)getAvailableLists {
    NSMutableArray *arrResults = [NSMutableArray array];
    [self.arrAllHandlers enumerateObjectsUsingBlock:^(FDPopWindowEventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [self isHandlerCanShow:obj.handler]) {
            [arrResults addObject:obj];
        }
    }];
    return arrResults;
}

- (NSArray<FDPopWindowEventModel *> *)getPriorityLevelLists:(NSArray<FDPopWindowEventModel *> *)lists {
    NSMutableArray *arrResults = [NSMutableArray array];
    __block NSInteger maxLevel = 0;
    [lists enumerateObjectsUsingBlock:^(FDPopWindowEventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( obj.priorityLevel > maxLevel ) {
            [arrResults removeAllObjects];
            [arrResults addObject:obj];
            maxLevel = obj.priorityLevel;
        } else if ( obj.priorityLevel == maxLevel ) {
            [arrResults addObject:obj];
        }
    }];
    return arrResults;
}

- (NSString *)getCurrentShowPage {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (true)
    {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)topViewController;
            topViewController = nav.topViewController;
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    NSString *topClass = NSStringFromClass([topViewController class]);
    return topClass;
}

- (FDPopWindowEventModel *)getCurrentManagerModelBy:(NSInteger)sequenceId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %ld", @"sequenceId", sequenceId];
    NSArray *arrFilter = [self.arrAllHandlers filteredArrayUsingPredicate:predicate];
    if (0 != arrFilter.count) {
        return [arrFilter lastObject];
    }
    return nil;
}

- (UIView *)getPopView:(id<FDPopWindowManagerProtocol>)handler {
    if ( ![handler respondsToSelector:@selector(popViewInPopWindowManager)]) {
        NSAssert(NO, @"must implementation required protocol popViewInPopWindowManager");
    }
    return [handler popViewInPopWindowManager];
}

- (NSInteger)getCacheTime:(id<FDPopWindowManagerProtocol>)handler {
    NSInteger maxCacheTime = self.config.maxTime; // 最大默认值
    NSInteger cacheTime = self.config.cacheTime;
    if ( [handler respondsToSelector:@selector(cacheTimeInPopWindowManager)]) {
        NSInteger userTime = [handler cacheTimeInPopWindowManager];
        cacheTime = MIN(maxCacheTime, userTime);
    }
    return cacheTime;
}

- (NSInteger)getPriorityLevel:(id<FDPopWindowManagerProtocol>)handler {
    NSInteger level = 0; // 默认值
    if ( [handler respondsToSelector:@selector(priorityLevelInPopWindowManager)]) {
        level = [handler priorityLevelInPopWindowManager];
    }
    return level;
}

- (NSInteger)getStopTime:(id<FDPopWindowManagerProtocol>)handler {
    NSInteger maxStopTime = self.config.maxTime; // 最大默认值
    NSInteger time = self.config.showTime;
    if ( [handler respondsToSelector:@selector(popViewStopTimeInPopWindowManager)]) {
        NSInteger userTime = [handler popViewStopTimeInPopWindowManager];
        time = MIN(maxStopTime, userTime);
    }
    return time;
}

- (NSInteger)getDismissAnimationTime:(id<FDPopWindowManagerProtocol>)handler {
    CGFloat time = 0;
    if ( [handler respondsToSelector:@selector(dismissAnimtionTimeInPopWindowManager)]) {
        time = [handler dismissAnimtionTimeInPopWindowManager];
    }
    // 不能大于显示时间
    NSInteger showTime = [self getStopTime:handler];
    NSInteger result = MIN(showTime, (NSInteger)ceilf(time));
    return result;
}

- (NSArray<NSString *> *)getWhiteListsByUserData:(id<FDPopWindowManagerProtocol>)handler {
    if ( [handler respondsToSelector:@selector(canShowPageListInPopWindowManager)]) {
        return [NSMutableArray arrayWithArray:[handler canShowPageListInPopWindowManager]];
    }
    return @[];
}

- (NSArray<NSString *> *)getBlackListsByUserData:(id<FDPopWindowManagerProtocol>)handler {
    if ( [handler respondsToSelector:@selector(canNotShowPageListInPopWindowManager)]) {
        return [NSMutableArray arrayWithArray:[handler canNotShowPageListInPopWindowManager]];
    }
    return @[];
}

#pragma mark -- Log

- (void)log:(NSString *)format, ... {

#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"弹框消息管理>>>%@", msg);
#endif
}

#pragma mark - Setter or Getter

- (NSMutableArray *)arrAllHandlers {
    if (!_arrAllHandlers) {
        _arrAllHandlers = ({
            NSMutableArray *arr = [NSMutableArray array];
            arr;
        });
    }
    return _arrAllHandlers;
}

@end

