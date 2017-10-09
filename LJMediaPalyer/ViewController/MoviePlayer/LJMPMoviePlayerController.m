//
//  LJMPMoviePlayerController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/15.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJMPMoviePlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"


@interface LJMPMoviePlayerController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

@end

@implementation LJMPMoviePlayerController

#pragma mark -- dealloc
- (void)dealloc
{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopNavBarTitle:@"MPMoviePlayerController Demo"];
    [self setTopNavBackButton];
    
    //添加通知
    [self addNotification];
    
    [self.view addSubview:self.moviePlayer.view];
    //播放
    [self.moviePlayer play];
    [self showLoading];
}

/**
 *  取得本地文件路径
 */
- (NSURL *)getFileUrl
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"moive.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 */
- (NSURL *)getNetworkUrl
{
    NSString *urlStr = @"http://baobab.wdjcdn.com/14571455324031.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 */
- (MPMoviePlayerController *)moviePlayer
{
    if (!_moviePlayer)
    {
        NSURL *url = [self getNetworkUrl];
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    }
    return _moviePlayer;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
- (void)addNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 */
- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification
{
    switch (self.moviePlayer.playbackState)
    {
        case MPMoviePlaybackStatePlaying:
        {
            [self hiddenLoading];
            NSLog(@"正在播放...");
        }
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 */
- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification
{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 显示加载框
- (void)showLoading
{
    [self showHudInSuitableView:@""];
}

#pragma mark -- 隐藏
- (void)hiddenLoading
{
    [self hideHud];
}

@end
