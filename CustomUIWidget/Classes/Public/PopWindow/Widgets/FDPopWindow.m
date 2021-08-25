//
//  FDPopWindow.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import "FDPopWindow.h"

@implementation FDPopWindow

#pragma mark - Public Interface

#pragma mark - Life Cycle

#pragma mark - Event Response

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"点击了window point = %@", NSStringFromCGPoint(point));
    BOOL isHitTest = NO;
    if (CGRectContainsPoint(self.clickRect, point)) {
        isHitTest = YES;
    }
    
    if (!isHitTest) {
        // 没有点击区域clickRect，则不需要继续查找hitTest子view，直接返回（则点击事件会被透传下去）
        NSLog(@"没有点击区域clickRect, 不需要继续查找hitTest, 点击事件透传下去");
        return nil;
    }
    // 点击了可点击区域clickRect，则需要继续传递hitTest探测
    NSLog(@"点击了可点击区域clickRect，则需要继续传递hitTest探测");
    return [super hitTest:point withEvent:event];
}

#pragma mark - Private Methods

#pragma mark - Setter or Getter

@end
