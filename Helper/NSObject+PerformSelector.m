//
//  NSObject+PerformSelector.m
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#import "NSObject+PerformSelector.h"
#import <objc/message.h>
#import "FDCommonDefine.h"
#import "NSString+FDHandle.h"

@implementation NSObject (PerformSelector)

- (BOOL)fd_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    return [NSObject fd_hasOverrideMethod:selector forClass:self.class ofSuperclass:superclass];
}

+ (BOOL)fd_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass {
    if (![aClass isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (id)fd_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)fd_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

- (id)fd_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    const char *typeEncoding = method_getTypeEncoding(class_getInstanceMethod(object_getClass(self), selector));
    if (isObjectTypeEncoding(typeEncoding)) {
        __unsafe_unretained id returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return nil;
}

- (void)fd_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self fd_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)fd_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSAssert(methodSignature, @"NSObject (QMUI)", @"- [%@ qmui_performSelector:@selector(%@)] 失败，方法不存在。", NSStringFromClass(self.class), NSStringFromSelector(selector));
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)fd_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    [self fd_enumrateIvarsIncludingInherited:NO usingBlock:block];
}

- (void)fd_enumrateIvarsIncludingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    NSMutableArray<NSString *> *ivarDescriptions = [NSMutableArray new];
    NSString *ivarList = [self fd_ivarList];
    NSError *error;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"in %@:(.*?)((?=in \\w+:)|$)", NSStringFromClass(self.class)] options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (!error) {
        NSArray<NSTextCheckingResult *> *result = [reg matchesInString:ivarList options:NSMatchingReportCompletion range:NSMakeRange(0, ivarList.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ivars = [ivarList substringWithRange:[obj rangeAtIndex:1]];
            [ivars enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
                if (![line hasPrefix:@"\t\t"]) {// 有些 struct 类型的变量，会把 struct 的成员也缩进打出来，所以用这种方式过滤掉
                    line = line.fd_trim;
                    if (line.length > 2) {// 过滤掉空行或者 struct 结尾的"}"
                        NSRange range = [line rangeOfString:@":"];
                        if (range.location != NSNotFound)// 有些"unknow type"的变量不会显示指针地址（例如 UIView->_viewFlags）
                            line = [line substringToIndex:range.location];// 去掉指针地址
                        NSUInteger typeStart = [line rangeOfString:@" ("].location;
                        line = [NSString stringWithFormat:@"%@ %@", [line substringWithRange:NSMakeRange(typeStart + 2, line.length - 1 - (typeStart + 2))], [line substringToIndex:typeStart]];// 交换变量类型和变量名的位置，变量类型在前，变量名在后，空格隔开
                        [ivarDescriptions addObject:line];
                    }
                }
            }];
        }];
    }
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
        for (NSString *desc in ivarDescriptions) {
            if ([desc hasSuffix:ivarName]) {
                block(ivar, desc);
                break;
            }
        }
    }
    free(ivars);
    
    if (includingInherited) {
        Class superclass = self.superclass;
        if (superclass) {
            [NSObject fd_enumrateIvarsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)fd_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar, NSString *))block {
    if (!block) return;
    NSObject *obj = nil;
    if ([aClass isSubclassOfClass:[UICollectionView class]]) {
        obj = [[aClass alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
    } else if ([aClass isSubclassOfClass:[UIApplication class]]) {
        obj = UIApplication.sharedApplication;
    } else {
        obj = [aClass new];
    }
    [obj fd_enumrateIvarsIncludingInherited:includingInherited usingBlock:block];
}

- (void)fd_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    [NSObject fd_enumratePropertiesOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)fd_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t, NSString *))block {
    if (!block) return;
    
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        if (block) block(property, [NSString stringWithFormat:@"%s", property_getName(property)]);
    }
    
    free(properties);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject fd_enumratePropertiesOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

- (void)fd_enumrateInstanceMethodsUsingBlock:(void (^)(Method, SEL))block {
    [NSObject fd_enumrateInstanceMethodsOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)fd_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method, SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(method, selector);
    }
    
    free(methods);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject fd_enumrateInstanceMethodsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)fd_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

@end

@implementation NSObject (FDUI_Debug)

BeginIgnorePerformSelectorLeaksWarning
- (NSString *)fd_methodList {
    return [self performSelector:NSSelectorFromString(@"_methodDescription")];
}

- (NSString *)fd_shortMethodList {
    return [self performSelector:NSSelectorFromString(@"_shortMethodDescription")];
}

- (NSString *)fd_ivarList {
    return [self performSelector:NSSelectorFromString(@"_ivarDescription")];
}
EndIgnorePerformSelectorLeaksWarning

@end
