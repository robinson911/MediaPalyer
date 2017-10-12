//
//  LJBulletView.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/23.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJBulletView.h"

#define mDuration   5
#define Padding     5



@interface LJBulletView ()


@end

@implementation LJBulletView

- (void)dealloc
{
    [self stopAnimation];
}

#pragma mark -- 根据内容生成弹幕
- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = NO;
        //CGSize ljsize = [self getTextCGSize:content Font:[UIFont systemFontOfSize:14]];
        //self.bounds = CGRectMake(0, 0, ljsize.width, cellHeight);
        //self.backgroundColor = [UIColor grayColor];
        
//        CGFloat width = [content sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width + 1.0f;
        
        CGFloat width = [CHUtil getTextCGSize:content Font:loadFont(14)].width + 1.0f;
        _ljBulletLabel = [[UILabel alloc]init];
        _ljBulletLabel.backgroundColor = [UIColor clearColor];
        _ljBulletLabel.font = [UIFont systemFontOfSize:14];
        //_ljBulletLabel.textColor = [UIColor redColor];
        _ljBulletLabel.clipsToBounds = YES;
        _ljBulletLabel.layer.cornerRadius = 2;
        _ljBulletLabel.layer.borderWidth = 1;
        _ljBulletLabel.layer.borderColor = [UIColor redColor].CGColor;
        //添加弹幕label
        self.ljBulletLabel.frame = CGRectMake(0, 0, width, cellHeight);
        //self.ljBulletLabel.backgroundColor = [UIColor yellowColor];
        self.ljBulletLabel.text = content;
       
        [self addSubview:self.ljBulletLabel];
    }
    return self;
}

//- (UILabel*)ljBulletLabel
//{
//    if (!_ljBulletLabel)
//    {
//        _ljBulletLabel = [[UILabel alloc]init];
//        _ljBulletLabel.backgroundColor = [UIColor clearColor];
//        _ljBulletLabel.font = [UIFont systemFontOfSize:14];
//        //_ljBulletLabel.textColor = [UIColor redColor];
//        _ljBulletLabel.clipsToBounds = YES;
//        _ljBulletLabel.layer.cornerRadius = 2;
//        _ljBulletLabel.layer.borderWidth = 1;
//    }
//    return _ljBulletLabel;
//}

/** 开始弹幕动画*/
- (void)startAnimation
{
     //弹幕开始进入屏幕
     //[self beginMoveIn];
    
    __block CGRect frame = self.frame;

    @myWeakify(self);
    [UIView animateWithDuration:mDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        @myStrongify(self);
        
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished)
     {
         @myStrongify(self);
         
         //弹幕完全离开屏幕
         [self stopAnimation];
     }];
}

/** 结束动画*/
- (void)stopAnimation
{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

/*
//开始移入-->完全进入
- (void)beginMoveIn
{
    __block CGRect frame = self.frame;
    
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat wholeWidth = CGRectGetWidth(self.frame) + kScreenWidth;
    CGFloat speed = wholeWidth/mDuration;
    
    //完全进入的移动的时间
    CGFloat realMoveInDur = (CGRectGetWidth(self.frame))/speed;
    NSLog(@"----%f",realMoveInDur);
    
    @myWeakify(self);
    [UIView animateWithDuration:realMoveInDur delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        @myStrongify(self);
        
        frame.origin.x = kScreenWidth - CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished)
     {
        @myStrongify(self);
         //弹幕完全进入屏幕
         [self enterIn];
     }];
}

//完全进入-->完全移出
- (void)enterIn
{
    __block CGRect frame = self.frame;
    
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat wholeWidth = CGRectGetWidth(self.frame) + kScreenWidth;
    CGFloat speed = wholeWidth/mDuration;
    //计算移动的时间
    CGFloat realALLDur = kScreenWidth/speed;
    NSLog(@"----%f",realALLDur);
    
    @myWeakify(self);
    [UIView animateWithDuration:realALLDur delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        @myStrongify(self);
        
        frame.origin.x = -CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished)
     {
        @myStrongify(self);
         
         //弹幕完全离开屏幕
         [self stopAnimation];
     }];
}*/



@end
