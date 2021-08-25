//
//  UIView+FDPopWindow.h
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FDPopWindow)

@property (nonatomic, assign) NSInteger  sequenceId;

@property (nonatomic, assign, getter=isViewWillDisappear) BOOL  viewWillDisappear;

- (void)removeAllSubviews;

@end

NS_ASSUME_NONNULL_END
