//
//  FDSelectListView.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/1/24.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDOrderedDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@class FDSelectListView;

@interface FDSelectListView : UIView

@property (nonatomic, strong) void(^clickListCell)(FDSelectListView *weakListView, NSInteger index, FDOrderedDictionary<NSString *, NSNumber *> *updateDatas);

+ (instancetype)selectListView:(FDOrderedDictionary<NSString *, NSNumber *> *)datas width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
