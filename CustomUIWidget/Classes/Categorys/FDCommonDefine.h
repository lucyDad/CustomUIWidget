//
//  FDCommonDefine.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2021/12/20.
//  Copyright © 2021 lucyDad. All rights reserved.
//

#ifndef FDCommonDefine_h
#define FDCommonDefine_h

#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

#pragma mark - CGFloat

/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 *  issue: https://github.com/Tencent/QMUI_iOS/issues/203
 */
CG_INLINE CGFloat
removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = removeFloatMin(floatValue);
    scale = scale ?: [[UIScreen mainScreen] scale];
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
 *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
 */
CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

/**
 *  类似flat()，只不过 flat 是向上取整，而 floorInPixel 是向下取整
 */
CG_INLINE CGFloat
floorInPixel(CGFloat floatValue) {
    floatValue = removeFloatMin(floatValue);
    CGFloat resultValue = floor(floatValue * [[UIScreen mainScreen] scale]) / [[UIScreen mainScreen] scale];
    return resultValue;
}

CG_INLINE BOOL
between(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue < value && value < maximumValue;
}

CG_INLINE BOOL
betweenOrEqual(CGFloat minimumValue, CGFloat value, CGFloat maximumValue) {
    return minimumValue <= value && value <= maximumValue;
}

/**
 *  调整给定的某个 CGFloat 值的小数点精度，超过精度的部分按四舍五入处理。
 *
 *  例如 CGFloatToFixed(0.3333, 2) 会返回 0.33，而 CGFloatToFixed(0.6666, 2) 会返回 0.67
 *
 *  @warning 参数类型为 CGFloat，也即意味着不管传进来的是 float 还是 double 最终都会被强制转换成 CGFloat 再做计算
 *  @warning 该方法无法解决浮点数精度运算的问题，如需做浮点数的 == 判断，可用下方的 CGFloatEqualToFloat()
 */
CG_INLINE CGFloat
CGFloatToFixed(CGFloat value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
    #if CGFLOAT_IS_DOUBLE
    CGFloat result = [toString doubleValue];
    #else
    CGFloat result = [toString floatValue];
    #endif
    return result;
}

/**
 用于两个 CGFloat 值之间的比较运算，支持 ==、>、<、>=、<= 5种，内部会将浮点数转成整型，从而避免浮点数精度导致的判断错误。
 
 CGFloatEqualToFloatWithPrecision()
 CGFloatEqualToFloat()
 CGFloatMoreThanFloatWithPrecision()
 CGFloatMoreThanFloat()
 CGFloatMoreThanOrEqualToFloatWithPrecision()
 CGFloatMoreThanOrEqualToFloat()
 CGFloatLessThanFloatWithPrecision()
 CGFloatLessThanFloat()
 CGFloatLessThanOrEqualToFloatWithPrecision()
 CGFloatLessThanOrEqualToFloat()
 
 可通过参数 precision 指定要考虑的小数点后的精度，精度的定义是保证指定的那一位小数点不会因为浮点问题导致计算错误，例如当我们要获取一个 1.0 的浮点数时，有时候会得到 0.99999999，有时候会得到 1.000000001，所以需要对指定的那一位小数点的后一位数进行四舍五入操作。
 @code
 precision = 0，也即对小数点后0+1位四舍五入
    0.999 -> 0.9 -> round(0.9) -> 1
    1.011 -> 1.0 -> round(1.0) -> 1
    1.033 -> 1.0 -> round(1.0) -> 1
    1.099 -> 1.0 -> round(1.0) -> 1
 precision = 1，也即对小数点后1+1位四舍五入
    0.999 -> 9.9 -> round(9.9)   -> 10 -> 1.0
    1.011 -> 10.1 -> round(10.1) -> 10 -> 1.0
    1.033 -> 10.3 -> round(10.3) -> 10 -> 1.0
    1.099 -> 10.9 -> round(10.9) -> 11 -> 1.1
 precision = 2，也即对小数点后2+1位四舍五入
    0.999 -> 99.9 -> round(99.9)   -> 100 -> 1.00
    1.011 -> 101.1 -> round(101.1) -> 101 -> 1.01
    1.033 -> 103.3 -> round(103.3) -> 103 -> 1.03
    1.099 -> 109.9 -> round(109.9) -> 110 -> 1.1
 @endcode
*/
CG_INLINE NSInteger _RoundedIntegerFromCGFloat(CGFloat value, NSUInteger precision) {
    return (NSInteger)(round(value * pow(10, precision)));
}

#define _CGFloatCalcGenerator(_operatorName, _operator) CG_INLINE BOOL CGFloat##_operatorName##FloatWithPrecision(CGFloat value1, CGFloat value2, NSUInteger precision) {\
    NSInteger a = _RoundedIntegerFromCGFloat(value1, precision);\
    NSInteger b = _RoundedIntegerFromCGFloat(value2, precision);\
    return a _operator b;\
}\
CG_INLINE BOOL CGFloat##_operatorName##Float(CGFloat value1, CGFloat value2) {\
    return CGFloat##_operatorName##FloatWithPrecision(value1, value2, 0);\
}

_CGFloatCalcGenerator(EqualTo, ==)
_CGFloatCalcGenerator(LessThan, <)
_CGFloatCalcGenerator(LessThanOrEqualTo, <=)
_CGFloatCalcGenerator(MoreThan, >)
_CGFloatCalcGenerator(MoreThanOrEqualTo, >=)

/// 用于居中运算
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flat((parent - child) / 2.0);
}

/// 检测某个数值如果为 NaN 则将其转换为 0，避免布局中出现 crash
CG_INLINE CGFloat
CGFloatSafeValue(CGFloat value) {
    return isnan(value) ? 0 : value;
}

#endif /* FDCommonDefine_h */
