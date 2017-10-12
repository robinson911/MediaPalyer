//
//  LJAVPlayViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/13.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "BasePlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LJAVPlayView.h"

@interface BasePlayViewController ()

@property (nonatomic,assign) CGRect playerFrame;
@property (nonatomic,strong) LJAVPlayView *ljAVPlayView;

@end

@implementation BasePlayViewController

#pragma mark -- dealloc
- (void)dealloc
{
    NSLog(@"dealloc-----");
}

- (id)init
{
    if (self = [super init]) {
        self.playerFrame = CGRectMake(0, 0, kScreenWidth, (kScreenWidth)*(0.75));
        [self.view addSubview:self.ljAVPlayView];
    }
    return self;
}

#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DeviceOrientationChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_ljAVPlayView releaseAVPlayer];
}

#pragma mark -- 初始化播放器
- (LJAVPlayView*)ljAVPlayView
{
    if (!_ljAVPlayView)
    {
        _ljAVPlayView = [[LJAVPlayView alloc]initWithFrame: self.playerFrame];
        _ljAVPlayView.targetVC = self;
        @myWeakify(self);
        [_ljAVPlayView setFullClickedPalying:^(BOOL isFull){
             @myStrongify(self);
            if (isFull) {//已经是全屏了，变成小屏幕
                [self setNeedsStatusBarAppearanceUpdate];
                [self.ljAVPlayView showSmallScreenWithPlayer:self.ljAVPlayView withSuperView:self.view withFrame:self.playerFrame];
            }
            else
            {
                [self setNeedsStatusBarAppearanceUpdate];
                [self.ljAVPlayView showFullScreenWithplay:self.ljAVPlayView Orientation:UIInterfaceOrientationLandscapeLeft withSuperView:self.view];
            }
        }];
    }
    return _ljAVPlayView;
}

- (void)setTitleStr:(NSString *)titleStr
{
    if (titleStr.length == 0) {
        titleStr = @"美国大片";
    }
    _ljAVPlayView.titleStr = titleStr;
}

- (void)setUrlStr:(NSString *)urlStr
{
    if (urlStr.length == 0) {
        urlStr = @"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4";
    }
    _ljAVPlayView.urlStr = urlStr;
}

/**
 *  隐藏状态栏
 **/
- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - NotificationDeviceOrientationChange
- (void)DeviceOrientationChangeNotification:(NSNotification *)notification
{
    if (self.ljAVPlayView == nil || self.ljAVPlayView.superview == nil) return;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"第0个旋转方向---电池栏在上");
            if (self.ljAVPlayView.isFullscreen) {
                [self setNeedsStatusBarAppearanceUpdate];
                [self.ljAVPlayView showSmallScreenWithPlayer:self.ljAVPlayView withSuperView:self.view withFrame:self.playerFrame];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"第2个旋转方向---电池栏在左");
            self.ljAVPlayView.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self.ljAVPlayView showFullScreenWithplay:self.ljAVPlayView Orientation:interfaceOrientation withSuperView:self.view];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"第1个旋转方向---电池栏在右");
            self.ljAVPlayView.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self.ljAVPlayView showFullScreenWithplay:self.ljAVPlayView Orientation:interfaceOrientation withSuperView:self.view];
        }
            break;
        default:
            break;
    }
}

@end

