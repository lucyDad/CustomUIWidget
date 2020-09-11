//
//  FDUserInfoModel.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2020/9/11.
//  Copyright © 2020 lucyDad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDAutoPlaceViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDUserInfoModel : NSObject<FDAutoPlaceViewProtocol>

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) NSString *workcity;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSArray<NSString *> *medalInfos;

@end

NS_ASSUME_NONNULL_END
