//
//  FDHandleStringProtocol.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FDHandleStringProtocol <NSObject>


/**
 *  按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
 */
@property(readonly) NSUInteger fd_lengthWhenCountingNonASCIICharacterAsTwo;

/**
 *  将字符串从指定的 index 开始裁剪到结尾，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，若调用 [string qmui_substringAvoidBreakingUpCharacterSequencesFromIndex:1]，将返回“😊😞”。
 *  若调用系统的 [string substringFromIndex:1]，将返回“?😞”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
 *
 *  @param index 要从哪个 index 开始裁剪文字，如果 countingNonASCIICharacterAsTwo 为 YES，则 index 也要按 YES 的方式来算
 *  @param lessValue 要按小的长度取，还是按大的长度取
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `qmui_substringAvoidBreakingUpCharacterSequencesFromIndex: lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see qmui_substringAvoidBreakingUpCharacterSequencesFromIndex:lessValue:countingNonASCIICharacterAsTwo:
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index;

/**
 *  将字符串从开头裁剪到指定的 index，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，若调用 [string qmui_substringAvoidBreakingUpCharacterSequencesToIndex:1 lessValue:NO countingNonASCIICharacterAsTwo:NO]，将返回“😊”。
 *  若调用系统的 [string substringToIndex:1]，将返回“?”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
 *
 *  @param index 要裁剪到哪个 index 为止（不包含该 index，策略与系统的 substringToIndex: 一致），如果 countingNonASCIICharacterAsTwo 为 YES，则 index 也要按 YES 的方式来算
 *  @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整。
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `qmui_substringAvoidBreakingUpCharacterSequencesToIndex:lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see qmui_substringAvoidBreakingUpCharacterSequencesToIndex:lessValue:countingNonASCIICharacterAsTwo:
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index;

/**
 *  将字符串里指定 range 的子字符串裁剪出来，会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，在 lessValue 模式下，裁剪 (0, 1) 得到的是空字符串，裁剪 (0, 2) 得到的是“😊”。
 *  在非 lessValue 模式下，裁剪 (0, 1) 或 (0, 2)，得到的都是“😊”。
 *
 *  @param range 要裁剪的文字位置
 *  @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整（系统的 rangeOfComposedCharacterSequencesForRange: 会尽量把给定 range 里包含的所有 character sequences 都包含在内，也即 lessValue = NO）。
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `qmui_substringAvoidBreakingUpCharacterSequencesWithRange:lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see qmui_substringAvoidBreakingUpCharacterSequencesWithRange:lessValue:countingNonASCIICharacterAsTwo:
 */
- (nullable instancetype)fd_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range;

/**
 *  移除指定位置的字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
 *  @param index 要删除的位置
 */
- (nullable instancetype)fd_stringByRemoveCharacterAtIndex:(NSUInteger)index;

/**
 *  移除最后一个字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
 *  @see `qmui_stringByRemoveCharacterAtIndex:`
 */
- (nullable instancetype)fd_stringByRemoveLastCharacter;

@end

NS_ASSUME_NONNULL_END
