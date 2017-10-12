//
//  LJBulletViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/11.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJBulletViewController.h"
#import "LJTestView.h"
#import "LJBulletViewManager.h"
#import "LJBulletView.h"
#import <libkern/OSAtomic.h>

@interface LJBulletViewController ()
{
   OSSpinLock _spinLock;
}

@property (nonatomic,strong) LJBulletViewManager *ljBulletViewManager;

@end

@implementation LJBulletViewController

#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopNavBackButton];
    [self setTopNavBarTitle:@"测试"];
    
    //[self initLJBulletViewManager];
    [self.view addSubview:self.ljBulletViewManager];
    //[self.ljBulletViewManager startBullet];
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake((kScreenWidth - 100)/2.0, 460, 100, 50);
    [_btn setTitle:@"点我" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    _btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_btn];
}

- (void)testNSBlockOperation
{
    //创建对象，封装操作
   NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
      NSLog(@"NSBlockOperation3----1%@",[NSThread currentThread]);
    }];
    
   [operation addExecutionBlock:^{
         NSLog(@"NSBlockOperation3--2----%@",[NSThread currentThread]);
     }];
    
   //创建NSOperationQueue
   NSOperationQueue * queue=[[NSOperationQueue alloc]init];
   //把操作添加到队列中
   [queue addOperation:operation];
}

- (LJBulletViewManager*)ljBulletViewManager
{
    if (!_ljBulletViewManager)
    {
        _ljBulletViewManager = [[LJBulletViewManager alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        //_ljBulletViewManager.backgroundColor = [UIColor redColor];
        _ljBulletViewManager.tag = 20170501;
    }
    return _ljBulletViewManager;
}

- (void)test
{
    LJTestView *_view =  [[LJTestView alloc]initWithContent:@"我是shuiiii"];
    _view.frame = CGRectMake(kScreenWidth + 50, 20 + 34 * 3, 42, 14);
    [self.view addSubview:_view];
    [_view  startAnimation];
}

- (void)clicked:(id)sender
{
//    NSUInteger c = arc4random_uniform(6);
//    NSArray *contentstr = @[@"swdedf", @"我是谁谁谁谁", @"测试数我的你的大家的", @"6789045",@"ghjkliouipohjlk",@"ghjklijlqwdqefrgtouipohjlk"];
    
//    [self.ljBulletViewManager.allCommentsArray addObject:contentstr[c]];
    //    [self.ljBulletViewManager startBullet];
    
    //[self testNSBlockOperation];
    
    NSUInteger c = arc4random_uniform(13);
    NSArray *contentArray = @[@"swdedf",
                              @"我是谁谁谁谁",
                              @"我是",
                              @"我谁",
                              @"我",
                              @"谁",
                              @"我是谁谁我是谁谁谁谁我是谁谁谁谁我是谁谁谁谁我是谁谁谁谁谁谁",
                              @"测试数我的你的大家的",
                              @"6789045",
                              @"ghjkliouipohjlk",
                              @"ghjklijlqwdqefrgtouipohjlk",
                              @"wdef123456782345678io",
                              @"uej3kqefdvsjnlqeofadilqeadjpzck;"];
    
    LJBulletView *danmaku = [[LJBulletView alloc] initWithContent:contentArray[c]];
    danmaku.remainingTime = 0;
    
    //OSSpinLockLock(&_spinLock);
    //[self.ljBulletViewManager renderNewDanmaku:danmaku forTime:(HJDanmakuTime){0, 0.2}];
    //OSSpinLockUnlock(&_spinLock);
    [self.ljBulletViewManager sendDanmaku:danmaku forceRender:YES];
}

@end
