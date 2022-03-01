//
//  FDRuntimeCommonDefines.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#ifndef FDRuntimeCommonDefines_h
#define FDRuntimeCommonDefines_h

#pragma mark - Ivar

/**
 用于判断一个给定的 type encoding（const char *）或者 Ivar 是哪种类型的系列函数。
 
 为了节省代码量，函数由宏展开生成，一个宏会展开为两个函数定义：
 
 1. isXxxTypeEncoding(const char *)，例如判断是否为 BOOL 类型的函数名为：isBOOLTypeEncoding()
 2. isXxxIvar(Ivar)，例如判断是否为 BOOL 的 Ivar 的函数名为：isBOOLIvar()
 
 @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 */
#define _QMUITypeEncodingDetectorGenerator(_TypeInFunctionName, _typeForEncode) \
    CG_INLINE BOOL is##_TypeInFunctionName##TypeEncoding(const char *typeEncoding) {\
        return strncmp(@encode(_typeForEncode), typeEncoding, strlen(@encode(_typeForEncode))) == 0;\
    }\
    CG_INLINE BOOL is##_TypeInFunctionName##Ivar(Ivar ivar) {\
        return is##_TypeInFunctionName##TypeEncoding(ivar_getTypeEncoding(ivar));\
    }

_QMUITypeEncodingDetectorGenerator(Char, char)
_QMUITypeEncodingDetectorGenerator(Int, int)
_QMUITypeEncodingDetectorGenerator(Short, short)
_QMUITypeEncodingDetectorGenerator(Long, long)
_QMUITypeEncodingDetectorGenerator(LongLong, long long)
_QMUITypeEncodingDetectorGenerator(NSInteger, NSInteger)
_QMUITypeEncodingDetectorGenerator(UnsignedChar, unsigned char)
_QMUITypeEncodingDetectorGenerator(UnsignedInt, unsigned int)
_QMUITypeEncodingDetectorGenerator(UnsignedShort, unsigned short)
_QMUITypeEncodingDetectorGenerator(UnsignedLong, unsigned long)
_QMUITypeEncodingDetectorGenerator(UnsignedLongLong, unsigned long long)
_QMUITypeEncodingDetectorGenerator(NSUInteger, NSUInteger)
_QMUITypeEncodingDetectorGenerator(Float, float)
_QMUITypeEncodingDetectorGenerator(Double, double)
_QMUITypeEncodingDetectorGenerator(CGFloat, CGFloat)
_QMUITypeEncodingDetectorGenerator(BOOL, BOOL)
_QMUITypeEncodingDetectorGenerator(Void, void)
_QMUITypeEncodingDetectorGenerator(Character, char *)
_QMUITypeEncodingDetectorGenerator(Object, id)
_QMUITypeEncodingDetectorGenerator(Class, Class)
_QMUITypeEncodingDetectorGenerator(Selector, SEL)

//CG_INLINE char getCharIvarValue(id object, Ivar ivar) {
//    ptrdiff_t ivarOffset = ivar_getOffset(ivar);
//    unsigned char * bytes = (unsigned char *)(__bridge void *)object;
//    char value = *((char *)(bytes + ivarOffset));
//    return value;
//}

#define _QMUIGetIvarValueGenerator(_TypeInFunctionName, _typeForEncode) \
    CG_INLINE _typeForEncode get##_TypeInFunctionName##IvarValue(id object, Ivar ivar) {\
        ptrdiff_t ivarOffset = ivar_getOffset(ivar);\
        unsigned char * bytes = (unsigned char *)(__bridge void *)object;\
        _typeForEncode value = *((_typeForEncode *)(bytes + ivarOffset));\
        return value;\
    }

_QMUIGetIvarValueGenerator(Char, char)
_QMUIGetIvarValueGenerator(Int, int)
_QMUIGetIvarValueGenerator(Short, short)
_QMUIGetIvarValueGenerator(Long, long)
_QMUIGetIvarValueGenerator(LongLong, long long)
_QMUIGetIvarValueGenerator(UnsignedChar, unsigned char)
_QMUIGetIvarValueGenerator(UnsignedInt, unsigned int)
_QMUIGetIvarValueGenerator(UnsignedShort, unsigned short)
_QMUIGetIvarValueGenerator(UnsignedLong, unsigned long)
_QMUIGetIvarValueGenerator(UnsignedLongLong, unsigned long long)
_QMUIGetIvarValueGenerator(Float, float)
_QMUIGetIvarValueGenerator(Double, double)
_QMUIGetIvarValueGenerator(BOOL, BOOL)
_QMUIGetIvarValueGenerator(Character, char *)
_QMUIGetIvarValueGenerator(Selector, SEL)

CG_INLINE id getObjectIvarValue(id object, Ivar ivar) {
    return object_getIvar(object, ivar);
}

#endif /* FDRuntimeCommonDefines_h */
