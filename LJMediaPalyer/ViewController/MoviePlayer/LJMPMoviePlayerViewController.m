//
//  LJMPMoviePlayerViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/29.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJMPMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface LJMPMoviePlayerViewController ()

@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;//视频播放控制器
@end

@implementation LJMPMoviePlayerViewController

#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopNavBarTitle:@"MPMoviePlayerViewController Demo"];
    [self setTopNavBackButton];
    [self createPlayButton];
}

- (void)createPlayButton
{
    UIButton *_ljButton = [[UIButton alloc]init];
    _ljButton.backgroundColor = [UIColor grayColor];
    _ljButton.frame = CGRectMake(150, 250, 80, 40);
    [_ljButton setTitle:@"Play" forState:UIControlStateNormal];
    [_ljButton addTarget:self action:@selector(playClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ljButton];
}

/**
 *  播放
 */
- (void)playClicked
{
    if (_moviePlayer)
    {
       _moviePlayer = nil;
    }
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
}

/**
 *  取得网络文件路径
 */
- (NSURL *)getNetworkUrl
{
    NSString *urlStr = @"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 */
- (MPMoviePlayerViewController *)moviePlayer
{
    if (!_moviePlayer)
    {
        NSURL *url = [self getNetworkUrl];
        _moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    return _moviePlayer;
}

@end
