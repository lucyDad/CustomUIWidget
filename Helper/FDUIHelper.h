//
//  FDUIHelper.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDUIHelper : NSObject

+ (CGFloat)tabbarHeight;

+ (BOOL)isFullScreen;

+ (CGFloat)bottomSafeAreaHeight;

+ (instancetype)sharedInstance;

/**
 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
 @param block 要执行的一段逻辑
 @param identifier 唯一的标记，建议在 identifier 里添加当前这段业务的特有名称，例如用于 swizzle 的可以加“swizzled”前缀，以避免与其他业务共用同一个 identifier 引发 bug
 */
+ (BOOL)executeBlock:(void (NS_NOESCAPE ^)(void))block oncePerIdentifier:(NSString *)identifier;

@end

@interface FDUIHelper (UIGraphic)

/// 获取一像素的大小
@property(class, nonatomic, readonly) CGFloat pixelOne;

/// 判断size是否超出范围
+ (void)inspectContextSize:(CGSize)size;

/// context是否合法
+ (BOOL)inspectContextIfInvalidated:(CGContextRef)context;

@end

@interface FDUIHelper (SystemVersion)

+ (NSInteger)numbericOSVersion;
+ (NSComparisonResult)compareSystemVersion:(nonnull NSString *)currentVersion toVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemAtLeastVersion:(nonnull NSString *)targetVersion;
+ (BOOL)isCurrentSystemLowerThanVersion:(nonnull NSString *)targetVersion;

@end

NS_ASSUME_NONNULL_END
