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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_cyclePicPlayer)  [_cyclePicPlayer startPlay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_cyclePicPlayer)  [_cyclePicPlayer stopPlay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _images = @[@"h1", @"h2", @"h3", @"h4"];

    _cyclePicPlayer.delegate = self;
    _cyclePicPlayer.isAutoPlay = YES;
}


#pragma mark - CycleDelegate

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


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
