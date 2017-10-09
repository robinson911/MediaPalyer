//
//  CHBaseViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/4/9.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "CHBaseViewController.h"

@interface CHBaseViewController ()
{
    UILabel  *_titleLable;
}
/** 返回按钮 */
@property(nonatomic,copy)UIButton *ljBackButton;
/** 左二的close按钮 */
@property(nonatomic,copy)UIButton *ljLeftSecondBtn;

@end

@implementation CHBaseViewController

#pragma mark -- life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self setTopBarImageView];
}

#pragma mark --- 自定义导航栏
- (void)setTopBarImageView
{
    if (!_topImageView)
    {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [_topImageView setBackgroundColor:[UIColor clearColor]];
        _topImageView.userInteractionEnabled = YES;
        [self.view addSubview:_topImageView];
    }

    UIImageView  *_lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 63.5, kScreenWidth, 0.5)];
    [_lineImage setBackgroundColor:[UIColor grayColor]];
    [_topImageView addSubview:_lineImage];
}

#pragma mark -- navigationBar的title设置
- (void)setTopNavBarTitle:(NSString *)title
{
    if (!_titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [_titleLable setTextColor:[UIColor blackColor]];
        _titleLable.font = [UIFont systemFontOfSize:18];
        [_titleLable setText:title];
        [_titleLable setBackgroundColor:[UIColor clearColor]];
        [_titleLable setFrame:CGRectMake(33,33,kScreenWidth - 66, 18)];
        [_topImageView addSubview:_titleLable];
    }
}

#pragma mark -- 返回按钮
/** 返回按钮*/
- (void)setTopNavBackButton
{
    UIImage *_arrowView = [UIImage imageNamed:@"goods_btn_navigationBack"];
    UIImageView *_backView = [[UIImageView alloc] initWithImage:_arrowView];
    [_backView setFrame:CGRectMake(15, 12, 12, 20)];
    
    if (!_ljBackButton)
    {
        _ljBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ljBackButton setFrame:CGRectMake(0, 20, 70, 44)];
        [_ljBackButton setBackgroundColor:[UIColor clearColor]];
        [_ljBackButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_ljBackButton addSubview:_backView];
        [self.view addSubview:_ljBackButton];
    }
}

#pragma mark -- Click action
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
