//
//  UIView+LongPressDrag.h
//  FunnyRecord
//
//  Created by hexiang on 2019/12/2.
//  Copyright © 2019 HeXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LongPressDrag)

@property (nonatomic, assign) UIEdgeInsets  longPressDragEdgeInsets;

- (void)addLongPressDragGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
