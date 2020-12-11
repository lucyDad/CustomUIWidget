//
//  UIView+LongPressDrag.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/2.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "UIView+LongPressDrag.h"
#import "UIView+YYAdd.h"
#import <objc/runtime.h>

@implementation UIView (LongPressDrag)

- (void)addLongPressDragGestureRecognizer {
    UIPanGestureRecognizer *longPressGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDrag_panGestureAction:)];
    [self addGestureRecognizer:longPressGes];
}

- (void)longPressDrag_panGestureAction:(UIPanGestureRecognizer *)longPressGes {
    //LOGGO_INFO(@"longPressGes.state = %ld", longPressGes.state);
    CGFloat superViewWidth = self.superview.width;
    CGFloat superViewHeight = self.superview.height;
    CGPoint point = [longPressGes locationInView:self];
    switch (longPressGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.longPressDragStartPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //LOGGO_INFO(@"x = %f, y = %f", point.x - self.longPressDragStartPoint.x, point.y - self.longPressDragStartPoint.y);
            CGFloat xOffset = point.x - self.longPressDragStartPoint.x;
            CGFloat yOffset = point.y - self.longPressDragStartPoint.y;
    
            CGFloat left = self.left + xOffset;
            CGFloat top = self.top + yOffset;
            
            self.left = [self longPressDrag_getFinalValue:left range:NSMakeRange(0, superViewWidth - self.width)];
            self.top = [self longPressDrag_getFinalValue:top range:NSMakeRange(0, superViewHeight - self.height)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {

            CGFloat minTopXpos = self.longPressDragEdgeInsets.top;
            CGFloat maxTopXpos = superViewHeight - self.height - self.longPressDragEdgeInsets.bottom;
            if (self.top < minTopXpos || self.top > maxTopXpos) {
                //LOGGO_WARN(@"Ended self.top = %f", self.top);
                if (self.top < minTopXpos ) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        self.top = minTopXpos;
                    }];
                } else if (self.top > maxTopXpos) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.top = maxTopXpos;
                    }];
                }
            } else {
                //LOGGO_WARN(@"Ended self.left = %f, middle = %f", self.left, SCREEN_WIDTH / 2.0f - self.width / 2.0f);
                if (self.left < superViewWidth / 2.0f - self.width / 2.0f) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        self.left = self.longPressDragEdgeInsets.left;
                    }];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.right = superViewWidth - self.longPressDragEdgeInsets.right;
                    }];
                }
            }
            
            break;
        }
        default:
            break;
    }
}

- (CGFloat)longPressDrag_getFinalValue:(CGFloat)origin range:(NSRange)range {
    CGFloat final = origin;
    if (origin < range.location) {
        final = range.location;
    } else if (origin > range.location + range.length) {
        final = range.location + range.length;
    }
    return final;
}

- (CGPoint)longPressDragStartPoint {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return [value CGPointValue];
}

- (void)setLongPressDragStartPoint:(CGPoint)longPressDragStartPoint {
    NSValue *value = [NSValue valueWithCGPoint:longPressDragStartPoint];
    objc_setAssociatedObject(self, @selector(longPressDragStartPoint), value, OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)longPressDragEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return [value UIEdgeInsetsValue];
}

- (void)setLongPressDragEdgeInsets:(UIEdgeInsets)longPressDragEdgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:longPressDragEdgeInsets];
    objc_setAssociatedObject(self, @selector(longPressDragEdgeInsets), value, OBJC_ASSOCIATION_RETAIN);
}

@end
