//
//  FDMarqueeView.m
//  funnydate
//
//  Created by hexiang on 2020/2/21.
//  Copyright © 2020 zhenai. All rights reserved.
//

#import "FDMarqueeView.h"
#import <Masonry/Masonry.h>

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
        self.isLessLengthScroll = YES;
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

static NSInteger const kTagForCopyView = 1000;

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
    dispatch_async(dispatch_get_main_queue(), ^{

        if (![self isNeedScroll]) {
            return;
        }
        
        [self stopMarquee];
        
        self.marqueeDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processMarquee)];
        // preferredFramesPerSecond: 每秒钟调用几次
        // frameInterval: 标识间隔多少帧调用一次selector方法
        if (@available(iOS 10, *)) {
            self.marqueeDisplayLink.preferredFramesPerSecond = 60 / self.viewConfig.frameInterval;
        } else {
            self.marqueeDisplayLink.frameInterval = self.viewConfig.frameInterval;
        }
        
        [self.marqueeDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
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

    CGRect frame = self.containerView.frame;
    frame.size.height = self.frame.size.height;
    self.containerView.frame = frame;
    
    BOOL showCopyView = [self isNeedScroll];
    [self log:@"%s, frame = %@, showCopyView = %d", __func__, NSStringFromCGRect(self.frame), showCopyView];
    UIView *copyView = [self viewWithTag:kTagForCopyView];
    copyView.hidden = !showCopyView;
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

- (BOOL)isNeedScroll {
    if (!self.viewConfig.isLessLengthScroll && CGRectGetWidth(self.viewConfig.customView.frame) <= CGRectGetWidth(self.frame) ) {
        return NO;
    }
    return YES;
}

- (void)setupContainerView {
    //
    UIView *customView = self.viewConfig.customView;
    CGSize customSize = CGSizeMake(CGRectGetWidth(customView.frame), CGRectGetHeight(customView.frame));

    if (nil == customView) {
        NSAssert(NO, @"please set config customView property");
        return;
    }

    UIView *copyCustomView = [self copyView:customView];
    copyCustomView.tag = kTagForCopyView;
    
    UIView *superView = self.containerView;
    [superView addSubview:customView];
    [superView addSubview:copyCustomView];
    
    switch (self.viewConfig.yPosition) {
        case FDMarqueeCustomViewYPositionCenter:
        {
            [customView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(superView);
                make.left.equalTo(superView);
                make.size.mas_equalTo(customSize);
            }];
            [copyCustomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(customView);
                make.left.equalTo(customView.mas_right).offset(self.viewConfig.contentMargin);
                make.size.mas_equalTo(customSize);
            }];
            break;
        }
        case FDMarqueeCustomViewYPositionTop:
        {
            [customView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView);
                make.left.equalTo(superView);
                make.size.mas_equalTo(customSize);
            }];
            [copyCustomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(customView);
                make.left.equalTo(customView.mas_right).offset(self.viewConfig.contentMargin);
                make.size.mas_equalTo(customSize);
            }];
            break;
        }
        case FDMarqueeCustomViewYPositionBottom:
        {
            [customView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(superView);
                make.left.equalTo(superView);
                make.size.mas_equalTo(customSize);
            }];
            [copyCustomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(customView);
                make.left.equalTo(customView.mas_right).offset(self.viewConfig.contentMargin);
                make.size.mas_equalTo(customSize);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)setupUI {
    [self setupContainerView];
    
    UIView *customView = self.viewConfig.customView;
    CGSize customSize = CGSizeMake(CGRectGetWidth(customView.frame), CGRectGetHeight(customView.frame));
    
    CGSize allSize = CGSizeMake(customSize.width * 2 + self.viewConfig.contentMargin, CGRectGetHeight(self.frame));
    switch (self.viewConfig.scrollDirection) {
        case FDMarqueeViewScrollDirectionLeft:
        {
            self.containerView.frame = CGRectMake(0, 0, allSize.width, allSize.height);
            break;
        }
        case FDMarqueeViewScrollDirectionRight:
        {
            self.containerView.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.containerView.frame), 0, allSize.width, allSize.height);
            break;
        }
        default:
            break;
    }
    [self addSubview:self.containerView];
}

- (UIView *)copyView:(UIView *)view {
    if (nil == view) {
        return nil;
    }
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    /*
    if (@available(iOS 12, *)) {
        NSError *error = nil;
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view requiringSecureCoding:NO error:&error];
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
     */
}

- (void)log:(NSString *)format, ... {
    
#if 0
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
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.viewConfig.customView.frame) * 2 + self.viewConfig.contentMargin, CGRectGetHeight(self.frame))];
            view;
        });
    }
    return _containerView;
}

@end
