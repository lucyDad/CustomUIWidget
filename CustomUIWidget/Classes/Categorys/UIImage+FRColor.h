//
//  UIImage+FRColor.h
//  FirerageKit
//
//  Created by Aidian.Tang on 14-5-28.
//  Copyright (c) 2014年 Illidan.Firerage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FRColor)

/**
 纯色图片(没有圆角)

 @param color 纯色颜色
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 纯色图片

 @param color 纯色颜色
 @param size 大小
 @param roundSize 圆角
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size andRoundSize:(CGFloat)roundSize;

/**
 边框+纯色图片

 @param color 纯色颜色
 @param size 大小
 @param cornerRadiu 圆角
 @param borderColor 边框颜色
 @param borderWidth 边框厚度
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadiu borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 颜色渐变的图片(默认从左往右渐变,没有圆角)

 @param colors 各种颜色((id)CGColor)
 @param size 大小
 @return 颜色渐变的图片
 */
+ (UIImage *)imageWithColors:(NSArray<id> *)colors size:(CGSize)size;

/**
 颜色渐变的图片(默认从左往右渐变)

 @param colors 各种颜色((id)CGColor)
 @param size 大小
 @param cornerRadius 圆角
 @return 颜色渐变的图片
 */
+ (UIImage *)imageWithColors:(NSArray<id> *)colors size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 颜色渐变的图片

 @param colors 各种颜色((id)CGColor)
 @param size 大小
 @param cornerRadius 圆角
 @param startPoint 开始渐变的点(左上角是0,0 右下角是1,1)
 @param endPoint 结束渐变的点(左上角是0,0 右下角是1,1)
 @return 颜色渐变的图片
 */
+ (UIImage *)imageWithColors:(NSArray<id> *)colors size:(CGSize)size cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (UIColor *)colorAtPoint:(CGPoint)point;


/**
 取图片主色值

 @return 图片主色值
 */
- (UIColor *)mostColor;

/**
 取图片主色值 各个分值

 @return 取图片主色值 各个分值
 */
- (NSArray *)mostColorRGBAArrays;

/**
 取图片上某一点的色值

 @param point 取图片上某一点的色值
 @return <#return value description#>
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

@end
