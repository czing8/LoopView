//
//  VCyclePicPlayer.m
//  VCyclePicPlayer
//
//  Created by Vols on 15/3/18.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "VCyclePicPlayer.h"

@interface VCyclePicPlayer (){
    NSTimer *_timer;
}

#define kTimerInterval  6

@end

@implementation VCyclePicPlayer

//用代码创建VCyclePicPlayer时，调用init(初始化),但是SB不走init函数。
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialization];
    }
    return self;
}

/*
//Storyborad 直接调用VCyclePicPlayer会从这个函数开始（初始化）eg,在4.7寸里获取的是320，而不是375，so initWithCoder获取的是自动适配前的元素。
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}
*/

//Storyborad 直接调用VCyclePicPlayer会从这个函数开始（初始化）
- (void)layoutSubviews{
    [self initialization];
}

- (void) initialization{
    _curPage = 0;
    _isAutoPlay = YES;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    
    
//    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    _pageControl = [[TAPageControl alloc] initWithFrame:rect];
    _pageControl.dotColor = self.dotColor;

    /* 系统的pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:rect];
    _pageControl.userInteractionEnabled = NO;
     */
    
    [self addSubview:_pageControl];
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    
    NSLog(@"%f", pageControlDotSize.width);
    
    _pageControlDotSize = pageControlDotSize;
//    _pageControl.dotSize = pageControlDotSize;
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    _pageControl.dotColor = dotColor;
}

- (void)setDelegate:(id<VCyclePicPlayerDelegate>)delegate{
    _delegate = delegate;
    
    [self reloadData];
    [self autoPlayPic];
}

- (void)reloadData{
    _totalPages = [_delegate numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData {
    _pageControl.currentPage = _curPage;
    
    NSLog(@"_curPage:%ld", (long)_curPage);
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
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
    
    NSInteger pre = [self validPageValue:_curPage-1];
    NSInteger last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_delegate pageAtIndex:pre]];
    [_curViews addObject:[_delegate pageAtIndex:page]];
    [_curViews addObject:[_delegate pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    
    if(value == _totalPages) value = 0;
    
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(cyclePicPlayer:atIndex:)]) {
        [_delegate cyclePicPlayer:self atIndex:_curPage];
    }
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
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

- (void)autoPlayPic{
    [_timer invalidate];
    _timer = nil;

    if (_isAutoPlay) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(playPic:) userInfo:nil repeats:YES];
    }
}

- (void)playPic:(id)sender{
    
    if (_totalPages == 0)  return;

    [self loadData];

    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self autoPlayPic];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}


//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
