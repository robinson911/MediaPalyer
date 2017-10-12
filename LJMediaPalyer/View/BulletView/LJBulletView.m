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

@implementation LJBulletView

#pragma mark -- 根据内容生成弹幕
- (instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = NO;
        CGFloat width = [CHUtil getTextCGSize:content Font:loadFont(14)].width + 1.0f;
        _ljBulletLabel = [[UILabel alloc]init];
        _ljBulletLabel.backgroundColor = [UIColor clearColor];
        _ljBulletLabel.font = [UIFont systemFontOfSize:14];
        _ljBulletLabel.clipsToBounds = YES;
        _ljBulletLabel.layer.cornerRadius = 2;
        _ljBulletLabel.layer.borderWidth = 1;
        _ljBulletLabel.layer.borderColor = [UIColor redColor].CGColor;
        //添加弹幕label
        _ljBulletLabel.frame = CGRectMake(0, 0, width, CellHeight);
        //self.ljBulletLabel.backgroundColor = [UIColor yellowColor];
        _ljBulletLabel.text = content;
       
        [self addSubview:_ljBulletLabel];
    }
    return self;
}

@end
