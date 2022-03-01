//
//  NSString+FDHandle.m
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#import "NSString+FDHandle.h"
#import <CommonCrypto/CommonDigest.h>
#import "FDHandleStringPrivate.h"
#import "NSArray+FDHandle.h"

@implementation NSString (FDHandle)

- (NSArray<NSString *> *)fd_toArray {
    if (!self.length) {
        return nil;
    }
    
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *stringItem = [self substringWithRange:NSMakeRange(i, 1)];
        [array addObject:stringItem];
    }
    return [array copy];
}

- (NSArray<NSString *> *)fd_toTrimmedArray {
    return [[self fd_toArray] fd_filterWithBlock:^BOOL(NSString *item) {
        return item.fd_trim.length > 0;
    }];
}

- (NSString *)fd_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)fd_trimAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)fd_trimLineBreakCharacter {
    return [self stringByReplacingOccurrencesOfString:@"[\r\n]" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)fd_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)fd_stringByEncodingUserInputQuery {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];

    return [self stringByAddingPercentEncodingWithAllowedCharacters:set.copy];
}

- (NSString *)fd_capitalizedString {
    if (self.length)
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]].copy;
    return nil;
}

+ (NSString *)hexLetterStringWithInteger:(NSInteger)integer {
    NSAssert(integer < 16, @"NSString (QMUI)", @"%s 参数仅接受小于16的值，当前传入的是 %@", __func__, @(integer));
    
    NSString *letter = nil;
    switch (integer) {
        case 10:
            letter = @"A";
            break;
        case 11:
            letter = @"B";
            break;
        case 12:
            letter = @"C";
            break;
        case 13:
            letter = @"D";
            break;
        case 14:
            letter = @"E";
            break;
        case 15:
            letter = @"F";
            break;
        default:
            letter = [[NSString alloc]initWithFormat:@"%@", @(integer)];
            break;
    }
    return letter;
}

+ (NSString *)fd_hexStringWithInteger:(NSInteger)integer {
    NSString *hexString = @"";
    NSInteger remainder = 0;
    for (NSInteger i = 0; i < 9; i++) {
        remainder = integer % 16;
        integer = integer / 16;
        NSString *letter = [self hexLetterStringWithInteger:remainder];
        hexString = [letter stringByAppendingString:hexString];
        if (integer == 0) {
            break;
        }
        
    }
    return hexString;
}

+ (NSString *)fd_stringByConcat:(id)firstArgv, ... {
    if (firstArgv) {
        NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@", firstArgv];
        
        va_list argumentList;
        va_start(argumentList, firstArgv);
        id argument;
        while ((argument = va_arg(argumentList, id))) {
            [result appendFormat:@"%@", argument];
        }
        va_end(argumentList);
        
        return [result copy];
    }
    return nil;
}

+ (NSString *)fd_timeStringWithMinsAndSecsFromSecs:(double)seconds {
    NSUInteger min = floor(seconds / 60);
    NSUInteger sec = floor(seconds - min * 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
}

- (NSString *)fd_removeMagicalChar {
    if (self.length == 0) {
        return self;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u0300-\u036F]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    return modifiedString;
}

- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern {
    return [self fd_stringMatchedByPattern:pattern groupIndex:0];
}

- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern groupIndex:(NSInteger)index {
    if (pattern.length <= 0 || index < 0) return nil;
    
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [regx firstMatchInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    if (result.numberOfRanges > index) {
        NSRange range = [result rangeAtIndex:index];
        return [self substringWithRange:range];
    }
    return nil;
}

- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern groupName:(NSString *)name {
    if (pattern.length <= 0) return nil;
    
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [regx firstMatchInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    if (result.numberOfRanges > 1) {
        NSRange range = [result rangeWithName:name];
        NSAssert(range.location != NSNotFound, @"NSString (QMUI)", @"%s, 不存在名为 %@ 的 group name", __func__, name);
        if (range.location != NSNotFound) {
            return [self substringWithRange:range];
        }
    }
    
    return nil;
}

- (NSString *)fd_stringByReplacingPattern:(NSString *)pattern withString:(NSString *)replacement {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return self;
    }
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) withTemplate:replacement];
}

#pragma mark - <FDHandleStringProtocol>

- (NSUInteger)fd_lengthWhenCountingNonASCIICharacterAsTwo {
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = self.length; i < l; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    return length;
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    return [FDHandleStringPrivate substring:self avoidBreakingUpCharacterSequencesFromIndex:index lessValue:lessValue countingNonASCIICharacterAsTwo:countingNonASCIICharacterAsTwo];
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index {
    return [self fd_substringAvoidBreakingUpCharacterSequencesFromIndex:index lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    return [FDHandleStringPrivate substring:self avoidBreakingUpCharacterSequencesToIndex:index lessValue:lessValue countingNonASCIICharacterAsTwo:countingNonASCIICharacterAsTwo];
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index {
    return [self fd_substringAvoidBreakingUpCharacterSequencesToIndex:index lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    return [FDHandleStringPrivate substring:self avoidBreakingUpCharacterSequencesWithRange:range lessValue:lessValue countingNonASCIICharacterAsTwo:countingNonASCIICharacterAsTwo];
}

- (instancetype)fd_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range {
    return [self fd_substringAvoidBreakingUpCharacterSequencesWithRange:range lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (instancetype)fd_stringByRemoveCharacterAtIndex:(NSUInteger)index {
    return [FDHandleStringPrivate string:self avoidBreakingUpCharacterSequencesByRemoveCharacterAtIndex:index];
}

- (instancetype)fd_stringByRemoveLastCharacter {
    return [self fd_stringByRemoveCharacterAtIndex:self.length - 1];
}

@end

@implementation NSString (FDHandle_StringFormat)

+ (NSString *)fd_stringWithNSInteger:(NSInteger)integerValue {
    return @(integerValue).stringValue;
}

+ (NSString *)fd_stringWithCGFloat:(CGFloat)floatValue {
    return [NSString fd_stringWithCGFloat:floatValue decimal:2];
}

+ (NSString *)fd_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(decimal)];
    return [NSString stringWithFormat:formatString, floatValue];
}

@end
