//
//  LJBulletView.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat time;
    CGFloat interval;
} HJDanmakuTime;

NS_INLINE CGFloat HJMaxTime(HJDanmakuTime time) {
    return time.time + time.interval;
}

#define cellHeight 25

@interface LJBulletView : UIView

@property (nonatomic, assign)int trajectory; //弹幕弹道定义

@property (nonatomic, assign) CGFloat px;
@property (nonatomic, assign) CGFloat py;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL force;


@property (nonatomic, assign) NSInteger toleranceCount;

//label
@property (nonatomic, strong)UILabel *ljBulletLabel;

// the line of trajectory, default -1
@property (nonatomic, assign) NSInteger yIdx;

@property (nonatomic, assign) float remainingTime;


/** 数据加载*/
- (instancetype)initWithContent:(NSString *)content;
/** 开始动画*/
- (void)startAnimation;
/** 结束动画*/
- (void)stopAnimation;

@end
