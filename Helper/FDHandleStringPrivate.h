//
//  FDHandleStringPrivate.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDHandleStringPrivate : NSObject

+ (nullable id)substring:(id)aString avoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;
+ (nullable id)substring:(id)aString avoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;
+ (nullable id)substring:(id)aString avoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;
+ (nullable id)string:(id)aString avoidBreakingUpCharacterSequencesByRemoveCharacterAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
