//
//  LJAVPlayControlView.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/24.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJAVPlayControlView.h"

@interface LJAVPlayControlView ()

/** 是否拖动Slider */
@property (nonatomic,assign) BOOL isDragSlider;

/** 顶部View （close button  和  title） */
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *playTitleLabel;

/** 底部BottmView */
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *playButton;
@property (nonatomic,strong) UIButton *fullScreenButton;
//@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *nowLabel;
@property (nonatomic,strong) UILabel *remainLabel;
//@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIProgressView *progressView;

@property(nonatomic, copy)clickSmallOrFullScreenBlock  smallOrFullScreenBlock;
@property(nonatomic, copy)pauseOrPlayBlock pausePlayBlock;

@end

@implementation LJAVPlayControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
#warning 重新设置中间区域的frame
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap];

        [self createControlUI];
    }
    return self;
}

/** 创建视屏上面的控制UI */
- (void)createControlUI
{
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self.topView    addSubview:self.playTitleLabel];
    [self.topView    addSubview:self.backButton];
    [self.bottomView addSubview:self.playButton];
    [self.bottomView addSubview:self.fullScreenButton];
    [self.bottomView addSubview:self.slider];
    [self.bottomView addSubview:self.progressView];
    [self.bottomView sendSubviewToBack:self.progressView];
    [self.bottomView addSubview:self.nowLabel];
    [self.bottomView addSubview:self.remainLabel];
}

- (void)reSetPlayControlView:(CGRect)frame
{
    self.frame = frame;
    [_topView setFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
    _bottomView.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
    
    UIImage *image = [UIImage imageNamed:@"gobackBtn"];
    _backButton.frame = CGRectMake(12, (44 - image.size.height)/2.0, image.size.width, image.size.height);
    
    _playTitleLabel.frame = CGRectMake(0, (44 - 17)/2.0, self.topView.bounds.size.width, 17);
    _playButton.frame = CGRectMake(5, 0, 50, 50);
    _fullScreenButton.frame = CGRectMake(self.bottomView.bounds.size.width - 35, 10, 30, 30);
    _slider.frame = CGRectMake(45, 24, self.bottomView.bounds.size.width - 90, 2);
    _progressView.frame = CGRectMake(46, 24, self.bottomView.bounds.size.width - 91, 2);
    _nowLabel.frame = CGRectMake(45, 27, 100, 20);
    _remainLabel.frame = CGRectMake(self.bottomView.bounds.size.width - 46 - 70, 27, 70, 20);
}

#pragma mark -- UI
- (UIView*)topView
{
    if (!_topView)
    {
        // 顶部栏
        _topView = [[UIView alloc] init];
        [_topView setFrame:CGRectMake(0, 20, self.frame.size.width, 44)];
    }
    return _topView;
}

- (UIView*)bottomView
{
    if (!_bottomView)
    {
        // 底部栏
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
        _bottomView.userInteractionEnabled = YES;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _bottomView;
}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        UIImage *image = [UIImage imageNamed:@"gobackBtn"];
        _backButton = [[UIButton alloc]init];
        _backButton.frame = CGRectMake(12, (44 - image.size.height)/2.0, image.size.width, image.size.height);
        [_backButton setBackgroundImage:image forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(ljBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel*)playTitleLabel
{
    if (!_playTitleLabel)
    {
        // 顶部Label
        _playTitleLabel = [[UILabel alloc] init];
        _playTitleLabel.textAlignment = NSTextAlignmentCenter;
        _playTitleLabel.textColor = [UIColor whiteColor];
        _playTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _playTitleLabel.frame = CGRectMake(0, (44 - 17)/2.0, self.topView.bounds.size.width, 17);
    }
    return _playTitleLabel;
}

- (UIButton*)playButton
{
    if (!_playButton)
    {
        // 底部pause或者play
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(5, 0, 50, 50);
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _playButton.showsTouchWhenHighlighted = YES;
        [_playButton addTarget:self action:@selector(pauseOrPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton*)fullScreenButton
{
    if (!_fullScreenButton)
    {
        // 底部全屏按钮
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.frame = CGRectMake(self.bottomView.bounds.size.width - 35, 10, 30, 30);
        [_fullScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.showsTouchWhenHighlighted = YES;
        [_fullScreenButton addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UISlider*)slider
{
    if (!_slider)
    {
        // 底部进度条
        _slider = [[UISlider alloc] init];
        _slider.frame = CGRectMake(45, 24, self.bottomView.bounds.size.width - 90, 2);
        _slider.minimumValue = 0.0;
        _slider.minimumTrackTintColor = [UIColor greenColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.value = 0.0;
        [_slider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderDragValueChange:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTapValueChange:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSlider:)];
        [_slider addGestureRecognizer:tapSlider];
    }
    return _slider;
}

- (UIProgressView*)progressView
{
    if (!_progressView)
    {
        // 底部缓存进度条
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        [_progressView setProgress:0.0 animated:NO];
        _progressView.frame = CGRectMake(46, 24, self.bottomView.bounds.size.width - 91, 2);
    }
    return _progressView;
}

- (UILabel*)nowLabel
{
    if (!_nowLabel)
    {
        // 底部左侧时间轴
        _nowLabel = [[UILabel alloc] init];
        _nowLabel.textColor = [UIColor whiteColor];
        _nowLabel.font = [UIFont systemFontOfSize:13];
        _nowLabel.textAlignment = NSTextAlignmentLeft;
        _nowLabel.frame = CGRectMake(45, 27, 100, 20);
    }
    return _nowLabel;
}

- (UILabel*)remainLabel
{
    if (!_remainLabel)
    {
        // 底部右侧时间轴
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.textColor = [UIColor whiteColor];
        _remainLabel.font = [UIFont systemFontOfSize:13];
        _remainLabel.textAlignment = NSTextAlignmentRight;
        _remainLabel.frame = CGRectMake(self.bottomView.bounds.size.width - 46 - 70, 27, 70, 20);
    }
    return _remainLabel;
}

- (void)setNowLabelText:(NSString*)text
{
   self.nowLabel.text = text;
}

- (void)setRemainLabelText:(NSString*)text
{
    self.remainLabel.text = text;
}

- (void)setSliderValue:(float)value
{
    [self.slider setValue:value];
}

- (void)setSliderMaxValue:(float)value
{
    [self.slider setMaximumValue:value];
}

- (void)setPlayLabelTitle:(NSString*)text
{
    [self.playTitleLabel setText:text];
}

- (void)pauseOrPlayBlock:(pauseOrPlayBlock)pBlock clickSmallOrFullScreenBloc:(clickSmallOrFullScreenBlock)sBlock
{
    self.pausePlayBlock = pBlock;
    self.smallOrFullScreenBlock = sBlock;
}

#pragma mark
#pragma mark - 暂停或者播放
- (void)pauseOrPlay:(id)sender
{
    if (self.pausePlayBlock)
    {
        self.pausePlayBlock();
    }
}

//全屏
- (void)clickFullScreen
{
    if (self.smallOrFullScreenBlock)
    {
        self.smallOrFullScreenBlock();
    }
}

- (void)ljBackBtnClicked
{
    //移除window上的视图，然后再pop
    if (self.goBackClickedBlock)
    {
        self.goBackClickedBlock();
    }
    UIViewController *topmostVC = [self topViewController];
    [topmostVC.navigationController popViewControllerAnimated:YES];
}

- (void)setPauseOrPlayBackImage:(BOOL)a
{
        if (a)
        {
            [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
        else
        {
            [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
}

- (void)setProgress:(float)progress
{
    [self.progressView setProgress:progress animated:NO];
}

#pragma mark -- slider的更改
// 拖拽的时候调用  这个时候不更新视频进度
- (void)sliderDragValueChange:(UISlider *)slider
{
    if (self.stratDragSliderBlock) {
        self.stratDragSliderBlock();
    }
}

// 点击调用  或者 拖拽完毕的时候调用
- (void)sliderTapValueChange:(UISlider *)slider
{
 
}

// 点击事件的Slider
- (void)touchSlider:(UITapGestureRecognizer *)tap
{

}

#pragma mark - 单击手势
- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:1.0 animations:^{
        if (self.bottomView.alpha == 1)
        {
            self.bottomView.alpha = 0;
            self.topView.alpha = 0;
        }
        else if (self.bottomView.alpha == 0)
        {
            self.bottomView.alpha = 1.0f;
            self.topView.alpha = 1.0f;
        }
    }];
}

#pragma mark -- 显示和隐藏控制栏有一个逐渐消失的效果
- (void)hiddenControlView
{
    //[self.topView setHidden:YES];
    //[self.bottomView setHidden:YES];
    [UIView animateWithDuration:1.0 animations:^{
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
    }];
}

- (void)showControlView
{
    //[self.topView setHidden:NO];
    //[self.bottomView setHidden:NO];
    
    if (self.bottomView.alpha == 1)
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.bottomView.alpha = 0;
            self.topView.alpha = 0;
        }];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController)
    {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else
    {
        return vc;
    }
    return nil;
}

@end
