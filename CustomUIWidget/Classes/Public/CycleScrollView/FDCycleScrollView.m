//
//  FDCycleScrollView.m
//  CustomUIWidget
//
//  Created by hexiang on 2022/3/21.
//

#import "FDCycleScrollView.h"

@interface FDCycleScrollView ()<UIScrollViewDelegate>
{
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
// 定时器
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerIndex; // 定时次数计数

// Datas
@property (nonatomic, assign) NSInteger realCount; // 实际的个数
@property (nonatomic, assign) NSInteger showCount;  // 显示的个数(实际显示个数，无限循环时，扩充三倍数量, 前后各加一组相同数据)
@property (nonatomic, assign) CGSize cellSize;   // 当前显示的cell大小

// 无限循环时，需要增加可重用机制
@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) NSMutableArray *reusableCells;
@property (nonatomic, assign) NSRange        visibleRange;

@end

@implementation FDCycleScrollView

#pragma mark - Public Interface

- (void)reloadData {
    // 移除所有cell
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 停止定时器
    [self stopTimer];
    
    // 加载数据
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellsInCycleScrollView:)]) {
        // 实际个数
        self.realCount = [self.dataSource numberOfCellsInCycleScrollView:self];
        
        // 展示个数
        if (self.isInfiniteLoop) {
            self.showCount = self.realCount == 1 ? 1 : self.realCount * 3;
        }else {
            self.showCount = self.realCount;
        }
        
        // 如果总页数为0，return
        if (self.showCount == 0) return;
        
//        if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
//            [self.pageControl setNumberOfPages:self.realCount];
//        }
    }
    
    // 清除原始数据
    [self.visibleCells removeAllObjects];
    [self.reusableCells removeAllObjects];
    self.visibleRange = NSMakeRange(0, 0);
    
    for (NSInteger i = 0; i < self.showCount; i++){
        [self.visibleCells addObject:[NSNull null]];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self refreshSizeCompletion:^{
        [weakSelf initialScrollViewAndCellSize];
    }];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

// 解决当父视图释放时，当前视图因为NSTimer强引用而导致的不能释放
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

- (void)dealloc {
    [self stopTimer];
    self.scrollView.delegate = nil;
}

#pragma mark - Event Response

- (void)timerUpdate {
    self.timerIndex++;
    
    // 解决反向滑动停止后，可能出现的自动滚动错乱问题
    if (self.timerIndex > self.realCount * 2) {
        self.timerIndex = self.realCount * 2;
    }
    
    if (!self.isInfiniteLoop) {
        // 不是无限滚动时，到底了需要清零
        if (self.timerIndex >= self.realCount) {
            self.timerIndex = 0;
        }
    }
    
    switch (self.direction) {
        case FDCycleScrollViewScrollDirectionHorizontal:
        {
            [self.scrollView setContentOffset:CGPointMake(self.cellSize.width * self.timerIndex, 0) animated:YES];
            break;
        }
        case FDCycleScrollViewScrollDirectionVertical:
        {
            [self.scrollView setContentOffset:CGPointMake(0, self.cellSize.height * self.timerIndex) animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark -- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// 结束拖拽时调用，decelerate是否有减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

// 结束减速是调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - Private Methods

- (void)setupUI {
    
}

- (void)setupData {
    self.autoScrollTime = 3.0f;
    self.isInfiniteLoop = YES;
}

- (void)setupCellsWithContentOffset:(CGPoint)offset {
    if (self.showCount == 0) return;
    if (self.cellSize.width <= 0 || self.cellSize.height <= 0) return;
    //计算_visibleRange
    CGFloat originX = self.scrollView.frame.origin.x == 0 ? 0.01 : self.scrollView.frame.origin.x;
    CGFloat originY = self.scrollView.frame.origin.y == 0 ? 0.01 : self.scrollView.frame.origin.y;
    
    CGPoint startPoint = CGPointMake(offset.x - originX, offset.y - originY);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    switch (self.direction) {
        case FDCycleScrollViewScrollDirectionHorizontal:
        {
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < self.visibleCells.count; i++) {
                if (self.cellSize.width * (i + 1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < self.visibleCells.count; i++) {
                //如果都不超过则取最后一个
                if ((self.cellSize.width * (i + 1) < endPoint.x && self.cellSize.width * (i + 2) >= endPoint.x) || i + 2 == self.visibleCells.count) {
                    endIndex = i + 1;
                    break;
                }
            }
            
            // 可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex, 0);
            endIndex = MIN(endIndex, self.visibleCells.count - 1);
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self addCellAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < self.visibleCells.count; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        case FDCycleScrollViewScrollDirectionVertical:
        {
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < self.visibleCells.count; i++) {
                if (self.cellSize.height * (i +1) > startPoint.y) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < self.visibleCells.count; i++) {
                //如果都不超过则取最后一个
                if ((self.cellSize.height * (i + 1) < endPoint.y && self.cellSize.height * (i + 2) >= endPoint.y) || i+ 2 == self.visibleCells.count) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
            
            //可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, self.visibleCells.count - 1);
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self addCellAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < self.visibleCells.count; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        default:
            break;
    }
}

- (void)initialScrollViewAndCellSize {
    //self.originSize = self.bounds.size;
    [self updateScrollViewAndCellSize];
    
    // 默认选中
    if (self.defaultSelectIndex >= 0 && self.defaultSelectIndex < self.realCount) {
        //[self handleCellScrollWithIndex:self.defaultSelectIndex];
    }
}

- (void)refreshSizeCompletion:(void(^)(void))completion {
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        [self layoutIfNeeded];
        
        // 切换一次，在下个RunLoop循环中就能获取到自动布局后的frame结果
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? : completion();
        });
    }else {
        !completion ? : completion();
    }
}

- (void)updateScrollViewAndCellSize {
    if (self.bounds.size.width <= 0 || self.bounds.size.height <= 0) return;
    
    // 设置cell尺寸
    self.cellSize = CGSizeMake(self.bounds.size.width - 2 * self.leftRightMargin, self.bounds.size.height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForCellInCycleScrollView:)]) {
        self.cellSize = [self.delegate sizeForCellInCycleScrollView:self];
    }
    
    // 设置scrollView大小
    switch (self.direction) {
        case FDCycleScrollViewScrollDirectionHorizontal:
        {
            self.scrollView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
            self.scrollView.contentSize = CGSizeMake(self.cellSize.width * self.showCount,0);
            self.scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            
            if (self.realCount > 1) {
                CGPoint offset = CGPointZero;
                
                if (self.isInfiniteLoop) { // 开启无限轮播
                    // 滚动到第二组(这样滚动更平滑)
                    offset = CGPointMake(self.cellSize.width * (self.realCount + self.defaultSelectIndex), 0);
                    self.timerIndex = self.realCount + self.defaultSelectIndex;
                } else {
                    offset = CGPointMake(self.cellSize.width * self.defaultSelectIndex, 0);
                    self.timerIndex = self.defaultSelectIndex;
                }
                
                [self.scrollView setContentOffset:offset animated:NO];
                
                // 自动轮播
                if (self.isAutoScroll) {
                    [self startTimer];
                }
            }
            break;
        }
        case FDCycleScrollViewScrollDirectionVertical:
        {
            self.scrollView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
            self.scrollView.contentSize = CGSizeMake(0, self.cellSize.height * self.showCount);
            self.scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
            
            if (self.realCount > 1) {
                CGPoint offset = CGPointZero;
                if (self.isInfiniteLoop) { // 开启无限轮播
                    // 滚动到第二组
                    offset = CGPointMake(0, self.cellSize.height * (self.realCount + self.defaultSelectIndex));
                    self.timerIndex = self.realCount + self.defaultSelectIndex;
                }else {
                    offset = CGPointMake(0, self.cellSize.height * self.defaultSelectIndex);
                    self.timerIndex = self.defaultSelectIndex;
                }
                
                [self.scrollView setContentOffset:offset animated:NO];
                
                // 自动轮播
                if (self.isAutoScroll) {
                    [self startTimer];
                }
            }
            break;
        }
        default:
            break;
    }
    
    // 根据当前scrollView的offset设置显示的cell
    [self setupCellsWithContentOffset:self.scrollView.contentOffset];
    
    // 更新可见cell的显示
    //[self updateVisibleCellAppearance];
}

- (void)addCellAtIndex:(NSInteger)index {
    NSParameterAssert(index >= 0 && index < self.visibleCells.count);
//
//    FDCycleScrollViewCell *cell = self.visibleCells[index];
//    if ((NSObject *)cell == [NSNull null]) {
//        cell = [self.dataSource cycleScrollView:self cellForViewAtIndex:index % self.realCount];
//        if (cell) {
//            [self.visibleCells replaceObjectAtIndex:index withObject:cell];
//
//            cell.tag = index % self.realCount;
//            [cell setupCellFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
//            if (!self.isChangeAlpha) cell.coverView.hidden = YES;
//
//            __weak __typeof(self) weakSelf = self;
//            cell.didCellClick = ^(NSInteger index) {
//                [weakSelf handleCellSelectWithIndex:index];
//            };
//
//            switch (self.direction) {
//                case GKCycleScrollViewScrollDirectionHorizontal:
//                    cell.frame = CGRectMake(self.cellSize.width * index, 0, self.cellSize.width, self.cellSize.height);
//                    break;
//                case GKCycleScrollViewScrollDirectionVertical:
//                    cell.frame = CGRectMake(0, self.cellSize.height * index, self.cellSize.width, self.cellSize.height);
//                    break;
//                default:
//                    break;
//            }
//
//            if (!cell.superview) {
//                [self.scrollView addSubview:cell];
//            }
//        }
//    }
}

- (void)removeCellAtIndex:(NSInteger)index{
//    GKCycleScrollViewCell *cell = [self.visibleCells objectAtIndex:index];
//    if ((NSObject *)cell == [NSNull null]) return;
//
//    [self.reusableCells addObject:cell];
//
//    if (cell.superview) {
//        [cell removeFromSuperview];
//    }
//
//    [self.visibleCells replaceObjectAtIndex:index withObject:[NSNull null]];
}

#pragma mark -- Timers

- (void)startTimer {
    if (self.realCount > 1 && self.isAutoScroll) {
        [self stopTimer];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTime target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -- Datas

#pragma mark - Setter or Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.bounds];
            view.scrollsToTop = NO;
            view.delegate = self;
            view.pagingEnabled = YES;
            view.clipsToBounds = NO;
            view.showsHorizontalScrollIndicator = NO;
            view.showsVerticalScrollIndicator = NO;
            view;
        });
    }
    return _scrollView;
}

- (NSMutableArray *)visibleCells {
    if (!_visibleCells) {
        _visibleCells = ({
            NSMutableArray *arr = [NSMutableArray array];
            arr;
        });
    }
    return _visibleCells;
}

- (NSMutableArray *)reusableCells {
    if (!_reusableCells) {
        _reusableCells = ({
            NSMutableArray *arr = [NSMutableArray array];
            arr;
        });
    }
    return _reusableCells;
}

@end
