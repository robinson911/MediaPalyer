//
//  LJBulletViewManager.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJBulletView;

@interface LJBulletViewManager : UIView

@property (nonatomic, copy) void(^generateBulletBlock)(LJBulletView *view);

/** 弹幕数据源*/
@property (nonatomic, strong) NSMutableArray *allCommentsArray;

#pragma mark -- 创建弹幕UI
- (void)createBulletView:(LJBulletView *)bulletView;

#pragma mark -- 弹幕开始
- (void)startBullet;

#pragma mark -- 弹幕结束
- (void)stopBullet;

@end
