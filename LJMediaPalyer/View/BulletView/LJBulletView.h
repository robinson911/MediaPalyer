//
//  LJBulletView.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJBulletView : UIView

@property (nonatomic, assign)int trajectory; //弹幕弹道定义

/** 数据加载*/
- (instancetype)initWithContent:(NSString *)content;
/** 开始动画*/
- (void)startAnimation;
/** 结束动画*/
- (void)stopAnimation;

@end
