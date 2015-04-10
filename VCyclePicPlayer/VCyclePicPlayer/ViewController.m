//
//  ViewController.m
//  VCyclePicPlayer
//
//  Created by Vols on 15/3/18.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "ViewController.h"
#import "VCyclePicPlayer.h"

#define kSCREEN_SIZE  [UIScreen mainScreen].bounds.size

@interface ViewController () <VCyclePicPlayerDataSource, VCyclePicPlayerDelegate>
@property (weak, nonatomic) IBOutlet VCyclePicPlayer *cyclePicPlayer;

@end

@implementation ViewController

//delegate要在viewDidAppear里设置，优先级（印象：* * Storyboard）
- (void)viewDidAppear:(BOOL)animated{
    
    _cyclePicPlayer.delegate = self;
    _cyclePicPlayer.dataSource = self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cyclePicPlayer.isAutoPlay = YES;
    

}

- (NSInteger)numberOfPages
{
    return 5;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UILabel *l = [[UILabel alloc] initWithFrame:(CGRect){0,0,kSCREEN_SIZE.width,150}];
    l.text = [NSString stringWithFormat:@"%ld",(long)index];
    l.font = [UIFont systemFontOfSize:72];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor orangeColor];
    return l;
}

- (void)cyclePicPlayer:(VCyclePicPlayer *)cyclePicPlayer atIndex:(NSInteger)index
{
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

@end
