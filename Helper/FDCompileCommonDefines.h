//
//  FDCompileCommonDefines.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#ifndef FDCompileCommonDefines_h
#define FDCompileCommonDefines_h

#pragma mark - 变量-编译相关

/// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
/// 当前编译使用的 Base SDK 版本为 iOS 10.0 及以上
#define IOS10_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
/// 当前编译使用的 Base SDK 版本为 iOS 11.0 及以上
#define IOS11_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
/// 当前编译使用的 Base SDK 版本为 iOS 12.0 及以上
#define IOS12_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
/// 当前编译使用的 Base SDK 版本为 iOS 13.0 及以上
#define IOS13_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
/// 当前编译使用的 Base SDK 版本为 iOS 14.0 及以上
#define IOS14_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000
/// 当前编译使用的 Base SDK 版本为 iOS 15.0 及以上
#define IOS15_SDK_ALLOWED YES
#endif

#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning

#define BeginIgnoreAvailabilityWarning BeginIgnoreClangWarning(-Wpartial-availability)
#define EndIgnoreAvailabilityWarning EndIgnoreClangWarning

#define BeginIgnoreDeprecatedWarning BeginIgnoreClangWarning(-Wdeprecated-declarations)
#define EndIgnoreDeprecatedWarning EndIgnoreClangWarning

#endif /* FDCompileCommonDefines_h */
