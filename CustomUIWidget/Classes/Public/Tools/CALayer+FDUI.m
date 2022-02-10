//
//  CALayer+FDUI.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/12/22.
//

#import "CALayer+FDUI.h"
#import <Aspects/Aspects.h>
#import "FDCategoryPropertyDefine.h"

@implementation CALayer (FDUI)

FDUISynthesizeCGFloatProperty(fdui_originCornerRadius, setFdui_originCornerRadius)
FDUISynthesizeUnsignedIntProperty(fdui_originMaskedCorners, setFdui_originMaskedCorners)

- (void)fdui_sendSublayerToBack:(CALayer *)sublayer {
    [self insertSublayer:sublayer atIndex:0];
}

- (void)fdui_bringSublayerToFront:(CALayer *)sublayer {
    [self insertSublayer:sublayer atIndex:(unsigned)self.sublayers.count];
}

@end
