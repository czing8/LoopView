//
//  Example1Controller.m
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/2.
//  Copyright © 2015年 vols. All rights reserved.
//

#import "Example1Controller.h"
#import "VCyclePicPlayer.h"

@interface Example1Controller ()

@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * urls;
@end

@implementation Example1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _images = @[@"1", @"2",@"3", @"4", @"5"];
    
    _urls = @[@"http://e.hiphotos.baidu.com/news/q%3D100/sign=3b61b67032fae6cd0ab4af613fb20f9e/b21c8701a18b87d68b35fc58000828381f30fd06.jpg",
              @"http://d.hiphotos.baidu.com/news/q%3D100/sign=ba6b27259f22720e7dcee6fa4bca0a3a/5882b2b7d0a20cf482317c9871094b36adaf99d0.jpg",
              @"http://h.hiphotos.baidu.com/news/q%3D100/sign=bd9716616a224f4a5199771339f69044/64380cd7912397ddae28f8435e82b2b7d0a28727.jpg"];
    
    [self displayCyclePlayer];
}

- (void)displayCyclePlayer{
    
    // 加载本地图片
    VCyclePicPlayer *player = [VCyclePicPlayer playerWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.width/2)  sourceArray: _images];
    player.clickHandler = ^(NSUInteger index){
        NSLog(@"%lu", (unsigned long)index);
    };
    
    // 加载网络图片
    VCyclePicPlayer *webImagePlayer = [VCyclePicPlayer playerWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.width/2)
                                                           sourceArray:_urls
                                                          timeInterval:2.f
                                                        transitionType:PlayerTransitionTypeRippleEffect];
    webImagePlayer.clickHandler = ^(NSUInteger index){
        NSLog(@"%lu", (unsigned long)index);
    };
    
    [self.view addSubview:player];
    [self.view addSubview:webImagePlayer];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
