//
//  VCyclePicPlayer.m
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/18.
//  Copyright © 2016年 vols. All rights reserved.
//

#import "VCyclePicPlayer.h"
#import "UIImageView+WebCache.h"

@interface VCyclePicPlayer () <UIScrollViewDelegate, CAAnimationDelegate>

@property (nonatomic, assign) NSUInteger    curPage;
@property (nonatomic, assign) NSUInteger    totalPages;

@property (nonatomic, strong) NSMutableArray    * curImages;

@property (nonatomic, strong) UIScrollView  * scrollView;
@property (nonatomic, strong) UIImageView   * lastImgView;
@property (nonatomic, strong) UIImageView   * curImgView;
@property (nonatomic, strong) UIImageView   * nextImgView;
@property (nonatomic, strong) NSTimer       * timer;

@end

@implementation VCyclePicPlayer

+ (instancetype)playerWithFrame:(CGRect)frame
          sourceArray:(NSArray *)sourceArray
               target:(id)target
         timeInterval:(CGFloat)interval
            imageType:(VPlayerImageType)imageType{
    
    VCyclePicPlayer *new = [[VCyclePicPlayer alloc] initWithFrame:frame];
    new.imageType   = imageType;
    new.timeInterval = interval;
    new.sourceArray = sourceArray;

    if ([target isKindOfClass:[UIView class]]) {
        [target addSubview:new];
    }else if ([target isKindOfClass:[UIViewController class]]){
        UIViewController *vc = target;
        [vc.view addSubview:new];
    }
    
    return new;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.timeInterval   = 2.f;                  //默认为2
        self.imageType      = ImageTypeFromNet;     //默认为网络

        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.lastImgView];
        [self.scrollView addSubview:self.curImgView];
        [self.scrollView addSubview:self.nextImgView];
    }
    return self;
}

/** 每次数据源变化时调用, 初始化参数 */
- (void)setSourceArray:(NSArray *)sourceArray {
    _sourceArray = sourceArray;
    _totalPages  = sourceArray.count;
    _curPage     = 0;
    
    [self refreshImage];
    [self initTimer];
    [self initPageView:_totalPages];
}

/** 刷新显示Image，每次切换时调用 */
- (void)refreshImage {
    [self getDisplayImagesWithCurPage:_curPage];
    
    if (_imageType == ImageTypeFromLocal) {
        _lastImgView.image = [UIImage imageNamed:_curImages[0]];
        _curImgView.image  = [UIImage imageNamed:_curImages[1]];
        _nextImgView.image = [UIImage imageNamed:_curImages[2]];
    }
    else if (_imageType == ImageTypeFromNet){
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


//初始化一个定时器
-(void)initTimer{
    
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


#pragma mark - Actions

-(void)tapAction:(id)sender{
    if (self.tapAction) {
        self.tapAction(_curPage);
    }
}

- (void)timerPlayPic:(id)sender {
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
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


//自动布局创建自定义的PageView
-(void)initPageView:(NSUInteger)totalPageNumber{
    
    UIImageView *pageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pageView"]];
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    pageView.backgroundColor = [UIColor clearColor];
    [self addSubview:pageView];
    
    NSLayoutConstraint *constraintButtom = [NSLayoutConstraint constraintWithItem:pageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.f
                                                                         constant:-5.f];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:pageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.f
                                                                        constant:-15.f];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:pageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:90.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:pageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.f
                                                                         constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constraintButtom,constraintRight,constraintWidth,constraintHeight]];
    
    UILabel *pageNumberLabel = [[UILabel alloc]init];
    pageNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    pageNumberLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    pageNumberLabel.text = @"1";
    pageNumberLabel.textColor = [UIColor colorWithRed:88.f / 255.f green:157.f / 255.f blue:62.f / 255.f alpha:1.f];
    pageNumberLabel.textAlignment = NSTextAlignmentCenter;
    pageNumberLabel.font = [UIFont boldSystemFontOfSize:12.f / 375 * [UIScreen mainScreen].bounds.size.width];
    pageNumberLabel.tag = 9909;
    [self addSubview:pageNumberLabel];
    pageNumberLabel.layer.cornerRadius = 33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.5 / 2.f;
    pageNumberLabel.layer.borderWidth = 0.5f;
    pageNumberLabel.layer.borderColor = [UIColor colorWithRed:109.f / 255.f green:109.f / 255.f blue:109.f / 255.f alpha:1.f].CGColor;
    pageNumberLabel.layer.masksToBounds = YES;
    
    NSLayoutConstraint *constraintPageRight = [NSLayoutConstraint constraintWithItem:pageNumberLabel
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:pageView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.f
                                                                            constant:4.f];
    
    NSLayoutConstraint *constraintPageCenter = [NSLayoutConstraint constraintWithItem:pageNumberLabel
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:pageView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1.f
                                                                             constant:0.f];
    
    NSLayoutConstraint *constraintPageWidth = [NSLayoutConstraint constraintWithItem:pageNumberLabel
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.f
                                                                            constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    NSLayoutConstraint *constraintPageHeight = [NSLayoutConstraint constraintWithItem:pageNumberLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1.f
                                                                             constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constraintPageCenter,constraintPageRight,constraintPageWidth,constraintPageHeight]];
    
    UILabel *totalPage = [UILabel new];
    totalPage.translatesAutoresizingMaskIntoConstraints = NO;
    totalPage.textAlignment = NSTextAlignmentCenter;
    totalPage.font = [UIFont boldSystemFontOfSize:12.f / 375 * [UIScreen mainScreen].bounds.size.width];
    totalPage.textColor = [UIColor whiteColor];
    totalPage.text = [NSString stringWithFormat:@"of %ld",totalPageNumber];
    totalPage.backgroundColor = [UIColor clearColor];
    [self addSubview:totalPage];
    
    NSLayoutConstraint *constrainttotalPageRight = [NSLayoutConstraint constraintWithItem:totalPage
                                                                                attribute:NSLayoutAttributeRight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:pageView
                                                                                attribute:NSLayoutAttributeRight
                                                                               multiplier:1.f
                                                                                 constant:0.f];
    
    NSLayoutConstraint *constrainttotalPageCenter = [NSLayoutConstraint constraintWithItem:totalPage
                                                                                 attribute:NSLayoutAttributeCenterY
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:pageView
                                                                                 attribute:NSLayoutAttributeCenterY
                                                                                multiplier:1.f
                                                                                  constant:0.f];
    
    NSLayoutConstraint *constrainttotalPageWidth = [NSLayoutConstraint constraintWithItem:totalPage
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.f
                                                                                 constant:85.f / 375 * [UIScreen mainScreen].bounds.size.width * 0.55];
    
    NSLayoutConstraint *constrainttotalPageHeight = [NSLayoutConstraint constraintWithItem:totalPage
                                                                                 attribute:NSLayoutAttributeHeight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:nil
                                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                                multiplier:1.f
                                                                                  constant:33.f / 667 * [UIScreen mainScreen].bounds.size.height * 0.55];
    
    [self addConstraints:@[constrainttotalPageRight,constrainttotalPageCenter,constrainttotalPageWidth,constrainttotalPageHeight]];
}


#pragma mark - UIScrollView Delegate

//触摸后停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//触摸停止后再次启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self initTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage + 1];
        [self refreshImage];
        [self startAnimation:0];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage - 1];
        [self refreshImage];
        [self startAnimation:1];
    }
}

//页码翻页动画
- (void)startAnimation:(NSUInteger)direct{
    UILabel *label = (UILabel *)[self viewWithTag:9909];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    [animation setDuration:0.5f];
    [animation setType:@"oglFlip"];
    if (direct == 0) {
        [animation setSubtype:kCATransitionFromLeft];
    }else{
        [animation setSubtype:kCATransitionFromRight];
    }
    [animation setFillMode:kCAFillModeRemoved];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [label.layer addAnimation:animation forKey:nil];
}

//动画开始时的回调
-(void)animationDidStart:(CAAnimation *)anim{
    UILabel *index = (UILabel *)[self viewWithTag:9909];
    index.text = [NSString stringWithFormat:@"%lu",self.curPage + 1];
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

@end
