//
//  FDPopWindowEventModel.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FDPopWindowManagerProtocol;

@interface FDPopWindowEventModel : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger  sequenceId;    ///> 进入队列的顺序id
@property (nonatomic, assign) NSInteger  receiveTime;   ///> 进入队列的时间（unix的秒数时间）
@property (nonatomic, assign) NSInteger  showTime;      ///> view显示的时间（unix的秒数时间）
@property (nonatomic, strong) NSString   *currentShowPage; ///> view显示时所在的page

@property (nonatomic, assign) NSInteger  priorityLevel; ///> 需要显示的优先级
@property (nonatomic, strong) id<FDPopWindowManagerProtocol> handler;

@property (nonatomic, strong) id userData;

@end

NS_ASSUME_NONNULL_END
