//
//  VCyclePicPlayer.m
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/18.
//  Copyright © 2015年 vols. All rights reserved.
//

#import "VCyclePicPlayer.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, VPlayerSourceType) {
    PlayerSourceTypeFromLocal,
    PlayerSourceTypeFromNet
};

#define kTimeInterval       3.f

@interface VCyclePicPlayer () <UIScrollViewDelegate, CAAnimationDelegate>

@property (nonatomic, assign) VPlayerSourceType     sourceType;
@property (nonatomic, assign) NSUInteger        curPage;
@property (nonatomic, assign) NSUInteger        totalPages;
@property (nonatomic, strong) NSMutableArray    * curImages;

@property (nonatomic, strong) NSTimer       * timer;
@property (nonatomic, strong) UIScrollView  * scrollView;
@property (nonatomic, strong) UIImageView   * lastImgView;
@property (nonatomic, strong) UIImageView   * curImgView;
@property (nonatomic, strong) UIImageView   * nextImgView;

@end

@implementation VCyclePicPlayer

+ (instancetype)playerWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray {
    return [VCyclePicPlayer playerWithFrame:frame
                                sourceArray:sourceArray
                               timeInterval:kTimeInterval
                             transitionType:PlayerTransitionTypeNormal];
}

+ (instancetype)playerWithFrame:(CGRect)frame
                    sourceArray:(NSArray *)sourceArray
                   timeInterval:(CGFloat)interval
                 transitionType:(VPlayerTransitionType)transitionType {
    
    VCyclePicPlayer *player = [[VCyclePicPlayer alloc] initWithFrame:frame];
    player.transitionType  = transitionType;
    player.timeInterval    = interval;
    player.sourceArray     = sourceArray;       //更新赋值数据源，放在最后属性赋初值
    return player;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.timeInterval   = kTimeInterval;                //默认为2
        self.sourceType     = PlayerSourceTypeFromNet;      //默认为网络
        self.transitionType = PlayerTransitionTypeNormal;   //默认为正常切换
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.lastImgView];
        [self.scrollView addSubview:self.curImgView];
        [self.scrollView addSubview:self.nextImgView];
    }
    return self;
}

- (void)startTimer {
    
    if (self.timer == nil) {
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]
                                             interval:self.timeInterval
                                               target:self
                                             selector:@selector(timerPlayPic:)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (self.timer == nil)  return;
    
    [self.timer invalidate];
    self.timer = nil;
}


// 数据源的setter方法，每次数据源变化时调用, 初始化参数
- (void)setSourceArray:(NSArray *)sourceArray {
    
    if (sourceArray.count <= 0) return;
    
    if ([[sourceArray firstObject] rangeOfString:@"http"].location == NSNotFound) {
        self.sourceType = PlayerSourceTypeFromLocal;
    }
    
    _sourceArray = sourceArray;
    _totalPages  = sourceArray.count;
    _curPage     = 0;
    
    [self refreshImage];
    [self initPageView:_totalPages];
    [self startTimer];
}

// 刷新显示Image，每次切换时调用
- (void)refreshImage {
    
    [self getDisplayImagesWithCurPage:_curPage];
    if (_sourceType == PlayerSourceTypeFromLocal) {
        _lastImgView.image = [UIImage imageNamed:_curImages[0]];
        _curImgView.image  = [UIImage imageNamed:_curImages[1]];
        _nextImgView.image = [UIImage imageNamed:_curImages[2]];
    }
    else if (_sourceType == PlayerSourceTypeFromNet){
        [_lastImgView sd_setImageWithURL:[NSURL URLWithString:_curImages[0]]];
        [_curImgView  sd_setImageWithURL:[NSURL URLWithString:_curImages[1]]];
        [_nextImgView sd_setImageWithURL:[NSURL URLWithString:_curImages[2]]];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];    
}

- (void)getDisplayImagesWithCurPage:(NSInteger)curPage {
    
    NSInteger pre = [self validPageValue:curPage - 1];
    NSInteger last = [self validPageValue:curPage + 1];
    
    [self.curImages removeAllObjects];
    [self.curImages addObject:self.sourceArray[pre]];
    [self.curImages addObject:self.sourceArray[curPage]];
    [self.curImages addObject:self.sourceArray[last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
}


#pragma mark - Actions

-(void)tapAction:(id)sender{
    if (self.clickHandler) {
        self.clickHandler(_curPage);
    }
}

- (void)timerPlayPic:(id)sender {
    
    if (_transitionType == PlayerTransitionTypeNormal) {
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
    }
    else if (_transitionType == PlayerTransitionTypeRippleEffect) {
        [self addAnimationView:self.curImgView type:@"rippleEffect" subType:kCATransitionFromLeft duration:0.5];
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:NO];
    }
}


#pragma mark - Properities

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (NSMutableArray *)curImages{
    if (_curImages  == nil) {
        _curImages = [[NSMutableArray alloc] init];
    }
    return _curImages;
}


- (UIImageView *)lastImgView {
    if (_lastImgView == nil) {
        _lastImgView = [self buildImageViewFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    return _lastImgView;
}

- (UIImageView *)curImgView {
    if (_curImgView == nil) {
        _curImgView  = [self buildImageViewFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    return _curImgView;
}


- (UIImageView *)nextImgView {
    if (_nextImgView == nil) {
        _nextImgView = [self buildImageViewFrame:CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    return _nextImgView;
}


#pragma mark - UIScrollView Delegate
// 触摸后停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

// 触摸停止后再次启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage + 1];
        [self refreshImage];
        [self startAnimationSubType:kCATransitionFromLeft];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage - 1];
        [self refreshImage];
        [self startAnimationSubType:kCATransitionFromRight];
    }
}

#pragma mark - Animation
// 页码翻页动画
- (void)startAnimationSubType:(NSString *)subType {
    
    UILabel *label = (UILabel *)[self viewWithTag:9909];
    CATransition *animation = [CATransition animation];
    animation.delegate  = self;
    animation.duration  = 0.5f;
    animation.type      = @"oglFlip";
    animation.subtype   = subType;
    animation.fillMode  = kCAFillModeRemoved;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [label.layer addAnimation:animation forKey:nil];
}

// 动画开始时的回调
-(void)animationDidStart:(CAAnimation *)animation {
    UILabel *pageLabel  = (UILabel *)[self viewWithTag:9909];
    pageLabel.text      = [NSString stringWithFormat:@"%lu",self.curPage + 1];
}


- (void)removeAnimationView:(UIView *)view{
    [view.layer removeAnimationForKey:@"layerAnimation"];
}


#pragma mark - helper

- (UIImageView *) buildImageViewFrame:(CGRect)frame{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

// 动画
- (void)addAnimationView:(UIView *)view type:(NSString *)type subType:(NSString *)subType duration:(CGFloat)duration{
    
    CATransition *transition = [CATransition animation];
    transition.subtype  = subType;
    transition.type     = type;
    transition.duration = duration;
    [view.layer addAnimation:transition forKey:@"layerAnimation"];
}


// 自动布局创建自定义的PageView, 也可替换成frame或者masonry方式。
- (void)initPageView:(NSUInteger)totalPageNumber {
    
    UIImageView *pageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pageView"]];
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    pageView.backgroundColor = [UIColor clearColor];
    
    UILabel *pageNumberLabel = [[UILabel alloc]init];
    pageNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    pageNumberLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    pageNumberLabel.text = @"1";
    pageNumberLabel.textColor = [UIColor colorWithRed:88.f / 255.f green:157.f / 255.f blue:62.f / 255.f alpha:1.f];
    pageNumberLabel.textAlignment = NSTextAlignmentCenter;
    pageNumberLabel.font = [UIFont boldSystemFontOfSize:12.f / 375 * [UIScreen mainScreen].bounds.size.width];
    pageNumberLabel.tag = 9909;
    pageNumberLabel.layer.cornerRadius = 33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.5 / 2.f;
    pageNumberLabel.layer.borderWidth = 0.5f;
    pageNumberLabel.layer.borderColor = [UIColor colorWithRed:109.f / 255.f green:109.f / 255.f blue:109.f / 255.f alpha:1.f].CGColor;
    pageNumberLabel.layer.masksToBounds = YES;

    
    UILabel *totalPage = [UILabel new];
    totalPage.translatesAutoresizingMaskIntoConstraints = NO;
    totalPage.textAlignment = NSTextAlignmentCenter;
    totalPage.font = [UIFont boldSystemFontOfSize:12.f / 375 * [UIScreen mainScreen].bounds.size.width];
    totalPage.textColor = [UIColor whiteColor];
    totalPage.text = [NSString stringWithFormat:@"of %ld",totalPageNumber];
    totalPage.backgroundColor = [UIColor clearColor];
    
    [self addSubview:pageView];
    [self addSubview:pageNumberLabel];
    [self addSubview:totalPage];
    
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(90.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55);
        make.height.mas_equalTo(33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55);
    }];
    
    [pageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pageView.mas_left).offset(4);
        make.centerY.equalTo(pageView.mas_centerY);
        make.width.mas_equalTo(33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55);
        make.height.mas_equalTo(33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55);
    }];

    
    [totalPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(pageView.mas_right);
        make.centerY.equalTo(pageView.mas_centerY);
        make.width.mas_equalTo(85.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55);
        make.height.mas_equalTo(33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55);
    }];
}


// 解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
