//
//  V3CyclePicPlayer.h
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/1.
//  Copyright © 2015年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef NS_ENUM(NSInteger, VCyclePageType) {
    VCyclePageTypeNone,
    VCyclePageTypeLeft,
    VCyclePageTypeRight,
    VCyclePageTypeCenter
};

typedef void(^ClickHandler)(NSInteger index);


@interface V3CyclePicPlayer : UIView

@property (nonatomic, assign)   VCyclePageType pageType;

@property (nonatomic, strong)   UIColor *pageIndicatorTintColor;
@property (nonatomic, strong)   UIColor *currentPageIndicatorTintColor;

/**
 *  创建本地图片
 *
 *  @param imageNames   图片名字数组
 *  @param block        点击block
 *  @return             创建本地图片，不自动切换
 */
-(id)initWithImageNames:(NSArray *)imageNames click:(ClickHandler)block;



/**
 *  创建本地图片
 *
 *  @param imageNames   图片名字数组
 *  @param block        点击block
 *  @param timeInterval 自动切换时间(0为不切换)
 *  @return             创建本地图片
 */
-(id)initWithImageNames:(NSArray *)imageNames autoTimerInterval:(NSTimeInterval)timeInterval click:(ClickHandler)block;



/**
 *  创建网络图片
 *
 *  @param imageUrls    图片名字数组
 *  @param block         点击block
 *  @return              创建网络图片，不自动切换
 */
-(id)initWithImageUrls:(NSArray *)imageUrls click:(ClickHandler)block;


/**
 *  创建网络图片
 *
 *  @param imageUrls   图片名字数组
 *  @param block        点击block
 *  @param timeInterval 自动切换时间(0为不切换)
 *  @return             创建网络图片
 */
-(id)initWithImageUrls:(NSArray *)imageUrls autoTimerInterval:(NSTimeInterval)timeInterval click:(ClickHandler)block;


/** 更换图片网络URL  */
-(void)replaceImageUrls:(NSArray *)imageUrls click:(ClickHandler)block;


/** 更换图片本地名字 */
-(void)replaceImageNames:(NSArray *)imageNames click:(ClickHandler)block;

@end
