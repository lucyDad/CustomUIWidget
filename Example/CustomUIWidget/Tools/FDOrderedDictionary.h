//
//  FDOrderedDictionary.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

- (instancetype)initWithKeysAndObjects:(id)firstKey,...;

@property(readonly) NSUInteger count;
@property(nonatomic, copy, readonly) NSArray<KeyType> *allKeys;
@property(nonatomic, copy, readonly) NSArray<ObjectType> *allValues;
- (void)setObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys;
- (void)insertObject:(ObjectType)object forKey:(KeyType)key atIndex:(NSInteger)index;
- (void)insertObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys atIndex:(NSInteger)index;
- (void)removeObject:(ObjectType)object forKey:(KeyType)key;
- (void)removeObject:(ObjectType)object atIndex:(NSInteger)index;
- (nullable ObjectType)objectForKey:(KeyType)key;
- (ObjectType)objectAtIndex:(NSInteger)index;

// 支持下标的方式访问，需要声明以下两个方法
- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
