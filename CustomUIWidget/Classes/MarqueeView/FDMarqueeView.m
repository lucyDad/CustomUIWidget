//
//  FDMarqueeView.m
//  funnydate
//
//  Created by hexiang on 2020/2/21.
//  Copyright © 2020 zhenai. All rights reserved.
//

#import "FDMarqueeView.h"

@implementation FDMarqueeViewConfig

+ (instancetype)configByMiddlePauseTime:(NSTimeInterval)time {
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig configByMiddlePauseTime:time moveSpeed:0.5];
    return config;
}

+ (instancetype)configByMoveSpeed:(CGFloat)moveSpeed {
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig configByMiddlePauseTime:1 moveSpeed:0.5];
    return config;
}

+ (instancetype)configByMiddlePauseTime:(NSTimeInterval)time moveSpeed:(CGFloat)moveSpeed {
    FDMarqueeViewConfig *config = [FDMarqueeViewConfig new];
    config.pointsPerFrame = moveSpeed;
    config.contentMargin = [config contentMarginByTime:time];
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frameInterval = 1;
        self.contentMargin = 30;
        self.pointsPerFrame = 0.5;
        
        self.maxTimeLimit = MAXFLOAT;
    }
    return self;
}

- (CGFloat)contentMarginByTime:(NSTimeInterval)time {
    CGFloat contentMargin = time * (self.frameInterval * 60 * self.pointsPerFrame);
    return contentMargin;
}

- (CGFloat)timeBycontentMargin:(CGFloat)contentMargin {
    CGFloat time = (self.frameInterval * 60 * self.pointsPerFrame) / contentMargin;
    return time;
}

@end

@interface FDMarqueeView ()
{
    
}

@property (nonatomic, strong) FDMarqueeViewConfig *viewConfig;  // 配置对象
@property (nonatomic, strong) CADisplayLink *marqueeDisplayLink;    // 屏幕刷新器
@property (nonatomic, strong) UIView *containerView;    // 内容显示view

@property (nonatomic, assign) CGFloat  intervalTime;    // 刷新间隔时间（由配置参数frameInterval决定）
@property (nonatomic, assign) CGFloat  allTime;         // 滚动的总时长

@property (nonatomic, assign) BOOL  isScrollPause;            // 是否暂停滚动
@property (nonatomic, assign) CGFloat  allPauseTime;         // 暂停的总时长

@end

@implementation FDMarqueeView

#pragma mark - Public Interface

- (void)reloadData {
    while (self.containerView.subviews.count) {
        [self.containerView.subviews.lastObject removeFromSuperview];
    }
    [self setupUI];
}

- (void)startMarquee {
    [self stopMarquee];
    
    self.marqueeDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processMarquee)];
    if (@available(iOS 10, *)) {
        self.marqueeDisplayLink.preferredFramesPerSecond = self.viewConfig.frameInterval;
    } else {
        self.marqueeDisplayLink.frameInterval = self.viewConfig.frameInterval;
    }
    [self.marqueeDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMarquee {
    [self.marqueeDisplayLink invalidate];
    self.marqueeDisplayLink = nil;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andConfig:(FDMarqueeViewConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewConfig = config;
        self.clipsToBounds = YES;
        self.intervalTime = self.viewConfig.frameInterval / 60.0f;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"please user initWithFrame:andConfig:");
    return [self initWithFrame:frame andConfig:[FDMarqueeViewConfig new]];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (nil == newSuperview) {
        [self stopMarquee];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    [self log:@"%s", __func__];
}

#pragma mark - Event Response

- (void)processMarquee {
    
    self.allTime += self.intervalTime;
    if ( self.allTime >= self.viewConfig.maxTimeLimit) {
        [self stopMarquee];
        
        __weak typeof(self)weakSelf = self;
        if (self.scrollCompleteBlock) {
            self.scrollCompleteBlock(weakSelf);
        }
        return;
    }
    
    if (self.viewConfig.scrollPauseTime > 0.0f && self.isScrollPause) {
        self.allPauseTime += self.intervalTime;
        if (self.allPauseTime >= self.viewConfig.scrollPauseTime) {
            self.isScrollPause = NO;
            self.allPauseTime = 0.0f;
        }
        return;
    }
    
    switch (self.viewConfig.scrollDirection) {
        case FDMarqueeViewScrollDirectionLeft:
        {
            CGFloat targetX = -(self.viewConfig.customView.bounds.size.width + self.viewConfig.contentMargin);
            CGRect frame = self.containerView.frame;
            if (frame.origin.x <= targetX) {
                frame.origin.x = 0;
                self.containerView.frame = frame;
                [self log:@"往左滚动到底了。。。"];
                self.isScrollPause = YES;
            } else {
                frame.origin.x -= self.viewConfig.pointsPerFrame;
                if (frame.origin.x < targetX) {
                    frame.origin.x = targetX;
                    [self log:@"滚动到底了2。。。"];
                }
                self.containerView.frame = frame;
            }
            break;
        }
        case FDMarqueeViewScrollDirectionRight:
        {
            CGFloat targetX = self.bounds.size.width - self.viewConfig.customView.bounds.size.width;
            CGRect frame = self.containerView.frame;
            if (frame.origin.x >= targetX) {
                frame.origin.x = self.bounds.size.width - self.containerView.bounds.size.width;
                self.containerView.frame = frame;
                [self log:@"往右滚动到底了。。。"];
                self.isScrollPause = YES;
            } else {
                frame.origin.x += self.viewConfig.pointsPerFrame;
                if (frame.origin.x > targetX) {
                    frame.origin.x = targetX;
                }
                self.containerView.frame = frame;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)setupUI {
    
    switch (self.viewConfig.scrollDirection) {
        case FDMarqueeViewScrollDirectionLeft:
        {
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
            break;
        }
        case FDMarqueeViewScrollDirectionRight:
        {
            self.containerView.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.containerView.frame), 0, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
            break;
        }
        default:
            break;
    }
    [self addSubview:self.containerView];
    
    UIView *customView = self.viewConfig.customView;
    if (nil == customView) {
        NSAssert(NO, @"please set config customView property");
        return;
    }
    if (CGRectGetWidth(customView.frame) < CGRectGetWidth(self.frame)) {
        [self log:@"提供的自定义view的宽度比容器view窄"];
        customView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(customView.frame));
    }
    customView.frame = CGRectMake(0, 0, CGRectGetWidth(customView.frame), CGRectGetHeight(customView.frame));
    UIView *copyCustomView = [self copyView:customView];
    copyCustomView.frame = CGRectMake(CGRectGetWidth(customView.frame) + self.viewConfig.contentMargin, 0, CGRectGetWidth(customView.frame), CGRectGetHeight(customView.frame));
    
    [self.containerView addSubview:customView];
    [self.containerView addSubview:copyCustomView];
}

- (UIView *)copyView:(UIView *)view {
    if (nil == view) {
        return nil;
    }
    if (@available(iOS 12, *)) {
        NSError *error = nil;
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view requiringSecureCoding:YES error:&error];
        if (error) {
            [self log:@"view序列化失败 error = %@", error];
            return nil;
        }
        UIView *view = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIView class] fromData:tempArchive error:&error];
        if (error) {
            [self log:@"view反序列化失败 error = %@", error];
            return nil;
        }
        return view;
    } else {
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
        return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    }
}

- (void)log:(NSString *)format, ... {
    
#if 1
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSLog(@"FDMarqueeView>>>%@", msg);
#endif
}

#pragma mark - Setter or Getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.viewConfig.customView.frame) * 2 + self.viewConfig.contentMargin, CGRectGetHeight(self.frame))];;
            view;
        });
    }
    return _containerView;
}

@end
