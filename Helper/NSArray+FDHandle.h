//
//  NSArray+FDHandle.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 自定义泛型只能在 @interface 上定义
@interface NSArray<ObjectType> (FDHandle)

/// 将多个对象合并成一个数组，如果参数类型是数组则会将数组内的元素拆解出来加到返回结果内（只会拆解一层，所以多维数组不处理）
/// @param object 要合并的多个数组
+ (instancetype)fd_arrayWithObjects:(ObjectType)object, ...;

/// 将多维数组打平成一维数组再遍历所有子元素
/// @param block 遍历结果block
- (void)fd_enumerateNestedArrayWithBlock:(void (NS_NOESCAPE^)(id obj, BOOL *stop))block;

/// 将多维数组递归转换成 mutable 多维数组
- (NSMutableArray *)fd_mutableCopyNestedArray;

/// 过滤数组元素，根据block内操作返回 YES 的 item 重新组装成一个数组返回
/// @param block 过滤逻辑block
- (NSArray<ObjectType> *)fd_filterWithBlock:(BOOL (NS_NOESCAPE^)(ObjectType item))block;

/// 转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
/// @param block 转换block
- (NSArray *)fd_mapWithBlock:(id (NS_NOESCAPE^)(ObjectType item))block;

@end

NS_ASSUME_NONNULL_END
