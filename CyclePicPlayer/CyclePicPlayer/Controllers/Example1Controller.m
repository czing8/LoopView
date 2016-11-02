//
//  Example1Controller.m
//  CyclePicPlayer
//
//  Created by Vols on 2015/11/2.
//  Copyright © 2015年 vols. All rights reserved.
//

#import "Example1Controller.h"
#import "VCycle1PicPlayer.h"

@interface Example1Controller ()

@property (nonatomic, strong)   VCycle1PicPlayer *cycle1PicPlayer;

@end

@implementation Example1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"轮播banner";
    
    [self addCycle1PicPlayer];
}


- (void)addCycle1PicPlayer{

    
    [self addRightBarButton:@"切换图片" target:self action:@selector(rightClicked:)];
    
    NSArray *urls = @[
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=7844b6536559252da3424e4452a63709/4b90f603738da97798afd262b551f8198718e3f3.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=2fbe89b579d98d1076815f7147028c3c/f603918fa0ec08fa505e0cee5cee3d6d55fbda18.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=e5d0477f18950a7b75601d846cec56eb/0ff41bd5ad6eddc4f802a8b23cdbb6fd53663395.jpg",
                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=88b9154b8244ebf86d24377fbfc4e318/42a98226cffc1e17695ba0794f90f603728de996.jpg"];
    
    self.cycle1PicPlayer = [[VCycle1PicPlayer alloc] initWithImageUrls:urls autoTimerInterval:3 click:^(NSInteger index) {
        NSLog(@"click banner1 :%ld", (long)index);
        
    }];
    
    [self.view addSubview:_cycle1PicPlayer];
    [_cycle1PicPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(_cycle1PicPlayer.mas_width).multipliedBy(260/425.f);
    }];
    
    
    
    VCycle1PicPlayer *banner2 = [[VCycle1PicPlayer alloc] initWithImageNames:@[@"image1", @"image2"] autoTimerInterval:2 click:^(NSInteger index) {
        NSLog(@"click banner2 :%ld", (long)index);
    }];
    banner2.pageType = VCyclePageTypeRight;
    banner2.pageIndicatorTintColor = [UIColor grayColor];
    banner2.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:banner2];
    [banner2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.cycle1PicPlayer.mas_bottom).offset(50);
        make.height.equalTo(banner2.mas_width).multipliedBy(362/665.f);
    }];
}


-(void)rightClicked:(id)sender
{
    NSArray *urls = @[@"http://e.hiphotos.baidu.com/news/q%3D100/sign=3b61b67032fae6cd0ab4af613fb20f9e/b21c8701a18b87d68b35fc58000828381f30fd06.jpg",
                      @"http://d.hiphotos.baidu.com/news/q%3D100/sign=ba6b27259f22720e7dcee6fa4bca0a3a/5882b2b7d0a20cf482317c9871094b36adaf99d0.jpg",
                      @"http://h.hiphotos.baidu.com/news/q%3D100/sign=bd9716616a224f4a5199771339f69044/64380cd7912397ddae28f8435e82b2b7d0a28727.jpg"];
    [self.cycle1PicPlayer replaceImageUrls:urls click:^(NSInteger index) {
        //可以做点击处理
    }];
    
    [_cycle1PicPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(_cycle1PicPlayer.mas_width).multipliedBy(362/656.f);
    }];
    
}

-(void)addRightBarButton:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:action];
    self.navigationItem.rightBarButtonItem = button;
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
