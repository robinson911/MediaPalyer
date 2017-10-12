//
//  LJBulletViewManager.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJBulletViewManager.h"
#import <libkern/OSAtomic.h>

@interface LJBulletViewManager ()
{
    OSSpinLock _spinLock;
    dispatch_queue_t _renderQueue;
}
@property (nonatomic, strong) CADisplayLink *displayLink;

//已经使用的弹道，从中可以取出前一个弹道的弹幕，进行碰撞判断
@property(nonatomic, strong)NSMutableDictionary *rendingDict;

//已经开始绘制显示在界面UI上的弹幕，暂存
@property(nonatomic, strong)NSMutableArray *renderingDanmakus;

//用户刚刚发送过来的弹幕数据，暂存
@property (nonatomic, strong) NSMutableArray <LJBulletView *> *fetchDanmakuAgentsArray;

@property (nonatomic, strong) NSOperationQueue *sourceQueue;

@property (nonatomic, assign) HJDanmakuTime playTime;

@end

@implementation LJBulletViewManager

#pragma mark -- life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _renderingDanmakus = [[NSMutableArray alloc]init];
        
       _fetchDanmakuAgentsArray = [[NSMutableArray alloc]init];

        _rendingDict = [[NSMutableDictionary alloc]init];
        
        self.playTime = (HJDanmakuTime){0, HJFrameInterval};
        
        if (!self.displayLink)
        {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
            self.displayLink.frameInterval = 60.0 * HJFrameInterval;
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        self.displayLink.paused = NO;

        self.sourceQueue = [NSOperationQueue new];
        self.sourceQueue.name = @"com.olinone.danmaku.sourceQueue";
        self.sourceQueue.maxConcurrentOperationCount = 1;
        
        _renderQueue = dispatch_queue_create("com.olinone.danmaku.renderQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(_renderQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    return self;
}

#pragma mark -- 发送数据
- (void)sendDanmaku:(LJBulletView *)danmaku forceRender:(BOOL)force
{
    if (!danmaku)  return;
    
    OSSpinLockLock(&_spinLock);
    [self.fetchDanmakuAgentsArray addObject:danmaku];
    OSSpinLockUnlock(&_spinLock);
    
    if (force)
    {
        HJDanmakuTime time = {0, HJFrameInterval};
        [self loadDanmakusFromSourceForTime:time];
    }
}

#pragma mark -- CADisplayLink所有视图遍历---时间递减
- (void)update
{
    HJDanmakuTime time = {0, HJFrameInterval};
#pragma mark --获取显示用的数据
    [self loadDanmakusFromSourceForTime:time];
    [self renderDanmakusForTime:time buffering:NO];
}

#pragma mark -- View显示
- (void)renderDanmakusForTime:(HJDanmakuTime)time buffering:(BOOL)isBuffering {
    dispatch_async(_renderQueue, ^{
        [self renderDisplayingDanmakusForTime:time];
        if (!isBuffering) {
            [self renderNewDanmakusForTime:time];
            //[self removeExpiredDanmakusForTime:time];
        }
    });
}

#pragma mark -- 弹幕绘制
- (void)renderNewDanmakusForTime:(HJDanmakuTime)time {
    OSSpinLockLock(&_spinLock);
    NSArray *ljArray = [NSArray arrayWithArray:[self.fetchDanmakuAgentsArray copy]];
    [self.fetchDanmakuAgentsArray removeAllObjects];
    OSSpinLockUnlock(&_spinLock);
    
    for (LJBulletView *danmakuAgent in ljArray)
    {
        if (![self renderNewDanmaku:danmakuAgent forTime:time])
        {
        }
    }
}

#pragma mark -- 所有视图遍历---时间递减
- (void)renderDisplayingDanmakusForTime:(HJDanmakuTime)time
{
    NSMutableArray *disappearDanmakuAgens = [NSMutableArray arrayWithCapacity:self.renderingDanmakus.count];
    [self.renderingDanmakus enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LJBulletView *danmakuAgent, NSUInteger idx, BOOL *stop)
    {
        danmakuAgent.remainingTime -= time.interval;
        
        NSLog(@"renderDisplayingDanmakus:-%f",danmakuAgent.remainingTime);
        
        if (danmakuAgent.remainingTime <= 0) {
            [disappearDanmakuAgens addObject:danmakuAgent];
            
            OSSpinLockLock(&_spinLock);
            [self.renderingDanmakus removeObjectAtIndex:idx];
            OSSpinLockUnlock(&_spinLock);
        }
    }];
    [self recycleDanmakuAgents:disappearDanmakuAgens];
}

- (void)recycleDanmakuAgents:(NSArray *)danmakuAgents {
    if (danmakuAgents.count == 0) {
        return;
    }
    onMainThreadAsync(^{
        for (LJBulletView *danmakuAgent in danmakuAgents) {
            [danmakuAgent.layer removeAllAnimations];
            [danmakuAgent removeFromSuperview];
            danmakuAgent.yIdx = -1;
            danmakuAgent.remainingTime = 0;
        }
    });
}

#pragma mark - 根据视图绘制
- (BOOL)layoutNewDanmaku:(LJBulletView *)danmakuAgent forTime:(HJDanmakuTime)time
{
    CGFloat width = [CHUtil getTextCGSize:danmakuAgent.ljBulletLabel.text Font:danmakuAgent.ljBulletLabel.font].width + 1.0f;
    danmakuAgent.size = CGSizeMake(width, CellHeight);
    
    OSSpinLockLock(&_spinLock);
    CGFloat py = [self layoutPyWithLRDanmaku:danmakuAgent forTime:time];
    OSSpinLockUnlock(&_spinLock);
    
    if (py < 0) {
        return NO;
    }
    danmakuAgent.py = py;
    danmakuAgent.px = kScreenWidth;
    return YES;
}

#pragma mark -- view展示数据产生
- (void)loadDanmakusFromSourceForTime:(HJDanmakuTime)time
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{

        OSSpinLockLock(&_spinLock);
        NSArray <LJBulletView *> *danmakuAgents = [self.fetchDanmakuAgentsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"remainingTime <= 0"]];
        OSSpinLockUnlock(&_spinLock);

        for (LJBulletView *danmakuAgent in danmakuAgents) {
            danmakuAgent.remainingTime = Duration;
            
            //NSLog(@"loadDanmakusFromSourceForTime---remainingTime:%f", danmakuAgent.remainingTime);
#pragma mark -- 给每个danmakuAgent赋予值5s
        }
    }];
    [self.sourceQueue cancelAllOperations];
    [self.sourceQueue addOperation:operation];
}

#pragma mark -- 最后一步渲染-----显示
- (BOOL)renderNewDanmaku:(LJBulletView *)danmakuAgent forTime:(HJDanmakuTime)time
{
    if (![self layoutNewDanmaku:danmakuAgent forTime:time]) {
        return NO;
    }
    
    OSSpinLockLock(&_spinLock);
    [self.renderingDanmakus addObject:danmakuAgent];
    OSSpinLockUnlock(&_spinLock);

    onMainThreadAsync(^{
        LJBulletView *cell = danmakuAgent;
        cell.frame = (CGRect){CGPointMake(danmakuAgent.px, danmakuAgent.py), danmakuAgent.size};
        
        [self insertSubview:cell atIndex:20];
        
        [UIView animateWithDuration:cell.remainingTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            cell.frame = (CGRect){CGPointMake(-cell.size.width, cell.py), cell.size};
            
        } completion:nil];
    });
    return YES;
}


#pragma mark -- 通道判断&高度返回
//1.当前通道是有视图的话，进行碰撞判断
//2.当前通道没view的直接返回显示的高度
- (CGFloat)layoutPyWithLRDanmaku:(LJBulletView *)danmakuAgent
                         forTime:(HJDanmakuTime)time
{
    u_int8_t maxPyIndex = (CGRectGetHeight(self.bounds) / CellHeight);
    NSMutableDictionary *retainer = self.rendingDict;
    for (u_int8_t index = 0; index < maxPyIndex; index++)
    {
        NSNumber *key = @(index);
        LJBulletView *tempAgent = retainer[key];
        if (!tempAgent) {
            danmakuAgent.yIdx = index;
            retainer[key] = danmakuAgent;
            
            //返回的高度
            NSLog(@"当前通道没view的直接返回显示的高度:%d----",index);
            return (CellHeight + CellSpace) * index;
        }
        //当前通道是有视图的话，进行碰撞判断
        if (![self checkLRIsWillHitWithPreDanmaku:tempAgent danmaku:danmakuAgent]) {
            danmakuAgent.yIdx = index;
            retainer[key] = danmakuAgent;
            //NSLog(@"当前通道有视图 * index %d----",cellHeight * index);
            return (CellHeight + CellSpace) * index;
        }
    }
    return -1;
}

- (BOOL)checkLRIsWillHitWithPreDanmaku:(LJBulletView *)preDanmakuAgent danmaku:(LJBulletView *)danmakuAgent {
    
    //前一个的显示时间，在递减的，每次减0.2s
    if (preDanmakuAgent.remainingTime <= 0) {
        return NO; //说明没有前一个视图
    }
    
    //屏幕的宽度
    CGFloat width = CGRectGetWidth(self.bounds);
    
    //持续时间5s下的速度
    CGFloat preDanmakuSpeed = (width + preDanmakuAgent.size.width) / Duration;
    //已经进入屏幕的距离与 视图总距离的比较
    if (preDanmakuSpeed * (Duration - preDanmakuAgent.remainingTime) < preDanmakuAgent.size.width) {
        return YES; //说明未移动出屏幕
    }
    
    CGFloat curDanmakuSpeed = (width + danmakuAgent.size.width) / Duration;
    if (curDanmakuSpeed * preDanmakuAgent.remainingTime > width) {
        return YES;
    }
    return NO;
}

@end

