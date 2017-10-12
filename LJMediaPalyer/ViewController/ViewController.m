//
//  ViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/4/9.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "ViewController.h"
#import "LJTestView.h"
#import "BasePlayViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *ljArray;
@property(nonatomic, strong)UITableView *ljTableview;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopNavBarTitle:@"IOS Play Demo"];
    
    _ljArray = @[@"LJAVPlayViewController", @"LJMPMoviePlayerController", @"LJMPMoviePlayerViewController",@"BasePlayViewController",@"LJVedioViewController",@"LJBulletViewController"];
    
    [self.view addSubview:self.ljTableview];
    
    [self test];
}

- (void)test
{
    LJTestView *_view =  [[LJTestView alloc]initWithContent:@"我是"];
    _view.frame = CGRectMake(kScreenWidth + 50, 20 + 34 * 3, 42, 14);
    [self.view addSubview:_view];
    [_view  startAnimation];
}

- (UITableView*)ljTableview
{
    if (!_ljTableview)
    {
        _ljTableview = [[UITableView alloc]init];
        [_ljTableview setFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        _ljTableview.delegate = self;
        _ljTableview.dataSource = self;
        _ljTableview.rowHeight = 64;
    }
    return _ljTableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ljArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (_ljArray.count > 0)
    {
        cell.textLabel.text = _ljArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_ljArray.count > indexPath.row)
    {
        if (indexPath.row == 3) {
            BasePlayViewController *_vc = [[BasePlayViewController alloc]init];
            _vc.titleStr = @"测试";
            _vc.urlStr = @"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4";
            [self.navigationController pushViewController:_vc animated:YES];
        }
        else
        {
            id _vc = [[NSClassFromString(_ljArray[indexPath.row]) alloc]init];
            [self.navigationController pushViewController:_vc animated:YES];
        }
    }
}

@end
