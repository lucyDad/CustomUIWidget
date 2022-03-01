//
//  FDTestViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/1/25.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import "FDTestViewController.h"
#import <Aspects/Aspects.h>
#import "UIControl+YYAdd.h"
#import "NSData+BytesUtils.h"

@interface TestLayoutLayer : CALayer

@end

@implementation TestLayoutLayer

- (void)setNeedsLayout {
    [super setNeedsLayout];
    NSLog(@"%s", __func__);
}

/* Returns true when the receiver is marked as needing layout. */

/* Traverse upwards from the layer while the superlayer requires layout.
 * Then layout the entire tree beneath that ancestor. */

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    NSLog(@"%s", __func__);
}

/* Called when the layer requires layout. The default implementation
 * calls the layout manager if one exists and it implements the
 * -layoutSublayersOfLayer: method. Subclasses can override this to
 * provide their own layout algorithm, which should set the frame of
 * each sublayer. */

- (void)layoutSublayers {
    [super layoutSublayers];
    NSLog(@"%s", __func__);
}

/* Reload the content of this layer. Calls the -drawInContext: method
 * then updates the `contents' property of the layer. Typically this is
 * not called directly. */

- (void)display {
    [super display];
    NSLog(@"%s", __func__);
}

/* Marks that -display needs to be called before the layer is next
 * committed. If a region is specified, only that region of the layer
 * is invalidated. */

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    NSLog(@"%s", __func__);
}

- (void)setNeedsDisplayInRect:(CGRect)r {
    [super setNeedsDisplayInRect:r];
    NSLog(@"%s", __func__);
}

/* Returns true when the layer is marked as needing redrawing. */

//- (BOOL)needsDisplay;

/* Call -display if receiver is marked as needing redrawing. */

- (void)displayIfNeeded {
    [super displayIfNeeded];
    NSLog(@"%s", __func__);
}

/* Called via the -display method when the `contents' property is being
 * updated. Default implementation does nothing. The context may be
 * clipped to protect valid layer content. Subclasses that wish to find
 * the actual region to draw can call CGContextGetClipBoundingBox(). */

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    NSLog(@"%s", __func__);
}

/** Rendering properties and methods. **/

/* Renders the receiver and its sublayers into 'ctx'. This method
 * renders directly from the layer tree. Renders in the coordinate space
 * of the layer.
 *
 * WARNING: currently this method does not implement the full
 * CoreAnimation composition model, use with caution. */

- (void)renderInContext:(CGContextRef)ctx {
    [super renderInContext:ctx];
    NSLog(@"%s", __func__);
}

@end

@interface TestLayoutView : UIView

@end

@implementation TestLayoutView

+ (Class)layerClass {
    return [TestLayoutLayer class];
}

/* If defined, called by the default implementation of the -display
 * method, in which case it should implement the entire display
 * process (typically by setting the `contents' property). */

- (void)displayLayer:(CALayer *)layer {
    [super displayLayer:layer];
    NSLog(@"%s", __func__);
}

/* If defined, called by the default implementation of -drawInContext: */

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    NSLog(@"%s", __func__);
}

/* If defined, called by the default implementation of the -display method.
 * Allows the delegate to configure any layer state affecting contents prior
 * to -drawLayer:InContext: such as `contentsFormat' and `opaque'. It will not
 * be called if the delegate implements -displayLayer. */

- (void)layerWillDraw:(CALayer *)layer {
    [super layerWillDraw:layer];
    NSLog(@"%s", __func__);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    NSLog(@"%s", __func__);
}

- (nullable id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    NSLog(@"%s", __func__);
    return [super actionForLayer:layer forKey:event];
}

@end

@interface UIViewNew : NSObject

@end

@implementation UIViewNew

- (void)setAlignment:(NSTextAlignment)alignment {
    NSLog(@"hexiang>>>UIViewNew");
}

+ (void)classAction {
    NSLog(@"hexiang>>>UIViewNew %s", __func__);
}

- (void)backAction {
    NSLog(@"hexiang>>>UIViewNew %s", __func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@", __func__, NSStringFromSelector(sel));
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@", __func__, NSStringFromSelector(sel));
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@", __func__, NSStringFromSelector(aSelector));
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

//    NSMethodSignature *sig1 = [UIViewNew methodSignatureForSelector:@selector(classAction)];
//    NSMethodSignature *sig2 = [UIViewNew instanceMethodSignatureForSelector:@selector(backAction)];
//    NSLog(@"hexiang>>>UIViewNew %s, sel = %@, sig1 = %@, sig2 = %@", __func__, NSStringFromSelector(aSelector), sig1, sig2);
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@, sig = %@", __func__, NSStringFromSelector(aSelector), sig);
    return sig;
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"@@:"];
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@, sig = %@", __func__, NSStringFromSelector(aSelector), sig);
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    NSLog(@"hexiang>>>UIViewNew %s, sel = %@", __func__, NSStringFromSelector([anInvocation selector]));
    [self backAction];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"hexiang>>>UIViewNew %s, sel = %@", __func__, NSStringFromSelector(aSelector));
}

@end

static inline BOOL
ExchangeImplementationsInTwoClasses(Class _fromClass, SEL _originSelector, Class _toClass, SEL _newSelector) {
    if (!_fromClass || !_toClass) {
        return NO;
    }
    
    Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
    if (!newMethod) {
        return NO;
    }
    
    BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP oriMethodIMP = method_getImplementation(oriMethod) ?: imp_implementationWithBlock(^(id selfObject) {});
        const char *oriMethodTypeEncoding = method_getTypeEncoding(oriMethod) ?: "v@:";
        class_replaceMethod(_toClass, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    } else {
        IMP ori = method_getImplementation(oriMethod);
        IMP newm = method_getImplementation(newMethod);
        NSLog(@"hexiang>>>ori = %p, new = %p", ori, newm);
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

typedef struct {double d;} __FelixDouble__;
typedef struct {float f;} __FelixFloat__;

@interface FDTestViewController ()

@property (nonatomic, strong) TestLayoutView *layoutView;
@end

@implementation FDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    NSInteger result = [self textInvocation];
    NSLog(@"result = %ld", result);
}

- (void)params_getDictionaryValue:(NSObject *)obj sel:(SEL)sel protocol:(Protocol *)protocol {
    if (![obj conformsToProtocol:protocol]) {
        return ;
    }
    NSMethodSignature *signature = [obj methodSignatureForSelector:sel];
    if ( nil == signature) {
        // 该对象不存在该方法
        return;
    }
    //
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = sel;
    [invocation invoke];
    
    char returnType[255];
    strcpy(returnType, [signature methodReturnType]);
    
    if (strncmp(returnType, "v", 1) != 0) {
        if (strncmp(returnType, "@", 1) == 0) {
            // 返回值为对象
            id _ret = nil;
            [invocation getReturnValue:&_ret];
            return;
        } else {
            // 返回值为普通类型
            NSUInteger length = [signature methodReturnLength];
            void *buffer = (void *)malloc(length);
            [invocation getReturnValue:buffer];

            NSData *data = [[NSData alloc] initWithBytes:buffer length:strlen(buffer)];
            NSString *lenHexStr = [data np_hexStr];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [f numberFromString:lenHexStr];
            
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                case 'c':
                {
                    char value = [number charValue];
                    break;
                }
                case 'C':
                {
                    unsigned char value = [number unsignedCharValue];
                    break;
                }
                case 's':
                {
                    short value = [number shortValue];
                    break;
                }
                case 'S':
                {
                    unsigned short value = [number unsignedShortValue];
                    break;
                }
                case 'i':
                {
                    int value = [number intValue];
                    break;
                }
                case 'I':
                {
                    unsigned int value = [number unsignedIntValue];
                    break;
                }
                case 'l':
                {
                    long value = [number longValue];
                    break;
                }
                case 'L':
                {
                    unsigned long value = [number unsignedLongValue];
                    break;
                }
                case 'q':
                {
                    long long value = [number longLongValue];
                    break;
                }
                case 'Q':
                {
                    unsigned long long value = [number unsignedLongLongValue];
                    break;
                }
                case 'f':
                {
                    float value = [number floatValue];
                    break;
                }
                case 'd':
                {
                    double value = [number doubleValue];
                    break;
                }
                case 'B':
                {
                    BOOL value = [number boolValue];
                    break;
                }
            }
            free(buffer);
            return;
        }
    }
}

// Objective-C不支持long double类型。 @encode（long double）返回d，该编码与double相同

- (NSInteger)textInvocation {
    NSString *name = NSStringFromSelector(@selector(textChange));
    
    NSMethodSignature *signature = [self methodSignatureForSelector:NSSelectorFromString(name)];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = NSSelectorFromString(name);
    [invocation invoke];
    return 1;
}

- (NSInteger)textChange {

    NSLog(@"hexiang");
    UIButton *button = ({
        CGRect frame = CGRectMake(0, 100, 100, 100);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:@"aspect" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.backgroundColor = [UIColor redColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self buttonAction];
        }];
        button;
    });
    [self.view addSubview:button];
    
    return 1000000;
}

- (void)buttonAction {
    NSError *error = nil;
    id<AspectToken> token = [UILabel aspect_hookSelector:@selector(setTextAlignment:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){

        UIView *selfObject = [info instance];
        NSInvocation *invocation = [info originalInvocation];
        id target = [invocation target];
        IMP imp = class_getMethodImplementation([selfObject class], invocation.selector);
        NSLog(@"hexiang>>>selfObject = %p, target = %p, imp = %p", selfObject, target, imp);
        //[invocation invoke];
    } error:&error];
    if (error) {
        NSLog(@"hexiang>>>error = %@", error);
    }
    NSLog(@"hexiang>>>add success token = %@", token);
    
    ExchangeImplementationsInTwoClasses([UILabel class], @selector(setTextAlignment:), [UIViewNew class], @selector(setAlignment:));
    
    IMP impLabel = class_getMethodImplementation([UILabel class], @selector(setTextAlignment:));
    IMP impNew = class_getMethodImplementation([UIViewNew class], @selector(setAlignment:));
    NSLog(@"hexiang>>>impLabel = %p, impNew = %p", impLabel, impNew);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    NSLog(@"hexiang>>>label = %p", label);
    label.text = @"hexiang";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor greenColor];
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    
    UIViewNew *w = [UIViewNew new];
    [w performSelector:NSSelectorFromString(@"xxx")];
    //[w setAlignment:NSTextAlignmentCenter];
}

- (void)textLayout {
    self.layoutView = ({
        TestLayoutView *view = [TestLayoutView new];
        view.backgroundColor = [UIColor redColor];
        view.top = 100;
        view.size = CGSizeMake(100, 100);
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [view addGestureRecognizer:tapGes];
        view;
    });
    [self.view addSubview:self.layoutView];
}

- (void)tapGesture {
    self.layoutView.size = CGSizeMake(200, 200);
}

@end
