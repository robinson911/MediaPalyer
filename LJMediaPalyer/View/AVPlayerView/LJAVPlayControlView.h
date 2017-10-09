//
//  LJAVPlayControlView.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/24.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 播放或者停止*/
typedef void (^pauseOrPlayBlock)();

/** 全屏或者最小化*/
typedef void (^clickSmallOrFullScreenBlock)();

@interface LJAVPlayControlView : UIView

@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UIButton *backButton;

@property(nonatomic ,copy)void (^goBackClickedBlock)();

//进度条拖拽
@property(nonatomic ,copy)void (^stratDragSliderBlock)();

- (void)pauseOrPlayBlock:(pauseOrPlayBlock)pBlock clickSmallOrFullScreenBloc:(clickSmallOrFullScreenBlock)sBlock;

/** 重新设置frame */
- (void)reSetPlayControlView:(CGRect)frame;

/** a : yes 暂停按钮，正在播放 */
- (void)setPauseOrPlayBackImage:(BOOL)a;

- (void)setNowLabelText:(NSString*)text;

//总时间
- (void)setRemainLabelText:(NSString*)text;

//设置进度
- (void)setProgress:(float)progress;

//滑条设置进度
- (void)setSliderValue:(float)value;

- (void)setSliderMaxValue:(float)value;

/** 设置标题 */
- (void)setPlayLabelTitle:(NSString*)text;

/** 显示控制层 */
- (void)showControlView;

/** 隐藏控制层 */
- (void)hiddenControlView;

@end
