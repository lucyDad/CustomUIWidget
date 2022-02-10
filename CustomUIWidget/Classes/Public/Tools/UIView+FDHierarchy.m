//
//  UIView+FDHierarchy.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/11/18.
//

#import "UIView+FDHierarchy.h"

@implementation UIView (FDHierarchy)

-(UIViewController*)viewContainingController {
    UIResponder *nextResponder = self;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder);
    return nil;
}

- (UIViewController *)topMostController {
    
    NSMutableArray<UIViewController*> *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    if (topController) {
        [controllersHierarchy addObject:topController];
    }
    // 查找present层级
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    
    // 找到view所在显示树最近的vc
    UIViewController *matchController = [self viewContainingController];
    
    // 查找view
    while (matchController && [controllersHierarchy containsObject:matchController] == NO)
    {
        // 响应链中找到下一个vc
        do
        {
            matchController = (UIViewController*)[matchController nextResponder];
            
        } while (matchController && [matchController isKindOfClass:[UIViewController class]] == NO);
    }
    
    return matchController;
}

@end
