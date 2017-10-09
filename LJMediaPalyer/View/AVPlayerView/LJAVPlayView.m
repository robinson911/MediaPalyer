//
//  LJAVPlayView.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJAVPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "LJAVPlayControlView.h"

@interface LJAVPlayView ()

/** 播放器 */
@property (nonatomic,strong) AVPlayer *player;
/** 播放器属性对象 */
@property (nonatomic,strong) AVPlayerItem *playerItem;
/** 播放器需要的layer */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/** 是否拖动Slider */
@property (nonatomic,assign) BOOL isDragSlider;
/** 定时器 自动消失View */
@property (nonatomic,strong) NSTimer *autoDismissTimer;
/** 竖直时候的小视屏的长宽  */
@property (nonatomic, assign) float cellWidth;

@property (nonatomic, assign) float lastTime;

/** 网络卡顿时，加载loading*/
@property (nonatomic, strong)CADisplayLink *link;

@end

@implementation LJAVPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.avPlayControlView.frame = self.frame;
        //控制View重新设置frame
        [self addSubview:self.avPlayControlView];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;

    [self createAVPlay];
    [self showLoading];
}

/** 设置标题 */
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    [self.avPlayControlView setPlayLabelTitle:_titleStr];
}

#pragma mark -- life cycle
- (void)createAVPlay
{
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avPlayDidEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];

    /* 1. 初始化一个View，是用来放置播放器用的,此处是self
       2. 初始化播放器AVPlayerItem,用来设置播放视屏的URL或者本地视屏资源
       3. 初始化一个AVPlayer对象，来接收AVPlayerItem传过来的资源
       4. 初始化一个AVPlayerLayer对象，将AVPlayer对象叠加在其上面
       5. 将AVPlayerLayer对象添加到self的layer层上
     */
    // 初始化播放器item
    self.playerItem = [self getPlayItemWithURLString:self.urlStr];//[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    // 监听播放器状态变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓存大小
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 初始化一个AVPlayer
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 初始化播放器的Layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //此处为默认视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    // 添加playerLayer到self.layer
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    /* layer的填充属性
     AVLayerVideoGravityResizeAspect 等比例拉伸，会留白
     AVLayerVideoGravityResizeAspectFill // 等比例拉伸，会裁剪
     AVLayerVideoGravityResize // 保持原有大小拉伸
      */
}

/**
 *  判断是否是网络视频 还是 本地视频
 **/
- (AVPlayerItem *)getPlayItemWithURLString:(NSString *)url
{
    if ([url containsString:@"http"]) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:url] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.avPlayControlView.frame = self.bounds;
}

// 监听播放器的变化属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues)
        {
            case AVPlayerItemStatusReadyToPlay:
            {
                [self hiddenLoading];
                
                [self setNeedsLayout];
                [self layoutIfNeeded];

                // 最大值直接用sec，以前都是
                // CMTimeMake(帧数（slider.value * timeScale）, 帧/sec)
                
                if (CMTimeGetSeconds(self.playerItem.duration)) {
                    double _x = CMTimeGetSeconds(self.playerItem.duration);
                    if (!isnan(_x)) {
                        [self.avPlayControlView setSliderMaxValue:CMTimeGetSeconds(self.playerItem.duration)];
                    }
                }
                [self initTimer];
                
                // 启动定时器 10秒自动隐藏
                if (!self.autoDismissTimer)
                {
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(autoHiddenControlView) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
            }
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"--AVPlayerItemStatusUnknown");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"--AVPlayerItemStatusFailed");
                break;
                
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) // 监听缓存进度的属性
    {
        // 计算缓存进度
        NSTimeInterval timeInterval = [self availableDuration];
        // 获取总长度
        CMTime duration = self.playerItem.duration;
        
        CGFloat durationTime = CMTimeGetSeconds(duration);
        // 监听到了给进度条赋值
        [self.avPlayControlView setProgress:timeInterval / durationTime];
    }
}

#pragma mark - 全屏显示播放 和 缩小显示播放器
/**
 *  全屏显示播放
 ＊ @param interfaceOrientation 方向
 ＊ @param player 当前播放器
 ＊ @param fatherView 当前父视图
 **/
- (void)showFullScreenWithplay:(LJAVPlayView *)player
                   Orientation:(UIInterfaceOrientation)interfaceOrientation
                withSuperView:(UIView *)fatherView
{
    [player removeFromSuperview];
    player.transform = CGAffineTransformIdentity;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        player.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        player.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    player.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    player.playerLayer.frame =  CGRectMake(0,0, [[UIScreen mainScreen]bounds].size.height,[[UIScreen mainScreen]bounds].size.width);

    [fatherView addSubview:player];
    [self resetAvPlayControlViewFrame];
    [player bringSubviewToFront:player.avPlayControlView];
    player.isFullState = YES;
}

/**
 *  小屏幕显示播放
 ＊ @param player 当前播放器
 ＊ @param fatherView 当前父视图
 ＊ @param playerFrame 小屏幕的Frame
 **/
- (void)showSmallScreenWithPlayer:(LJAVPlayView *)player
                  withSuperView:(UIView *)fatherView
                       withFrame:(CGRect)playerFrame
{
    [player removeFromSuperview];

    [UIView animateWithDuration:0.5f animations:^{
        player.transform = CGAffineTransformIdentity;
        player.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        player.playerLayer.frame =  player.bounds;
        [fatherView addSubview:player];
    }completion:^(BOOL finished) {
        player.isFullState = NO;
        [self resetAvPlayControlViewFrame];
    }];
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start); // 开始的点
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration); // 已缓存的时间点
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 调用player的对象进行UI更新
- (void)initTimer
{
    // player的定时器
    @myWeakify(self);
    // 每秒更新一次UI Slider
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time)
     {
         @myStrongify(self);
         // 当前时间
         CGFloat nowTime = CMTimeGetSeconds(self.playerItem.currentTime);
         // 总时间
         CGFloat duration = CMTimeGetSeconds(self.playerItem.duration);
         // sec 转换成时间点
         
         [self.avPlayControlView setNowLabelText:[self convertToTime:nowTime]];
         [self.avPlayControlView setRemainLabelText:[self convertToTime:(duration - nowTime)]];

         // 不是拖拽中的话更新UI
         if (!self.isDragSlider)
         {
             [self.avPlayControlView setSliderValue:CMTimeGetSeconds(self.playerItem.currentTime)];
         }
     }];
}

// sec 转换成指定的格式
- (NSString *)convertToTime:(CGFloat)time
{
    // 初始化格式对象
    NSDateFormatter *fotmmatter = [[NSDateFormatter alloc] init];
    // 根据是否大于1H，进行格式赋值
    if (time >= 3600)
    {
        [fotmmatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [fotmmatter setDateFormat:@"mm:ss"];
    }
    // 秒数转换成NSDate类型
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    // date转字符串
    return [fotmmatter stringFromDate:date];
}

#pragma mark -- 释放
- (void)releaseAVPlayer
{
    [self.player pause];
    [self.player setRate:0];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
}

#pragma mark -- 控制View
- (LJAVPlayControlView*)avPlayControlView
{
    if (!_avPlayControlView)
    {
        _avPlayControlView = [[LJAVPlayControlView alloc]initWithFrame:self.frame];
        @myWeakify(self);
        [_avPlayControlView pauseOrPlayBlock:^{
            @myStrongify(self);

            if (self.player.rate != 1.0f)
            {
                [self play];
            }
            else
            {
                [self pause];
            }
        } clickSmallOrFullScreenBloc:^{
            @myStrongify(self);
            /** 点击全屏幕 */
            if (self.fullClickedPalying)
            {
                if (self.isFullState) {
                    self.fullClickedPalying(YES);
                }
                else
                {
                    self.fullClickedPalying(NO);
                }
                [self resetAvPlayControlViewFrame];
            }
        }];
        [_avPlayControlView setGoBackClickedBlock:^{
            @myStrongify(self);
            
            [self removeFromSuperview];
            [self releaseAVPlayer];
        }];
        
        //拖动设置
        [_avPlayControlView setStratDragSliderBlock:^{
             @myStrongify(self);
             [self.player seekToTime:CMTimeMakeWithSeconds(self.avPlayControlView.slider.value, self.playerItem.currentTime.timescale)];
        }];
    }
    return _avPlayControlView;
}

- (void)resetAvPlayControlViewFrame
{
    /**  防止横竖屏幕切换时，slider的进度不对，
     所以是，先移除avPlayControlView，设置好frame后，再添加上去
     */
    [self.avPlayControlView removeFromSuperview];
    //控制View重新设置frame
    [self.avPlayControlView reSetPlayControlView:self.bounds];
    [self addSubview: self.avPlayControlView];
}

- (void)avPlayDidEnd
{
    [self.avPlayControlView setPauseOrPlayBackImage:NO];
    [self.player pause];
    
    if (self.isPalyingBullet)
    {
        self.isPalyingBullet(NO);
    }
}

- (void)play
{
   [self.avPlayControlView setPauseOrPlayBackImage:YES];
   [self.player play];
}

- (void)pause
{
   [self.avPlayControlView setPauseOrPlayBackImage:NO];
   [self.player pause];
}

#warning check
/**
  网络视屏卡顿的情况下,更新方法
 */
- (void)upadteLoading
{
}

#pragma mark -- 显示加载框
- (void)showLoading
{
    [self.targetVC showHudInSuitableView:@"加载中"];
}

#pragma mark -- 隐藏
- (void)hiddenLoading
{
    [self.targetVC hideHud];
}

- (void)autoHiddenControlView
{
    [self.avPlayControlView hiddenControlView];
}
@end

