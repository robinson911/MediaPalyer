//
//  LJBulletViewManager.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBulletView.h"

@interface LJBulletViewManager : UIView

@property (nonatomic, copy) void(^generateBulletBlock)(LJBulletView *view);

- (void)sendDanmaku:(LJBulletView *)danmaku forceRender:(BOOL)force;

@end
