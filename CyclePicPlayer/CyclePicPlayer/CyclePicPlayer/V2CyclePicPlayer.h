//
//  V2CyclePicPlayer.h
//  VCyclePicPlayer
//
//  Created by Vols on 15/3/18.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VCyclePicPlayerDelegate;

@interface V2CyclePicPlayer : UIView

@property (nonatomic, assign)   BOOL    isAutoPlay;
@property (nonatomic, assign)   CGFloat timeInterval;

@property (nonatomic, assign, setter = setDelegate:) id<VCyclePicPlayerDelegate> delegate;


/** 当数据源变化时的初始化参数操作（类似tableView的更新数据源）,第一次创建时无需单独调用 */
- (void)reloadData;

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;


- (void)stopPlay;
- (void)startPlay;

@end


@protocol VCyclePicPlayerDelegate <NSObject>

@optional

- (NSInteger)numberOfPages;
- (UIView *)cyclePicPlayer:(V2CyclePicPlayer *)cyclePicPlayer pageAtIndex:(NSInteger)index;

- (void)cyclePicPlayer:(V2CyclePicPlayer *)cyclePicPlayer atIndex:(NSInteger)index;
@end





