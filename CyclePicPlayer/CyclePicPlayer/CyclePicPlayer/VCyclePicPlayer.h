//
//  VCyclePicPlayer.h
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/18.
//  Copyright © 2015年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VPlayerImageType) {
    ImageTypeFromLocal,
    ImageTypeFromNet
};

@interface VCyclePicPlayer : UIView

@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, assign) VPlayerImageType   imageType;


@property (nonatomic, copy) void(^tapAction)(NSUInteger index);

/** PlayerImageTypeFromNet类型时需要导入SDWebImage，实现.m里的代码 */
+ (instancetype)playerWithFrame:(CGRect)frame
          sourceArray:(NSArray *)sourceArray
               target:(id)target
         timeInterval:(CGFloat)interval
            imageType:(VPlayerImageType)imageType;

@end
