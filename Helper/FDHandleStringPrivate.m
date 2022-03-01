//
//  FDHandleStringPrivate.m
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/11.
//

#import "FDHandleStringPrivate.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+FDHandle.h"

@implementation FDHandleStringPrivate

+ (NSUInteger)transformIndexToDefaultMode:(NSUInteger)index inString:(NSString *)string {
    CGFloat strlength = 0.f;
    NSUInteger i = 0;
    for (i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= index + 1) return i;
    }
    return 0;
}

+ (NSRange)transformRangeToDefaultMode:(NSRange)range lessValue:(BOOL)lessValue inString:(NSString *)string {
    CGFloat strlength = 0.f;
    NSRange resultRange = NSMakeRange(NSNotFound, 0);
    NSUInteger i = 0;
    for (i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if ((lessValue && isascii(character) && strlength >= range.location + 1)
            || (lessValue && !isascii(character) && strlength > range.location + 1)
            || (!lessValue && strlength >= range.location + 1)) {
            if (resultRange.location == NSNotFound) {
                resultRange.location = i;
            }
            
            if (range.length > 0 && strlength >= NSMaxRange(range)) {
                resultRange.length = i - resultRange.location;
                if (lessValue && (strlength == NSMaxRange(range))) {
                    resultRange.length += 1;// 尽量不包含字符的，只有在精准等于时才+1，否则就不算这最后一个字符
                } else if (!lessValue) {
                    resultRange.length += 1;// 只要是最大能力包含字符的，一进来就+1
                }
                return resultRange;
            }
        }
    }
    return resultRange;
}

+ (NSRange)downRoundRangeOfComposedCharacterSequences:(NSRange)range inString:(NSString *)string {
    if (range.length == 0) {
        return range;
    }
    NSRange result = range;
    NSRange beginRange = [string rangeOfComposedCharacterSequenceAtIndex:range.location];
    result.location = beginRange.location < result.location ? NSMaxRange(beginRange) : result.location;
    NSRange endRange = [string rangeOfComposedCharacterSequenceAtIndex:NSMaxRange(range)];
    result.length = endRange.location < NSMaxRange(range) ? endRange.location - result.location : NSMaxRange(range) - result.location;
    return result;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.fd_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    NSAssert(index < length, @"QMUIStringPrivate", @"%s, index %@ out of bounds. string = %@", __func__, @(index), attributedString ?: string);
    if (index >= length) return nil;
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultMode:index inString:string] : index;// 实际计算都按照系统默认的 length 规则来
    NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:index];
    index = lessValue ? NSMaxRange(range) : range.location;
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:NSMakeRange(index, string.length - index)];
        return resultString;
    }
    NSString *resultString = [string substringFromIndex:index];
    return resultString;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.fd_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    NSAssert(index < length, @"QMUIStringPrivate", @"%s, index %@ out of bounds. string = %@", __func__, @(index), attributedString ?: string);
    if (index == 0 || index > length) return nil;
    if (index == length) return [aString copy];// 根据系统 -[NSString substringToIndex:] 的注释，在 index 等于 length 时会返回 self 的 copy。
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultMode:index inString:string] : index;// 实际计算都按照系统默认的 length 规则来
    NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:index];
    index = lessValue ? range.location : NSMaxRange(range);
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:NSMakeRange(0, index)];
        return resultString;
    }
    NSString *resultString = [string substringToIndex:index];
    return resultString;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.fd_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    NSAssert(NSMaxRange(range) <= length, @"QMUIStringPrivate", @"%s, range %@ out of bounds. string = %@", __func__, NSStringFromRange(range), attributedString ?: string);
    if (NSMaxRange(range) > length) return nil;
    range = countingNonASCIICharacterAsTwo ? [self transformRangeToDefaultMode:range lessValue:lessValue inString:string] : range;// 实际计算都按照系统默认的 length 规则来
    NSRange characterSequencesRange = lessValue ? [self downRoundRangeOfComposedCharacterSequences:range inString:string] : [string rangeOfComposedCharacterSequencesForRange:range];
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:characterSequencesRange];
        return resultString;
    }
    NSString *resultString = [string substringWithRange:characterSequencesRange];
    return resultString;
}

+ (id)string:(id)aString avoidBreakingUpCharacterSequencesByRemoveCharacterAtIndex:(NSUInteger)index {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSRange rangeForRemove = [string rangeOfComposedCharacterSequenceAtIndex:index];
    if (attributedString) {
        NSMutableAttributedString *resultString = attributedString.mutableCopy;
        [resultString replaceCharactersInRange:rangeForRemove withString:@""];
        return resultString.copy;
    }
    NSString *resultString = [string stringByReplacingCharactersInRange:rangeForRemove withString:@""];
    return resultString;
}

@end

