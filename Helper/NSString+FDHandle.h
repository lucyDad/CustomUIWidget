//
//  NSString+FDHandle.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FDHandleStringProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FDHandle)<FDHandleStringProtocol>

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，如果多个空格，则每个空格也会当成一个 item
@property(nullable, readonly, copy) NSArray<NSString *> *fd_toArray;

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，但会自动过滤掉空白字符
@property(nullable, readonly, copy) NSArray<NSString *> *fd_toTrimmedArray;

/// 去掉头尾的空白字符
@property(readonly, copy) NSString *fd_trim;

/// 去掉整段文字内的所有空白字符（包括换行符）
@property(readonly, copy) NSString *fd_trimAllWhiteSpace;

/// 将文字中的换行符替换为空格
@property(readonly, copy) NSString *fd_trimLineBreakCharacter;

/// 把该字符串转换为对应的 md5
@property(readonly, copy) NSString *fd_md5;

/// 返回一个符合 query value 要求的编码后的字符串，例如&、#、=等字符均会被变为 %xxx 的编码`
@property(nullable, readonly, copy) NSString *fd_stringByEncodingUserInputQuery;

/// 把当前文本的第一个字符改为大写，其他的字符保持不变，例如 backgroundView.qmui_capitalizedString -> BackgroundView（系统的 capitalizedString 会变成 Backgroundview）
@property(nullable, readonly, copy) NSString *fd_capitalizedString;

/**
 * 用正则表达式匹配的方式去除字符串里一些特殊字符，避免UI上的展示问题
 * @link http://www.croton.su/en/uniblock/Diacriticals.html @/link
 */
@property(nullable, readonly, copy) NSString *fd_removeMagicalChar;

/**
 用正则表达式匹配字符串，将匹配到的第一个结果返回，大小写不敏感

 @param pattern 正则表达式
 @return 匹配到的第一个结果，如果没有匹配成功则返回 nil
 */
- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern;

/**
 用正则表达式匹配字符串，返回匹配到的第一个结果里的指定分组（由参数 index 指定）。
 例如使用 @"ing([\\d\\.]+)" 表达式匹配字符串 @"string0.05" 并指定参数 index = 1，则返回 @"0.05"。
 @param pattern 正则表达式，可用括号表示分组
 @param index 要返回第几个分组，0表示整个正则表达式匹配到的结果，1表示匹配到的结果里的第1个分组（第1个括号）
 @return 返回匹配到的第一个结果里的指定分组，如果 index 超过总分组数则返回 nil。匹配失败也返回 nil。
 */
- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern groupIndex:(NSInteger)index;

/**
 用正则表达式匹配字符串，返回匹配到的第一个结果里的指定分组（由参数 name 指定）。
 例如使用 @"ing(?<number>[\\d\\.]+)" 表达式匹配字符串 @"string0.05" 并指定参数 name 为 @"number"，则返回 @"0.05"。
 @param pattern 正则表达式，可用括号表示分组，分组必须用 ?<name> 的语法来为分组命名。
 @param name 要返回的分组名称，可通过 pattern 里的 ?<name> 语法对分组进行命名。
 @return 返回匹配到的第一个结果里的指定分组，如果 name 不存在则返回 nil。匹配失败也返回 nil。
 */
- (NSString *)fd_stringMatchedByPattern:(NSString *)pattern groupName:(NSString *)name;

/**
 *  用正则表达式匹配字符串并将其替换为指定的另一个字符串，大小写不敏感
 *  @param pattern 正则表达式
 *  @param replacement 要替换为的字符串
 *  @return 最终替换后的完整字符串，如果正则表达式匹配不成功则返回原字符串
 */
- (NSString *)fd_stringByReplacingPattern:(NSString *)pattern withString:(NSString *)replacement;

/// 把某个十进制数字转换成十六进制的数字的字符串，例如“10”->“A”
+ (NSString *)fd_hexStringWithInteger:(NSInteger)integer;

/// 把参数列表拼接成一个字符串并返回，相当于用另一种语法来代替 [NSString stringWithFormat:]
+ (NSString *)fd_stringByConcat:(id)firstArgv, ...;

/**
 * 将秒数转换为同时包含分钟和秒数的格式的字符串，例如 100->"01:40"
 */
+ (NSString *)fd_timeStringWithMinsAndSecsFromSecs:(double)seconds;

@end

@interface NSString (FDHandle_StringFormat)

+ (NSString *)fd_stringWithNSInteger:(NSInteger)integerValue;
+ (NSString *)fd_stringWithCGFloat:(CGFloat)floatValue;
+ (NSString *)fd_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal;
@end

NS_ASSUME_NONNULL_END
