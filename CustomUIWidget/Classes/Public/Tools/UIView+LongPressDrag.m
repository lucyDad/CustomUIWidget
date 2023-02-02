//
//  UIView+LongPressDrag.m
//  FunnyRecord
//
//  Created by hexiang on 2019/12/2.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import "UIView+LongPressDrag.h"
#import <objc/runtime.h>

@implementation UIView (LongPressDrag)

- (void)addLongPressDragGestureRecognizer {
    UIPanGestureRecognizer *longPressGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDrag_panGestureAction:)];
    [self addGestureRecognizer:longPressGes];
}

- (void)longPressDrag_panGestureAction:(UIPanGestureRecognizer *)longPressGes {
    //LOGGO_INFO(@"longPressGes.state = %ld", longPressGes.state);
    CGFloat superViewWidth = (nil == self.superview ? [UIScreen mainScreen].bounds.size.width :  CGRectGetWidth(self.superview.frame));
    CGFloat superViewHeight = (nil == self.superview ? [UIScreen mainScreen].bounds.size.height : CGRectGetHeight(self.superview.frame));
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
    
            CGFloat left = CGRectGetMinX(moveView.frame) + xOffset;
            CGFloat top = CGRectGetMinY(moveView.frame) + yOffset;
            
            CGSize moveSize = moveView.frame.size;
            CGFloat moveMinX = [self longPressDrag_getFinalValue:left range:NSMakeRange(0, superViewWidth - moveSize.width)];
            CGFloat moveMinY = [self longPressDrag_getFinalValue:top range:NSMakeRange(0, superViewHeight - moveSize.height)];
            moveView.frame = CGRectMake(moveMinX, moveMinY, moveSize.width, moveSize.height);
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGFloat minTopXpos = moveView.longPressDragEdgeInsets.top;
            CGFloat maxTopXpos = superViewHeight - CGRectGetHeight(moveView.frame) - moveView.longPressDragEdgeInsets.bottom;
            __block CGRect moveFrame = moveView.frame;
            CGFloat moveMinY = CGRectGetMinX(moveView.frame);
            CGFloat moveMinX = CGRectGetMinX(moveView.frame);
            if (moveMinY < minTopXpos || moveMinY > maxTopXpos) {
                //LOGGO_WARN(@"Ended self.top = %f", self.top);
                if (moveMinY < minTopXpos ) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        moveFrame.origin.x = minTopXpos;
                        moveView.frame = moveFrame;
                    }];
                } else if (moveMinY > maxTopXpos) {
                    [UIView animateWithDuration:0.2 animations:^{
                        moveFrame.origin.y = maxTopXpos;
                        moveView.frame = moveFrame;
                    }];
                }
            } else {
                //LOGGO_WARN(@"Ended self.left = %f, middle = %f", self.left, SCREEN_WIDTH / 2.0f - self.width / 2.0f);
                if (moveMinX < superViewWidth / 2.0f - moveFrame.size.width / 2.0f) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        moveFrame.origin.x = moveView.longPressDragEdgeInsets.left;
                        moveView.frame = moveFrame;
                    }];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        moveFrame.origin.x = (superViewWidth - moveView.longPressDragEdgeInsets.right) - moveFrame.size.width;
                        moveView.frame = moveFrame;
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
