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
    CGFloat superViewWidth = (nil == self.superview ? [UIScreen mainScreen].bounds.size.width : self.superview.width);
    CGFloat superViewHeight = (nil == self.superview ? [UIScreen mainScreen].bounds.size.height : self.superview.height);
    CGPoint point = [longPressGes locationInView:self];
    UIView *moveView = self;
    switch (longPressGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            moveView.longPressDragStartPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //LOGGO_INFO(@"x = %f, y = %f", point.x - self.longPressDragStartPoint.x, point.y - self.longPressDragStartPoint.y);
            CGFloat xOffset = point.x - moveView.longPressDragStartPoint.x;
            CGFloat yOffset = point.y - moveView.longPressDragStartPoint.y;
    
            CGFloat left = moveView.left + xOffset;
            CGFloat top = moveView.top + yOffset;
            
            moveView.left = [self longPressDrag_getFinalValue:left range:NSMakeRange(0, superViewWidth - moveView.width)];
            moveView.top = [self longPressDrag_getFinalValue:top range:NSMakeRange(0, superViewHeight - moveView.height)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {

            CGFloat minTopXpos = moveView.longPressDragEdgeInsets.top;
            CGFloat maxTopXpos = superViewHeight - moveView.height - moveView.longPressDragEdgeInsets.bottom;
            if (moveView.top < minTopXpos || moveView.top > maxTopXpos) {
                //LOGGO_WARN(@"Ended self.top = %f", self.top);
                if (moveView.top < minTopXpos ) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        moveView.top = minTopXpos;
                    }];
                } else if (moveView.top > maxTopXpos) {
                    [UIView animateWithDuration:0.2 animations:^{
                        moveView.top = maxTopXpos;
                    }];
                }
            } else {
                //LOGGO_WARN(@"Ended self.left = %f, middle = %f", self.left, SCREEN_WIDTH / 2.0f - self.width / 2.0f);
                if (moveView.left < superViewWidth / 2.0f - moveView.width / 2.0f) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        moveView.left = moveView.longPressDragEdgeInsets.left;
                    }];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        moveView.right = superViewWidth - moveView.longPressDragEdgeInsets.right;
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
