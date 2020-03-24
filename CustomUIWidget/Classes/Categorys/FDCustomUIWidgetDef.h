//
//  FDCustomUIWidgetDef.h
//  Pods
//
//  Created by hexiang on 2020/3/12.
//

#ifndef FDCustomUIWidgetDef_h
#define FDCustomUIWidgetDef_h

#import "UIImage+FRColor.h"
#import <YYText/YYText.h>
#import <YYCategories/UIView+YYAdd.h>
#import <YYCategories/UIColor+YYAdd.h>
#import <libextobjc/extobjc.h>
#import <Masonry/Masonry.h>

#define FONT_MEDIUM_WITH_SIZE(SIZE) [UIFont fontWithName:@"PingFangSC-Medium" size:SIZE] //生成一个Medium字体的Font
#define FONT_REGULAR_WITH_SIZE(SIZE) [UIFont fontWithName:@"PingFangSC-Regular" size:SIZE]//生成一个Regular字体的Font
#define FONT_LIGHT_WITH_SIZE(SIZE) [UIFont fontWithName:@"PingFangSC-Light" size:SIZE]//生成一个Light字体的Font
#define FONT_SEMIBOLD_WITH_SIZE(SIZE) [UIFont fontWithName:@"PingFangSC-Semibold" size:SIZE]//生成一个Semibold字体的Font

#define LOGGO_INFO(fmt, ...)  NSLog((@"%s" "[%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define LOGGO_INFO(fmt, ...)  NSLog((@"[%s]" "%s" "[%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif /* FDCustomUIWidgetDef_h */
