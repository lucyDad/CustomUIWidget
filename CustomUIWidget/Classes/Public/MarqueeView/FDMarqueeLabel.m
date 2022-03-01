//
//  FDMarqueeLabel.m
//  CustomUIWidget
//
//  Created by hexiang on 2022/2/10.
//

#import "FDMarqueeLabel.h"

@interface FDMarqueeLabel ()
{
    
}

@property(nonatomic, strong) CADisplayLink *displayLink;    //
@property(nonatomic, assign) CGFloat offsetX; // 左边移动的偏移值
@property(nonatomic, assign) CGSize textSize;
@property(nonatomic, assign) CGFloat fadeStartPercent; // 渐变开始的百分比，默认为0，不建议改
@property(nonatomic, assign) CGFloat fadeEndPercent; // 渐变结束的百分比，例如0.2，则表示 0~20% 是渐变区间

@property(nonatomic, assign) BOOL isFirstDisplay;

@property(nonatomic, strong) CAGradientLayer *fadeLayer;

/// 绘制文本时重复绘制的次数，用于实现首尾连接的滚动效果，1 表示不首尾连接，大于 1 表示首尾连接。
@property(nonatomic, assign) NSInteger textRepeatCount;

/// 记录上一次布局时的 bounds，如果有改变，则需要重置动画
@property(nonatomic, assign) CGRect prevBounds;

@end

@implementation FDMarqueeLabel

#pragma mark - Public Interface

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineBreakMode = NSLineBreakByClipping;
        self.clipsToBounds = YES;// 显示非英文字符时，滚动的时候字符会稍微露出两端，所以这里直接裁剪掉
        [self didInitialize];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    } else {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - Event Response

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
//    if (self.offsetX == 0) {
//        // 当到达最左边的时候
//        displayLink.paused = YES;
//        [self setNeedsDisplay];
//
//        int64_t delay = (self.isFirstDisplay || self.textRepeatCount <= 1) ? self.pauseDurationWhenMoveToEdge : 0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            displayLink.paused = ![self shouldPlayDisplayLink];
//            if (!displayLink.paused) {
//                self.offsetX -= self.speed;
//            }
//        });
//
//        if (delay > 0 && self.textRepeatCount > 1) {
//            self.isFirstDisplay = NO;
//        }
//        return;
//    }
//
//    self.offsetX -= self.speed;
//    [self setNeedsDisplay];
//
//    if (-self.offsetX >= self.textSize.width + (self.textRepeatCountConsiderTextWidth > 1 ? self.spacingBetweenHeadToTail : 0)) {
//        displayLink.paused = YES;
//        int64_t delay = self.textRepeatCount > 1 ? self.pauseDurationWhenMoveToEdge : 0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.offsetX = 0;
//            [self handleDisplayLink:displayLink];
//        });
//    }
}

#pragma mark - Private Methods

- (BOOL)shouldPlayDisplayLink {
    BOOL result = self.window && CGRectGetWidth(self.bounds) > 0 && self.textSize.width > CGRectGetWidth(self.bounds);
    
    // 如果 label.frame 在 window 可视区域之外，也视为不可见，暂停掉 displayLink
    if (result && self.automaticallyValidateVisibleFrame) {
        CGRect rectInWindow = [self.window convertRect:self.frame fromView:self.superview];
        if (!CGRectIntersectsRect(self.window.bounds, rectInWindow)) {
            return NO;
        }
    }
    return result;
}

- (void)didInitialize {
    self.speed = .5;
    self.fadeStartPercent = 0;
    self.fadeEndPercent = .2;
    self.pauseDurationWhenMoveToEdge = 2.5;
    self.spacingBetweenHeadToTail = 40;
    self.automaticallyValidateVisibleFrame = YES;
    self.shouldFadeAtEdge = YES;
    self.textStartAfterFade = NO;
    
    self.isFirstDisplay = YES;
    self.textRepeatCount = 2;
}

#pragma mark - Setter or Getter

@end
