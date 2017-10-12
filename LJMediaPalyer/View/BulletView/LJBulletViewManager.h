//
//  LJBulletViewManager.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBulletView.h"

@class LJBulletView;

@interface LJBulletViewManager : UIView

@property (nonatomic, copy) void(^generateBulletBlock)(LJBulletView *view);

#pragma mark -- 最后一步渲染-----显示
- (BOOL)renderNewDanmaku:(LJBulletView *)danmakuAgent forTime:(HJDanmakuTime)time;

- (void)sendDanmaku:(LJBulletView *)danmaku forceRender:(BOOL)force;

@end
