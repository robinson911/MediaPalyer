//
//  LJAVPlayViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/13.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJAVPlayViewController.h"
#import "LJBulletViewManager.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LJAVPlayView.h"
#import "LJMQTTKit.h"

@interface LJAVPlayViewController ()

@property (nonatomic,strong) LJBulletViewManager *ljBulletViewManager;
@property (nonatomic,strong) LJMQTTKit *ljMQTTKit;
@property (nonatomic,strong) LJAVPlayView *ljAVPlayView;

@end

@implementation LJAVPlayViewController

#pragma mark -- dealloc
- (void)dealloc
{
    [_ljMQTTKit disconnectLJMQTTKit];
    
    NSLog(@"dealloc-----");
}

#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.ljAVPlayView];
    
//    [self initLJMQTTKit];
//    [_ljAVPlayView.avPlayControlView addSubview:self.ljBulletViewManager];
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
        //http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4
        //http://baobab.wdjcdn.com/1458625865688ONE.mp4
        
        _ljAVPlayView = [[LJAVPlayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth)*(0.75))];
        _ljAVPlayView.titleStr = @"美国大片";
        _ljAVPlayView.urlStr = @"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4";
        
        /*@myWeakify(self);
        [_ljAVPlayView setIsPalyingBullet:^(BOOL flag){
            @myStrongify(self);
            if (flag)
            {
                //[self initLJBulletViewManager];
                //[self.view addSubview:self.ljBulletViewManager];
                [self.ljBulletViewManager startBullet];
            }
            else
            {
               [self.ljBulletViewManager stopBullet];
               //[self.ljBulletViewManager removeFromSuperview];
               //self.ljBulletViewManager = nil;
            }
        }];
       
        //重新设置frame
        [_ljAVPlayView setFullClickedPalying:^{
            @myStrongify(self);
            
            [self.ljBulletViewManager setFrame:CGRectMake(0, 64, self.ljAVPlayView.avPlayControlView.frame.size.width, self.ljAVPlayView.avPlayControlView.frame.size.height - 64 - 50)];
        }];
        
        */
    }
    return _ljAVPlayView;
}

- (void)setTitleStr:(NSString *)titleStr
{
    if (titleStr.length == 0) {
        _ljAVPlayView.titleStr = @"美国大片";
    }
    _ljAVPlayView.titleStr = titleStr;
}

- (void)setUrlStr:(NSString *)urlStr
{
    if (urlStr.length == 0) {
        _ljAVPlayView.urlStr = @"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4";
    }
    _ljAVPlayView.urlStr = urlStr;
}

- (void)initLJMQTTKit
{
    if (!_ljMQTTKit)
    {
        _ljMQTTKit = [[LJMQTTKit alloc]initMqttByServerHost:kMQTTServerHost];
        
         @myWeakify(self);
        [_ljMQTTKit setHandleMQTTMessage:^(NSArray *messageArray)
        {
            @myStrongify(self);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [self.ljBulletViewManager.allCommentsArray addObjectsFromArray: messageArray];
                [self.ljBulletViewManager startBullet];
            //});
        }];
    }
}

- (LJBulletViewManager*)ljBulletViewManager
{
    if (!_ljBulletViewManager)
    {
        //_ljBulletViewManager = [[LJBulletViewManager alloc]initWithFrame:CGRectMake(0, 64,kScreenHeight - 50, 100)];

        _ljBulletViewManager = [[LJBulletViewManager alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, self.ljAVPlayView.avPlayControlView.frame.size.height - 64 - 50)];
        //_ljBulletViewManager.backgroundColor = [UIColor redColor];
        _ljBulletViewManager.tag = 20170501;

        @myWeakify(self);
        _ljBulletViewManager.generateBulletBlock = ^(LJBulletView *bulletView)
        {
            @myStrongify(self);
            //将生成的弹幕View添加到当前屏幕上
            [self.ljBulletViewManager createBulletView:bulletView];
        };
    }
    return _ljBulletViewManager;
}

@end

