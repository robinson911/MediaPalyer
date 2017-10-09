//
//  LJAVPlayView.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJAVPlayControlView.h"

@interface LJAVPlayView : UIView

@property(nonatomic,copy)void (^isPalyingBullet)(BOOL flag);

@property(nonatomic,copy)void (^fullClickedPalying)(BOOL isFull);

@property (nonatomic,strong) LJAVPlayControlView *avPlayControlView;

/*播放地址*/
@property(nonatomic,copy)NSString *urlStr;

/*标题**/
@property(nonatomic,copy)NSString *titleStr;

@property(nonatomic,weak)UIViewController *targetVC;

/**
 *  BOOL值判断当前的状态
 */
@property (nonatomic,assign ) BOOL            isFullscreen;

/**
 *  BOOL值判断当前的状态
 */
@property (nonatomic,assign ) BOOL            isFullState;

/**
 *  全屏显示播放
 ＊ @param interfaceOrientation 方向
 ＊ @param player 当前播放器
 ＊ @param fatherView 当前父视图
 **/
- (void)showFullScreenWithplay:(LJAVPlayView *)player
                   Orientation:(UIInterfaceOrientation)interfaceOrientation
                 withSuperView:(UIView *)fatherView;
/**
 *  小屏幕显示播放
 ＊ @param player 当前播放器
 ＊ @param fatherView 当前父视图
 ＊ @param playerFrame 小屏幕的Frame
 **/
- (void)showSmallScreenWithPlayer:(LJAVPlayView *)player
                    withSuperView:(UIView *)fatherView
                        withFrame:(CGRect)playerFrame;

- (void)resetAvPlayControlViewFrame;
//释放
- (void)releaseAVPlayer;

- (void)play;

- (void)pause;
@end
