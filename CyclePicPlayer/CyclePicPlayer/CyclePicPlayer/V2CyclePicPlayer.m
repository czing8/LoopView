//
//  VCyclePicPlayer.m
//  VCyclePicPlayer
//
//  Created by Vols on 15/3/18.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "V2CyclePicPlayer.h"

#define kTimerInterval  2

@interface V2CyclePicPlayer () <UIScrollViewDelegate> {
    NSInteger       _totalPages;
    NSInteger       _curPage;
    
    NSMutableArray  * _curViews;
    UIScrollView    * _scrollView;
    UIPageControl   * _pageControl;
    NSTimer         *_timer;
}

@property (nonatomic, readonly) UIScrollView    * scrollView;
@property (nonatomic, readonly) UIPageControl   * pageControl;

@end

@implementation V2CyclePicPlayer

//代码方式初始化 init
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _isAutoPlay     = YES;                  //默认自动播放
        _timeInterval   = kTimerInterval;       //默认间隔时间
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}


//Storyborad 方式初始化 eg,在4.7寸里获取的是320，而不是375，so initWithCoder获取的是自动适配前的元素。
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isAutoPlay     = YES;                  //默认自动播放
        _timeInterval   = kTimerInterval;       //默认间隔时间
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}


- (void)layoutSubviews {

}



#pragma mark - public

/** 切换数据源后需要初始化一次 */
- (void)reloadData{
    _totalPages = [_delegate numberOfPages];
    if (_totalPages == 0)   return;
    if (_isAutoPlay)        [self startPlay];
    
    _curPage = 0;
    _pageControl.numberOfPages = _totalPages;
    [self refreshImage];
}

//初始化一个定时器
-(void)startPlay{
    if (_timer == nil) {
        _timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]
                                         interval:self.timeInterval
                                           target:self
                                         selector:@selector(playPic:)
                                         userInfo:nil
                                          repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}


- (void)stopPlay {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - setter/getter

- (void)setDelegate:(id<VCyclePicPlayerDelegate>)delegate{
    _delegate = delegate;
    
    [self reloadData];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}



#pragma mark - refreshImage

- (void)refreshImage {
    _pageControl.currentPage = _curPage;
    
    [self getDisplayImagesWithCurpage:_curPage];
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_curPage - 1];
    NSInteger last = [self validPageValue:_curPage + 1];
    
    if (!_curViews) _curViews = [[NSMutableArray alloc] init];
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_delegate cyclePicPlayer:self pageAtIndex:pre]];
    [_curViews addObject:[_delegate cyclePicPlayer:self pageAtIndex:page]];
    [_curViews addObject:[_delegate cyclePicPlayer:self pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1)             value = _totalPages - 1;
    if(value == _totalPages)    value = 0;
    
    return value;
}


- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index {
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                        action:@selector(handleTap:)];
            
            [v addGestureRecognizer:singleTap];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}


#pragma mark - Actions

- (void)playPic:(id)sender {
    
    if (_totalPages == 0)  return;
    [self refreshImage];

    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(cyclePicPlayer:atIndex:)]) {
        [_delegate cyclePicPlayer:self atIndex:_curPage];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopPlay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isAutoPlay)  [self startPlay];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage + 1];
        [self refreshImage];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage -  1];
        [self refreshImage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}


//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopPlay];
    }
}

@end
