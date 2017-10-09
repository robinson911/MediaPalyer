//
//  LJVedioViewController.m
//  LJMediaPalyer
//
//  Created by 孙伟伟 on 2017/10/8.
//  Copyright © 2017年 孙伟伟. All rights reserved.
//

#import "LJVedioViewController.h"
#import "VedioTableViewCell.h"
#import "VedioModel.h"
#import "BasePlayViewController.h"
#import "LJAVPlayView.h"

@interface LJVedioViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    VedioModel *currentModel;
    NSIndexPath *currentIndexPath;
}
@property(nonatomic, strong)LJAVPlayView *vedioPlayer;
@property(nonatomic, strong)NSMutableArray *ljArray;
@property(nonatomic, strong)UITableView *ljTableview;

@end

@implementation LJVedioViewController

- (void)dealloc
{
    NSLog(@"LJVedioViewController-----dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopNavBarTitle:@"IOS Play Demo"];
    
    [self setTopNavBackButton];
    
    [self.view addSubview:self.ljTableview];
}

/**
 * Lazy 加载数据
 **/
- (NSArray *)ljArray {
    if (!_ljArray) {
        _ljArray = [[NSMutableArray alloc]init];
    }
//    NSString *path3gp = [[NSBundle mainBundle] pathForResource:@"贝加尔湖畔" ofType:@"3gp"];
    NSArray *arr = @[
                     
                     //@"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4" movieTitle:@"爱情动作片"
                     // @"http://flv2.bn.netease.com/videolib3/1609/12/yRxoB7561/SD/yRxoB7561-mobile.mp4"
                     @{@"title":@"视频一 mp4 格式",
                       @"image":@"http://vimg3.ws.126.net/image/snapshot/2016/9/L/1/VBVQVQRL1.jpg",
                       @"video":@"http://baobab.wdjcdn.com/1455969783448_5560_854x480.mp4"},
                     
                     @{@"title":@"视频二 m3u8格式",
                       @"image":@"http://vimg2.ws.126.net/image/snapshot/2016/9/7/7/VBV4B7Q77.jpg",
                       @"video":@"http://flv2.bn.netease.com/videolib3/1609/03/WotPc9077/SD/movie_index.m3u8"},
                     
                     @{@"title":@"视频三 mov格式",
                       @"image":@"http://img2.cache.netease.com/m/3g/mengchong.png",
                       @"video":@"http://movies.apple.com/media/us/iphone/2010/tours/apple-iphone4-design_video-us-20100607_848x480.mov"},
                     
//                     @{@"title":@"视频四 3gp格式",
//                       @"image":@"http://wimg.spriteapp.cn/picture/2016/0309/56df7b64b4416_wpd.jpg",
//                       @"video":path3gp},
                     
                     @{@"title":@"视频五",
                       @"image":@"http://vimg3.ws.126.net/image/snapshot/2016/9/A/G/VBV4BB5AG.jpg",
                       @"video":@"http://flv2.bn.netease.com/videolib3/1609/03/GVRLQ8933/SD/movie_index.m3u8"},
                     
                     @{@"title":@"视频六",
                       @"image":@"http://vimg3.ws.126.net/image/snapshot/2016/9/5/1/VBV4BEH51.jpg",
                       @"video":@"http://flv2.bn.netease.com/videolib3/1609/03/lGPqA9142/SD/lGPqA9142-mobile.mp4"},
                     
                     @{@"title":@"视频七",
                       @"image":@"http://vimg3.ws.126.net/image/snapshot/2016/9/U/R/VBVQV83UR.jpg",
                       @"video":@"http://flv2.bn.netease.com/videolib3/1609/12/aOzvT5225/HD/movie_index.m3u8"},
                     ];
    
    NSMutableArray *arrVideo = [NSMutableArray array];
    for (NSDictionary *video in arr) {
        VedioModel *ljvideo = [[VedioModel alloc] init];
        ljvideo.title = [video objectForKey:@"title"];
        ljvideo.imageUrlstr = [video objectForKey:@"image"];
        ljvideo.videoUrlStr = [video objectForKey:@"video"];
        [arrVideo addObject:ljvideo];
    }
    [_ljArray addObjectsFromArray: arrVideo];
    return _ljArray;
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
    return self.ljArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cellid";
    VedioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[VedioTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (self.ljArray.count > 0)
    {
        cell.model =  _ljArray[indexPath.row];
        cell.playBtn.tag = indexPath.row;
        [self dequeueReusableCell:cell indexPath:indexPath];
        
        //1.点击整张图片跳转
        @myWeakify(self);
        [cell setVedioClickBlock:^(VedioModel *model){
            @myStrongify(self);
            BasePlayViewController *_vc = [[BasePlayViewController alloc]init];
            _vc.titleStr = model.title;
            _vc.urlStr = model.videoUrlStr;
            [self.navigationController pushViewController:_vc animated:YES];
        }];
        
        //2.点击播放按钮
        [cell setOnClickVideoPlayBlock:^(VedioModel *model, UIButton *sender)
        {
            @myStrongify(self);
            [self closeCurrentCellVedioPlayer];
            
            currentModel = model;
            currentIndexPath = [NSIndexPath indexPathForRow:cell.playBtn.tag inSection:0];
            VedioTableViewCell *cell = nil;
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8||[UIDevice currentDevice].systemVersion.floatValue < 7)
            {
                cell = (VedioTableViewCell *)sender.superview.superview;
            }
            else
            {//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
                cell = (VedioTableViewCell *)sender.superview.superview.subviews;
            }
            
            //先销毁，再重建
            [self releasePlayer];
            self.vedioPlayer = [[LJAVPlayView alloc]initWithFrame:cell.vedioBackView.bounds];
            self.vedioPlayer.titleStr = model.title;
            self.vedioPlayer.urlStr = model.videoUrlStr;
            self.vedioPlayer.targetVC = self;
            [self.vedioPlayer.avPlayControlView.backButton setHidden:YES];
            @myWeakify(self);
            [self.vedioPlayer setFullClickedPalying:^(BOOL isFull){
                @myStrongify(self);
                if (!isFull) {//已经是小屏幕变成全屏了
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self.vedioPlayer showFullScreenWithplay:self.vedioPlayer Orientation:UIInterfaceOrientationLandscapeLeft withSuperView:self.view];
                }
                else
                {
                    //[self setNeedsStatusBarAppearanceUpdate];
                    //[vedioPlayer showFullScreenWithplay:vedioPlayer Orientation:UIInterfaceOrientationLandscapeLeft withSuperView:self.view];
                    self.vedioPlayer.isFullState = NO;
                    if (currentModel != nil &&  currentIndexPath != nil)
                    {
                        VedioTableViewCell *currentCell = [self currentCell];
                        [self.vedioPlayer removeFromSuperview];
                        
                        [UIView animateWithDuration:0.5f animations:^{
                            self.vedioPlayer.transform = CGAffineTransformIdentity;
                            self.vedioPlayer.frame = currentCell.vedioBackView.bounds;
                            [self.vedioPlayer resetAvPlayControlViewFrame];
                            [currentCell.vedioBackView addSubview:self.vedioPlayer];
                            [currentCell.vedioBackView bringSubviewToFront:self.vedioPlayer];
                        }completion:^(BOOL finished) {
                            self.vedioPlayer.isFullscreen = NO;
                            [self setNeedsStatusBarAppearanceUpdate];
                        }];
                    }
                }
            }];
            
            [cell.vedioBackView addSubview:self.vedioPlayer];
            [cell.vedioBackView bringSubviewToFront:self.vedioPlayer];
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
            [self.ljTableview reloadData];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_ljArray.count > indexPath.row)
    {
        id _vc = [[NSClassFromString(_ljArray[indexPath.row]) alloc]init];
        [self.navigationController pushViewController:_vc animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)dequeueReusableCell:(VedioTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (self.vedioPlayer && self.vedioPlayer.superview) {
        if (indexPath.row == currentIndexPath.row)
        {//隐藏播放按钮
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
        }
        else
        {//显示播放按钮
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        
        NSArray *indexpaths = [self.ljTableview indexPathsForVisibleRows];
        if (![indexpaths containsObject:currentIndexPath] && currentIndexPath != nil)
        { //复用机制
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.vedioPlayer])
            {
                self.vedioPlayer.hidden = NO;
            }
            else
            {
                self.vedioPlayer.hidden = YES;
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
        }
        else
        {
            if ([cell.vedioBackView.subviews containsObject:self.vedioPlayer]) {
                //当滑倒所属当前视频的时候自动播放
                [cell.vedioBackView addSubview:self.vedioPlayer];
                [self.vedioPlayer play];
                self.vedioPlayer.hidden = NO;
            }
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    if (self.vedioPlayer)
    {
        if (self.vedioPlayer.isFullState)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

/**
 *  注销播放器
 **/
- (void)releasePlayer
{
    if (self.vedioPlayer)
    {
       [self.vedioPlayer releaseAVPlayer];
       self.vedioPlayer = nil;
    }
}

- (VedioTableViewCell *)currentCell
{
    if (!currentIndexPath) return nil;
    VedioTableViewCell *currentCell = (VedioTableViewCell *)[self.ljTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    return currentCell;
}

/**
 * 关闭当前cell 中的 视频
 **/
- (void)closeCurrentCellVedioPlayer{
    
    if (currentModel != nil &&  currentIndexPath != nil) {
        VedioTableViewCell *currentCell = [self currentCell];
        [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
        [self.vedioPlayer removeFromSuperview];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
