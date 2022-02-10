//
//  UIView+FDHierarchy.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FDHierarchy)

/**
 Returns the UIViewController object that manages the receiver.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *viewContainingController;

/**
 Returns the topMost UIViewController object in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *topMostController;

@end

NS_ASSUME_NONNULL_END
