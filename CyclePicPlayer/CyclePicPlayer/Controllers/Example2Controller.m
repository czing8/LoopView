//
//  Example2Controller.m
//  CyclePicPlayer
//
//  Created by Vols on 2016/11/2.
//  Copyright © 2016年 vols. All rights reserved.
//

#import "Example2Controller.h"
#import "VCycle2PicPlayer.h"

#define kSCREEN_SIZE  [UIScreen mainScreen].bounds.size

@interface Example2Controller ()<VCyclePicPlayerDelegate>

@property (nonatomic, strong) VCycle2PicPlayer *cyclePicPlayer;
@property (nonatomic, strong) NSArray * images;

@end

@implementation Example2Controller


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_cyclePicPlayer)  [_cyclePicPlayer startPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_cyclePicPlayer)  [_cyclePicPlayer stopPlay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _images = @[@"image1", @"image2"];  //必须在delegate之前实例化，参考tableView 数据源
    
    _cyclePicPlayer = [[VCycle2PicPlayer alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_SIZE.width, kSCREEN_SIZE.width*(362/665.f))];
    _cyclePicPlayer.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_cyclePicPlayer];
    
    _cyclePicPlayer.delegate = self;
    _cyclePicPlayer.isAutoPlay = YES;
}


#pragma mark - CycleDelegate

- (NSInteger)numberOfPages {
    return _images.count;
}

- (UIView *)cyclePicPlayer:(VCycle2PicPlayer *)cyclePicPlayer pageAtIndex:(NSInteger)index {
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,cyclePicPlayer.bounds.size.width,cyclePicPlayer.bounds.size.height}];
    imgView.image = [UIImage imageNamed:_images[index]];
    
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_cyclePics[index]] placeholderImage:[UIImage imageNamed:@"placeholder_640x260"]];
    
    return imgView;
}

- (void)cyclePicPlayer:(VCycle2PicPlayer *)cyclePicPlayer atIndex:(NSInteger)index {
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
