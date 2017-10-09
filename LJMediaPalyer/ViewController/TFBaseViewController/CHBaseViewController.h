//
//  CHBaseViewController.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/4/9.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHBaseViewController : UIViewController
{
   UIImageView *_topImageView;
}

/** 设置自定义导航栏的title */
- (void)setTopNavBarTitle:(NSString *)title;

/** 设置自定义导航栏的返回按钮（默认灰色）*/
- (void)setTopNavBackButton;

#pragma mark -- 点击事件
- (void)backButtonClick;


@end
