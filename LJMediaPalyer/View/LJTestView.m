//
//  LJTestView.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/5/31.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJTestView.h"

#define mDuration   5
#define Padding     5

@interface LJTestView ()

//弹幕label
@property (nonatomic, strong)UILabel *ljBulletLabel;

@end

@implementation LJTestView

- (instancetype)initWithContent:(NSString *)content
{
    if (self == [super init])
    {
        self.userInteractionEnabled = NO;
        //self.backgroundColor = [UIColor redColor];
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14]
                                     };
        float width = [content sizeWithAttributes:attributes].width;
        self.bounds = CGRectMake(0, 0, width + Padding*2, 25);
        
        //添加弹幕label
        [self addSubview:self.ljBulletLabel];
        self.ljBulletLabel.frame = CGRectMake(Padding, 0, (width), 25);
        self.ljBulletLabel.text = content;
    }
    return self;
}

- (UILabel*)ljBulletLabel
{
    if (!_ljBulletLabel)
    {
        _ljBulletLabel = [[UILabel alloc]init];
        _ljBulletLabel.backgroundColor = [UIColor clearColor];
        _ljBulletLabel.font = [UIFont systemFontOfSize:14];
        _ljBulletLabel.textColor = [UIColor redColor];
    }
    return _ljBulletLabel;
}

- (void)startAnimation
{
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat wholeWidth = CGRectGetWidth(self.frame) + kScreenWidth + 20;
    //CGFloat wholeWidth = kScreenWidth;
    CGFloat speed = wholeWidth/mDuration;
    CGFloat dur = (CGRectGetWidth(self.frame) + 50)/speed;
    
    __block CGRect frame = self.frame;
    
    //弹幕完全离开屏幕
    //UIViewAnimationOptionCurveLinear ：动画匀速执行，默认值。
    [UIView animateWithDuration:mDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = - CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

- (void)stopAnimation
{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
