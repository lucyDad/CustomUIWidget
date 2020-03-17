#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FDCustomUIWidgetDef.h"
#import "UIImage+FRColor.h"
#import "FDAlertViewCommonDef.h"
#import "FDAnimationManagerView.h"
#import "FDCommonAlertPresentManager.h"
#import "FDCommonAlertView.h"
#import "FDCommonButtonView.h"
#import "UIView+FDAlertView.h"
#import "FDMarqueeView.h"

FOUNDATION_EXPORT double CustomUIWidgetVersionNumber;
FOUNDATION_EXPORT const unsigned char CustomUIWidgetVersionString[];

