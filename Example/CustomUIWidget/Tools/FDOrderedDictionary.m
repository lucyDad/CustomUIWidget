//
//  FDOrderedDictionary.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/17.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#import "FDOrderedDictionary.h"

@interface FDOrderedDictionary ()
{
    
}

@property(nonatomic, strong) NSMutableArray *mutableAllKeys;
@property(nonatomic, strong) NSMutableArray *mutableAllValues;
@property(nonatomic, strong) NSMutableDictionary *mutableDictionary;

@end

@implementation FDOrderedDictionary

#pragma mark - Public Interface

- (instancetype)initWithKeysAndObjects:(id)firstKey, ... {
    if (self = [self init]) {
        
        if (firstKey) {
            [self.mutableAllKeys addObject:firstKey];
            
            va_list argumentList;
            va_start(argumentList, firstKey);
            id argument;
            NSInteger i = 1;
            while ((argument = va_arg(argumentList, id))) {
                if (i % 2 == 0) {
                    [self.mutableAllKeys addObject:argument];
                } else {
                    [self.mutableAllValues addObject:argument];
                }
                i++;
            }
            va_end(argumentList);
            
            [self.mutableAllKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.mutableDictionary setObject:self.mutableAllValues[idx] forKey:key];
            }];
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.mutableAllKeys = [[NSMutableArray alloc] init];
        self.mutableAllValues = [[NSMutableArray alloc] init];
        self.mutableDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger)count {
    return self.mutableDictionary.count;
}

- (NSArray *)allKeys {
    return self.mutableAllKeys.copy;
}

- (NSArray *)allValues {
    return self.mutableAllValues.copy;
}

- (void)setObject:(id)object forKey:(id)key {
    if ([self.mutableAllKeys containsObject:key]) {
        NSInteger index = [self.mutableAllKeys indexOfObject:key];
        [self.mutableAllValues replaceObjectAtIndex:index withObject:object];
        [self.mutableDictionary setObject:object forKey:key];
    } else {
        [self addObject:object forKey:key];
    }
}

- (void)addObject:(id)object forKey:(id)key {
    if (![self.mutableAllKeys containsObject:key]) {
        [self.mutableAllKeys addObject:key];
        [self.mutableAllValues addObject:object];
        [self.mutableDictionary setObject:object forKey:key];
    }
}

- (void)addObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    if (objects.count == keys.count) {
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addObject:objects[idx] forKey:key];
        }];
    }
}

- (void)insertObject:(id)object forKey:(id)key atIndex:(NSInteger)index {
    if (![self.mutableAllKeys containsObject:key]) {
        [self.mutableAllKeys insertObject:key atIndex:index];
        [self.mutableAllValues insertObject:object atIndex:index];
        [self.mutableDictionary setObject:object forKey:key];
    }
}

- (void)insertObjects:(NSArray *)objects forKeys:(NSArray *)keys atIndex:(NSInteger)index {
    if (objects.count == keys.count) {
        __block NSInteger nextIndex = index;
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertObject:objects[idx] forKey:key atIndex:nextIndex];
            nextIndex++;
        }];
    }
}

- (void)removeObject:(id)object forKey:(id)key {
    if ([self.mutableAllKeys containsObject:key]) {
        NSInteger index = [self.mutableAllKeys indexOfObject:key];
        [self removeObject:object atIndex:index];
    }
}

- (void)removeObject:(id)object atIndex:(NSInteger)index {
    if (index < self.allKeys.count) {
        [self.mutableDictionary removeObjectForKey:self.mutableAllKeys[index]];
        [self.mutableAllKeys removeObjectAtIndex:index];
        [self.mutableAllValues removeObjectAtIndex:index];
    }
}

- (id)objectForKey:(id)key {
    return [self.mutableDictionary objectForKey:key];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (id)objectAtIndex:(NSInteger)index {
    return [self.mutableDictionary objectForKey:self.mutableAllKeys[index]];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@", [super description], self.mutableDictionary];
}

@end
