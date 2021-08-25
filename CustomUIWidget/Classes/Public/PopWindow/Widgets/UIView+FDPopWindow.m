//
//  UIView+FDPopWindow.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import "UIView+FDPopWindow.h"
#import <objc/runtime.h>

@implementation UIView (FDPopWindow)

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)setSequenceId:(NSInteger)sequenceId {
    objc_setAssociatedObject(self, @selector(sequenceId), @(sequenceId), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)sequenceId {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setViewWillDisappear:(BOOL)viewWillDisappear {
    objc_setAssociatedObject(self, @selector(isViewWillDisappear), @(viewWillDisappear), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isViewWillDisappear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
