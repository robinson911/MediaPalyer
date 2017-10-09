//
//  UIViewController+HUD.h
//  CommonDemo
//
//  Created by 孙伟伟 on 15/10/20.
//  Copyright © 2015年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

//覆盖整个window
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

//不覆盖导航条
- (void)showHudInSuitableView:(NSString *)hint;

//不覆盖导航条和tabbar
- (void)showHudInSuitableMidView:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showSuccessHint:(NSString *)hint yOffset:(float)yOffset;

@end
