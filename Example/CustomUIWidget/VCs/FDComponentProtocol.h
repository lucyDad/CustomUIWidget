//
//  FDComponentProtocol.h
//  CustomUIWidget_Example
//
//  Created by hexiang on 2022/2/9.
//  Copyright © 2022 lucyDad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FDComponentProtocol <NSObject>

+ (NSString *)componetName;

+ (UIView *)exampleShowView:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
