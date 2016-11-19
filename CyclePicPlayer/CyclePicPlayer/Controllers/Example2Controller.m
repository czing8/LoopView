//
//  Example2Controller.m
//  CyclePicPlayer
//
//  Created by Vols on 2016/11/2.
//  Copyright © 2016年 vols. All rights reserved.
//

#import "Example2Controller.h"
#import "V2CyclePicPlayer.h"



#define kSCREEN_SIZE  [UIScreen mainScreen].bounds.size

@interface Example2Controller ()<VCyclePicPlayerDelegate>

@property (nonatomic, strong) V2CyclePicPlayer *cyclePicPlayer;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSArray * urls;

@end

@implementation Example2Controller


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _images = @[@"1", @"2",@"3", @"4"];  //必须在delegate之前实例化，参考tableView 数据源

    _urls = @[@"http://e.hiphotos.baidu.com/news/q%3D100/sign=3b61b67032fae6cd0ab4af613fb20f9e/b21c8701a18b87d68b35fc58000828381f30fd06.jpg",
                      @"http://d.hiphotos.baidu.com/news/q%3D100/sign=ba6b27259f22720e7dcee6fa4bca0a3a/5882b2b7d0a20cf482317c9871094b36adaf99d0.jpg",
                      @"http://h.hiphotos.baidu.com/news/q%3D100/sign=bd9716616a224f4a5199771339f69044/64380cd7912397ddae28f8435e82b2b7d0a28727.jpg"];
    
    [self displayV2CyclePlayer];
}


- (void)displayV2CyclePlayer{
    
    _cyclePicPlayer = [[V2CyclePicPlayer alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_SIZE.width, kSCREEN_SIZE.width*(362/665.f))];
    _cyclePicPlayer.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_cyclePicPlayer];
    
    _cyclePicPlayer.delegate = self;
    _cyclePicPlayer.isAutoPlay = YES;
}




#pragma mark - CycleDelegate

- (NSInteger)numberOfPages {
    return _images.count;
}

- (UIView *)cyclePicPlayer:(V2CyclePicPlayer *)cyclePicPlayer pageAtIndex:(NSInteger)index {
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,cyclePicPlayer.bounds.size.width,cyclePicPlayer.bounds.size.height}];
    imgView.image = [UIImage imageNamed:_images[index]];
    
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_cyclePics[index]] placeholderImage:[UIImage imageNamed:@"placeholder_640x260"]];
    
    return imgView;
}

- (void)cyclePicPlayer:(V2CyclePicPlayer *)cyclePicPlayer atIndex:(NSInteger)index {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"当前点击第%ld个页面",(long)index]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
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
