//
//  ViewController.m
//  VCyclePicPlayer_2
//
//  Created by Vols on 15/5/18.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "ViewController.h"
#import "VCyclePicPlayer.h"

#define kSCREEN_SIZE  [UIScreen mainScreen].bounds.size

@interface ViewController () <VCyclePicPlayerDelegate>

@property (weak, nonatomic) IBOutlet VCyclePicPlayer *cyclePicPlayer;
@property (nonatomic, strong) NSArray * images;


@end

@implementation ViewController

//delegate要在viewDidAppear里设置，优先级（印象：* * Storyboard）
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _cyclePicPlayer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _cyclePicPlayer.delegate = self;   //多添加一次，不然第一页空白。
}


- (void)viewDidLoad {
    [super viewDidLoad];


    _cyclePicPlayer.isAutoPlay = YES;
    _images = @[@"h1", @"h2", @"h3", @"h4"];
}




- (NSInteger)numberOfPages
{
    return _images.count;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,kSCREEN_SIZE.width,150}];
    imgView.image = [UIImage imageNamed:_images[index]];
    //    [imgView sd_setImageWithURL:[NSURL URLWithString:_cyclePics[index]] placeholderImage:[UIImage imageNamed:@"placeholder_640x260"]];
    
    return imgView;
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
