//
//  FDAutoPlaceView.h
//  CustomUIWidget
//
//  Created by hexiang on 2020/9/10.
//

#import <UIKit/UIKit.h>
#import "FDAutoPlaceViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FDAutoPlaceViewConfig : NSObject

@property (nonatomic, assign) UIEdgeInsets  contentEdgeInsets;  // 整个view的内容偏移(默认(5, 10, 5, 10))
@property (nonatomic, assign) CGFloat  contentRowInterval;      // 内容每行中view之间的间距
@property (nonatomic, assign) CGFloat  contentColumnInterval;   // 内容每行之间的间距

@end

@interface FDAutoPlaceView : UIView

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth andConfig:(FDAutoPlaceViewConfig *)config;

#pragma mark - 直接传入view形式

@property (nonatomic, strong) NSArray<UIView *> *placeViews;

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth
                       andConfig:(FDAutoPlaceViewConfig *)config
                           views:(nullable NSArray<UIView *> *)views;

+ (CGFloat)allHeightOfAutoPlaceView:(CGFloat)maxWidth
                             config:(FDAutoPlaceViewConfig *)config
                              views:(NSArray<UIView *> *)views;

#pragma mark - 传入符合协议的对象形式

@property (nonatomic, strong) id<FDAutoPlaceViewProtocol> placeViewProtocol;

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth
                       andConfig:(FDAutoPlaceViewConfig *)config
                    viewProtocol:(id<FDAutoPlaceViewProtocol>)viewProtocol;

+ (CGFloat)allHeightOfAutoPlaceView:(CGFloat)maxWidth
                             config:(FDAutoPlaceViewConfig *)config
                       viewProtocol:(id<FDAutoPlaceViewProtocol>)viewProtocol;

@end

NS_ASSUME_NONNULL_END
