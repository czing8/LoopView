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
    _images = @[@"1", @"2",@"3", @"4"];  //必须在delegate之前实例化，参考tableView 数据源
    
    _urls = @[@"http://e.hiphotos.baidu.com/news/q%3D100/sign=3b61b67032fae6cd0ab4af613fb20f9e/b21c8701a18b87d68b35fc58000828381f30fd06.jpg",
              @"http://d.hiphotos.baidu.com/news/q%3D100/sign=ba6b27259f22720e7dcee6fa4bca0a3a/5882b2b7d0a20cf482317c9871094b36adaf99d0.jpg",
              @"http://h.hiphotos.baidu.com/news/q%3D100/sign=bd9716616a224f4a5199771339f69044/64380cd7912397ddae28f8435e82b2b7d0a28727.jpg"];
    
    [self displayVCyclePlayer];
}

- (void)displayVCyclePlayer{
    VCyclePicPlayer *player = [VCyclePicPlayer playerWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 160)
                                                   sourceArray:_images
                                                        target:self
                                                  timeInterval:2.f
                                                     imageType:ImageTypeFromLocal];
    player.tapAction = ^(NSUInteger index){
        NSLog(@"%lu", (unsigned long)index);
    };
    
    VCyclePicPlayer *webImagePlayer = [VCyclePicPlayer playerWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 160)
                                                           sourceArray:_urls
                                                                target:self
                                                          timeInterval:2.f
                                                             imageType:ImageTypeFromNet];
    
    webImagePlayer.tapAction = ^(NSUInteger index){
        NSLog(@"%lu", (unsigned long)index);
    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
