//
//  FDCategoryPropertyDefine.h
//  Pods
//
//  Created by hexiang on 2021/12/22.
//

#ifndef FDCategoryPropertyDefine_h
#define FDCategoryPropertyDefine_h

#import "YYWeakProxy.h"
#import "FDCompileCommonDefines.h"
#import <objc/runtime.h>
/**
 以下系列宏用于在 Category 里添加 property 时，可以在 @implementation 里一句代码完成 getter/setter 的声明。
 暂不支持在 getter/setter 里添加自定义的逻辑，需要自定义的情况请自己实现即可。
 
 使用方式：
 
 @interface NSObject (CategoryName)
 @property(nonatomic, strong) type *strongObj;
 @property(nonatomic, weak) type *weakObj;
 @property(nonatomic, assign) CGRect rectValue;
 @end
 
 @implementation NSObject (CategoryName)
 
 // 注意 setter 不需要带冒号
 FDUISynthesizeIdStrongProperty(strongObj, setStrongObj)
 FDUISynthesizeIdWeakProperty(weakObj, setWeakObj)
 FDUISynthesizeCGRectProperty(rectValue, setRectValue)
 
 @end
 */

#pragma mark - Meta Marcos

#define _FDUISynthesizeId(_getterName, _setterName, _policy) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
\
- (id)_getterName {\
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
}\
_Pragma("clang diagnostic pop")

#define _FDUISynthesizeWeakId(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [[YYWeakProxy alloc] initWithObject:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (id)_getterName {\
    return ((YYWeakProxy *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)).object;\
}\
_Pragma("clang diagnostic pop")

#define _FDUISynthesizeNonObject(_getterName, _setterName, _type, valueInitializer, valueGetter) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(_type)_getterName {\
    objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, [NSNumber valueInitializer:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (_type)_getterName {\
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName)) valueGetter];\
}\
_Pragma("clang diagnostic pop")

#pragma mark - Object Marcos

/// @property(nonatomic, strong) id xxx
#define FDUISynthesizeIdStrongProperty(_getterName, _setterName) _FDUISynthesizeId(_getterName, _setterName, RETAIN)

/// @property(nonatomic, weak) id xxx
#define FDUISynthesizeIdWeakProperty(_getterName, _setterName) _FDUISynthesizeWeakId(_getterName, _setterName)

/// @property(nonatomic, copy) id xxx
#define FDUISynthesizeIdCopyProperty(_getterName, _setterName) _FDUISynthesizeId(_getterName, _setterName, COPY)

#pragma mark - NonObject Marcos

/// @property(nonatomic, assign) Int xxx
#define FDUISynthesizeIntProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, int, numberWithInt, intValue)

/// @property(nonatomic, assign) unsigned int xxx
#define FDUISynthesizeUnsignedIntProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, unsigned int, numberWithUnsignedInt, unsignedIntValue)

/// @property(nonatomic, assign) float xxx
#define FDUISynthesizeFloatProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, float, numberWithFloat, floatValue)

/// @property(nonatomic, assign) double xxx
#define FDUISynthesizeDoubleProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, double, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) BOOL xxx
#define FDUISynthesizeBOOLProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

/// @property(nonatomic, assign) NSInteger xxx
#define FDUISynthesizeNSIntegerProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, NSInteger, numberWithInteger, integerValue)

/// @property(nonatomic, assign) NSUInteger xxx
#define FDUISynthesizeNSUIntegerProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, NSUInteger, numberWithUnsignedInteger, unsignedIntegerValue)

/// @property(nonatomic, assign) CGFloat xxx
#define FDUISynthesizeCGFloatProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGFloat, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) CGPoint xxx
#define FDUISynthesizeCGPointProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGPoint, valueWithCGPoint, CGPointValue)

/// @property(nonatomic, assign) CGSize xxx
#define FDUISynthesizeCGSizeProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGSize, valueWithCGSize, CGSizeValue)

/// @property(nonatomic, assign) CGRect xxx
#define FDUISynthesizeCGRectProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGRect, valueWithCGRect, CGRectValue)

/// @property(nonatomic, assign) UIEdgeInsets xxx
#define FDUISynthesizeUIEdgeInsetsProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, UIEdgeInsets, valueWithUIEdgeInsets, UIEdgeInsetsValue)

/// @property(nonatomic, assign) CGVector xxx
#define FDUISynthesizeCGVectorProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGVector, valueWithCGVector, CGVectorValue)

/// @property(nonatomic, assign) CGAffineTransform xxx
#define FDUISynthesizeCGAffineTransformProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, CGAffineTransform, valueWithCGAffineTransform, CGAffineTransformValue)

/// @property(nonatomic, assign) NSDirectionalEdgeInsets xxx
#define FDUISynthesizeNSDirectionalEdgeInsetsProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, NSDirectionalEdgeInsets, valueWithDirectionalEdgeInsets, NSDirectionalEdgeInsetsValue)

/// @property(nonatomic, assign) UIOffset xxx
#define FDUISynthesizeUIOffsetProperty(_getterName, _setterName) _FDUISynthesizeNonObject(_getterName, _setterName, UIOffset, valueWithUIOffset, UIOffsetValue)

#endif /* FDCategoryPropertyDefine_h */
