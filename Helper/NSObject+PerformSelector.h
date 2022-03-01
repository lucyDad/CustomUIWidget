//
//  NSObject+PerformSelector.h
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PerformSelector)

/**
 判断当前类是否有重写某个父类的指定方法
 
 @param selector 要判断的方法
 @param superclass 要比较的父类，必须是当前类的某个 superclass
 @return YES 表示子类有重写了父类方法，NO 表示没有重写（异常情况也返回 NO，例如当前类与指定的类并非父子关系、父类本身也无法响应指定的方法）
 */
- (BOOL)fd_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass;

/**
 判断指定的类是否有重写某个父类的指定方法
 
 @param selector 要判断的方法
 @param superclass 要比较的父类，必须是当前类的某个 superclass
 @return YES 表示子类有重写了父类方法，NO 表示没有重写（异常情况也返回 NO，例如当前类与指定的类并非父子关系、父类本身也无法响应指定的方法）
 */
+ (BOOL)fd_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @return 消息执行后的结果
 @link http://stackoverflow.com/questions/14635024/using-objc-msgsendsuper-to-invoke-a-class-method @/link
 */
- (nullable id)fd_performSelectorToSuperclass:(SEL)aSelector;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @param object 作为参数传过去
 @return 消息执行后的结果
 @link http://stackoverflow.com/questions/14635024/using-objc-msgsendsuper-to-invoke-a-class-method @/link
 */
- (nullable id)fd_performSelectorToSuperclass:(SEL)aSelector withObject:(nullable id)object;

/**
 *  调用一个无参数、返回值类型为非对象的 selector。如果返回值类型为对象，请直接使用系统的 performSelector: 方法。
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址，请先定义一个变量再将其指针地址传进来，例如 &result
 *
 *  @code
 *  CGFloat alpha;
 *  [view qmui_performSelector:@selector(alpha) withPrimitiveReturnValue:&alpha];
 *  @endcode
 */
- (void)fd_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue;

/**
 *  调用一个带参数的 selector，参数类型支持对象和非对象，也没有数量限制。返回值为对象或者 void。
 *  @param selector 要被调用的方法名
 *  @param firstArgument 参数列表，请传参数的指针地址，支持多个参数
 *  @return 方法的返回值，如果该方法返回类型为 void，则会返回 nil，如果返回类型为对象，则返回该对象。
 *
 *  @code
 *  id target = xxx;
 *  SEL action = xxx;
 *  UIControlEvents events = xxx;
 *  [control qmui_performSelector:@selector(addTarget:action:forControlEvents:) withArguments:&target, &action, &events, nil];
 *  @endcode
 */
- (nullable id)fd_performSelector:(SEL)selector withArguments:(nullable void *)firstArgument, ...;

/**
 *  调用一个返回值类型为非对象且带参数的 selector，参数类型支持对象和非对象，也没有数量限制。
 *
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 *  @param firstArgument 参数列表，请传参数的指针地址，支持多个参数
 *
 *  @code
 *  CGPoint point = xxx;
 *  UIEvent *event = xxx;
 *  BOOL isInside;
 *  [view qmui_performSelector:@selector(pointInside:withEvent:) withPrimitiveReturnValue:&isInside arguments:&point, &event, nil];
 *  @endcode
 */
- (void)fd_performSelector:(SEL)selector withPrimitiveReturnValue:(nullable void *)returnValue arguments:(nullable void *)firstArgument, ...;


/**
 使用 block 遍历指定 class 的所有成员变量（也即 _xxx 那种），不包含 property 对应的 _property 成员变量，也不包含 superclasses 里定义的变量
 
 @param block 用于遍历的 block
 */
- (void)fd_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block;

/**
 使用 block 遍历指定 class 的所有成员变量（也即 _xxx 那种），不包含 property 对应的 _property 成员变量
 
 @param aClass 指定的 class
 @param includingInherited 是否要包含由继承链带过来的 ivars
 @param block  用于遍历的 block
 */
+ (void)fd_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block;

/**
 使用 block 遍历指定 class 的所有属性，不包含 superclasses 里定义的 property
 
 @param block 用于遍历的 block，如果要获取 property 的信息，推荐用 QMUIPropertyDescriptor。
 */
- (void)fd_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

/**
 使用 block 遍历指定 class 的所有属性
 
 @param aClass 指定的 class
 @param includingInherited 是否要包含由继承链带过来的 property
 @param block 用于遍历的 block，如果要获取 property 的信息，推荐用 QMUIPropertyDescriptor。
 @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW1
 */
+ (void)fd_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t property, NSString *propertyName))block;

/**
 使用 block 遍历当前实例的所有方法，不包含 superclasses 里定义的 method
 */
- (void)fd_enumrateInstanceMethodsUsingBlock:(void (^)(Method method, SEL selector))block;

/**
 使用 block 遍历指定的某个类的实例方法
 @param aClass   指定的 class
 @param includingInherited 是否要包含由继承链带过来的 method
 @param block    用于遍历的 block
 */
+ (void)fd_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method method, SEL selector))block;

/**
 遍历某个 protocol 里的所有方法
 
 @param protocol 要遍历的 protocol，例如 \@protocol(xxx)
 @param block 遍历过程中调用的 block
 */
+ (void)fd_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL selector))block;

@end

@interface NSObject (FDUI_Debug)

/// 获取当前对象的所有 @property、方法，父类的方法也会分别列出
- (NSString *)fd_methodList;

/// 获取当前对象的所有 @property、方法，不包含父类的
- (NSString *)fd_shortMethodList;

/// 获取当前对象的所有 Ivar 变量
- (NSString *)fd_ivarList;
@end


NS_ASSUME_NONNULL_END
