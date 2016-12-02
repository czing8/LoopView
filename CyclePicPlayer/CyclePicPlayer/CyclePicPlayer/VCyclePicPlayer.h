//
//  VCyclePicPlayer.h
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/18.
//  Copyright © 2015年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VPlayerTransitionType) {
    PlayerTransitionTypeNormal,
    PlayerTransitionTypeRippleEffect,
};

typedef void(^ClickHandler)(NSUInteger index);

@interface VCyclePicPlayer : UIView

@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, assign) VPlayerTransitionType transitionType;

@property (nonatomic, copy  ) ClickHandler clickHandler;


/**
 *  默认间隔2秒， sourceType为网络图片, 切换无动画
 */
+ (instancetype)playerWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray;

/**
 *  @param transitionType   切换动画类型
 */
+ (instancetype)playerWithFrame:(CGRect)frame
                    sourceArray:(NSArray *)sourceArray
                   timeInterval:(CGFloat)interval
                 transitionType:(VPlayerTransitionType)transitionType;

- (void)startTimer;
- (void)stopTimer;

@end
