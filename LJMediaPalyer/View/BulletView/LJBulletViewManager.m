//
//  LJBulletViewManager.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJBulletViewManager.h"
#import "LJBulletView.h"

//生成弹道
#define trajectoryNum  5

@interface LJBulletViewManager ()

/** 临时存储弹幕数据*/
@property(nonatomic, strong)NSMutableArray *tmpCommentsArray;

@property(nonatomic, strong)NSMutableArray *trajectoryNumArray;

@property(nonatomic, assign)BOOL bStopAnimation;

@end

@implementation LJBulletViewManager

#pragma mark -- life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tmpCommentsArray = [NSMutableArray array];
        //弹道
        _trajectoryNumArray = [NSMutableArray array];
        
        _allCommentsArray = [NSMutableArray array];
    }
    return self;
}

- (void)makeTrajectoryNumArray
{
    for (int i = 0; i < trajectoryNum; i++)
    {
        [_trajectoryNumArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
}

/**
 *  初始化弹幕
 */
- (void)createBulletView
{
    [self makeTrajectoryNumArray];
    int j = (int) _trajectoryNumArray.count;
    
    /**随机生成5条弹幕轨迹，然后再直接展示出来 */
    if (self.tmpCommentsArray.count > 0)
    {
        //初始化5条弹幕轨迹
        for (int i = j; i > 0; i--)
        {
            NSString *comment = [self.tmpCommentsArray firstObject];
            if (comment.length > 0)
            {
                [self.tmpCommentsArray removeObjectAtIndex:0];
                //随机生成弹道创建弹幕进行展示（弹幕的随机飞入效果）
                NSInteger index = arc4random()%_trajectoryNumArray.count;
                int trajectory = [[_trajectoryNumArray objectAtIndex:index] intValue];
                [_trajectoryNumArray removeObjectAtIndex:index];
                [self createBulletViewByComment:comment trajectory:trajectory];
            } else
            {
                //没弹幕，则跳出
                break;
            }
        }
    }
}

#pragma mark -- 弹幕开始
- (void)startBullet
{
    /** 生产的弹幕存储起来，统一处理*/
    if (self.allCommentsArray.count > 0)
    {
        [self.tmpCommentsArray addObjectsFromArray:[self.allCommentsArray mutableCopy] ];
        [self.allCommentsArray removeAllObjects];
    }
    
    /** 延时消费弹幕*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.bStopAnimation = NO;
        [self createBulletView];
    });
}

#pragma mark -- 弹幕结束
- (void)stopBullet
{
    self.bStopAnimation = YES;
}

#pragma mark -- 创建弹幕UI
- (void)createBulletView:(LJBulletView *)bulletView
{
    bulletView.frame = CGRectMake(CGRectGetWidth(self.frame), 20 + 34 * bulletView.trajectory, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self addSubview:bulletView];
    
    //弹幕闪亮登场
    [bulletView startAnimation];
}

/**
 *  创建弹幕
 *
 *  @param comment    弹幕内容
 *  @param trajectory 弹道位置
 */
- (void)createBulletViewByComment:(NSString *)comment
                       trajectory:(int)trajectory
{
    if (self.bStopAnimation) return;
    
    //创建一个弹幕view
    LJBulletView *view = [[LJBulletView alloc] initWithContent:comment];
    //设置运行轨迹
    view.trajectory = trajectory;
    
    //弹幕生成后，传到viewcontroller进行页面展示
    if (self.generateBulletBlock)
    {
        self.generateBulletBlock(view);
    }
}

@end

