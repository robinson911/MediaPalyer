//
//  VedioTableViewCell.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/8.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "VedioTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface VedioTableViewCell()

@end

@implementation VedioTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView  addSubview:self.titleLabel];
        [self.contentView  addSubview:self.vedioBackView];
        [self.contentView  addSubview:self.playBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(VedioModel *)model
{
     _model = model;

     self.titleLabel.text  = model.title;
     self.titleLabel.frame = CGRectMake(10, 0 , kScreenWidth - 10*2, 30);
     self.vedioBackView.frame =  CGRectMake(0, self.titleLabel.frame.size.height , kScreenWidth,200);
     [self.vedioBackView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlstr] placeholderImage:[UIImage imageNamed:@"PlayerBackground"]];
}

- (void)onClickVideoPlay:(UIButton *)sender
{
    if (self.onClickVideoPlayBlock) {
        self.onClickVideoPlayBlock(_model,sender);
    }
}

- (void)vedioBgTapGesture:(id)sender
{
    if (self.vedioClickBlock) {
        self.vedioClickBlock(_model);
    }
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
        _titleLabel.contentMode= UIViewContentModeTop;
    }
    return _titleLabel;
}

- (UIImageView*)vedioBackView
{
    if(!_vedioBackView)
    {
        _vedioBackView= [[UIImageView alloc]init];
        _vedioBackView.contentMode = UIViewContentModeScaleToFill;
        _vedioBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *panGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vedioBgTapGesture:)];
        _vedioBackView.userInteractionEnabled = YES;
        [_vedioBackView addGestureRecognizer:panGesture];
    }
    return _vedioBackView;
}

- (UIButton*)playBtn
{
    if (!_playBtn)
    {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"ic_bofang-big"]  forState:UIControlStateNormal];
        [_playBtn adjustsImageWhenHighlighted];
        [_playBtn adjustsImageWhenDisabled];
        _playBtn.backgroundColor = [UIColor clearColor];
        _playBtn.imageView.contentMode = UIViewContentModeCenter;
        [_playBtn addTarget:self action:@selector(onClickVideoPlay:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.frame = CGRectMake((kScreenWidth - 72)/2, (230 - 72)/2  , 72, 72);
    }
    return _playBtn;
}

@end
