//
//  VedioTableViewCell.h
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/8.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VedioModel.h"

@interface VedioTableViewCell : UITableViewCell

@property(nonatomic,strong)VedioModel *model;

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIButton *playBtn;
@property(nonatomic, strong)UIImageView *vedioBackView;

@property(nonatomic,copy)void (^vedioClickBlock)(VedioModel *model);

@property(nonatomic,copy)void (^onClickVideoPlayBlock)(VedioModel *model,UIButton *sender);

@end
