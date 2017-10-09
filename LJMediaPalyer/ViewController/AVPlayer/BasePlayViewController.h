//
//  BaseAVPlayViewController.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/8.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "CHBaseViewController.h"

@interface BasePlayViewController : CHBaseViewController

/*播放地址*/
@property(nonatomic,copy)NSString *urlStr;

/*标题**/
@property(nonatomic,copy)NSString *titleStr;

@end
