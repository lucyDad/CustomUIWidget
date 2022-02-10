//
//  FDTestViewController.m
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/1/25.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import "FDTestViewController.h"

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

@interface FDTestViewController ()

@property (nonatomic, strong) TestLayoutView *layoutView;
@end

@implementation FDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
