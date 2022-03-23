//
//  ZPTestViewController.m
//  ZPAVPlayer_Example
//
//  Created by yy on 2022/3/23.
//  Copyright © 2022 WZPScroll. All rights reserved.
//

#import "ZPTestViewController.h"
#import "ZPVideoPlayerView.h"

@interface ZPTestViewController ()<ZPVideoPlayerViewDelegate>

@property (nonatomic,strong) ZPVideoPlayerView * playerView;
@property (nonatomic,assign) BOOL statusBarHidden;

@end

#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define ScreenH ([[UIScreen mainScreen] bounds].size.height)// 屏幕高度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6

@implementation ZPTestViewController

- (BOOL)prefersStatusBarHidden{
    return self.statusBarHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.playerView];
    self.playerView.url = @"https://media.w3.org/2010/05/sintel/trailer.mp4";

}

#pragma mark - ZPVideoPlayerViewDelegate
- (void)fullScreenWithPlayerView:(ZPVideoPlayerView *)playerView{
    if (self.playerView.full == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformRotate(transform, M_PI_2);
            self.playerView.transform = transform;
            self.playerView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
            [self.playerView resetPlayerViewWithFull:YES];
        } completion:^(BOOL finished) {
            [self.playerView showController];//显示按钮
            self.statusBarHidden = YES;//隐藏状态栏
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [self prefersStatusBarHidden];
                [self setNeedsStatusBarAppearanceUpdate];
            }
        }];
    }
}
- (void)smallScreenWithPlayerView:(ZPVideoPlayerView *)playerView{
    if (self.playerView.full == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            self.playerView.transform = CGAffineTransformIdentity;
            self.playerView.frame = CGRectMake(0, [self navHeight], ScreenW, kP6(210));
            [self.playerView resetPlayerViewWithFull:NO];
        } completion:^(BOOL finished) {
            [self.playerView showController];//显示按钮
            self.statusBarHidden = NO;//显示状态栏
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [self prefersStatusBarHidden];
                [self setNeedsStatusBarAppearanceUpdate];
            }
        }];
    }
}
- (void)playFinishedWithPlayerView:(ZPVideoPlayerView *)playerView{
    NSLog(@"播放完成");
}
- (void)stopAndBackWithPlayerView:(ZPVideoPlayerView *)playerView{
    NSLog(@"返回上一页");
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)navHeight{
    CGFloat statusBarHeight = 20;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight + 44;
}
#pragma mark - 懒加载
- (ZPVideoPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[ZPVideoPlayerView alloc] initWithFrame:CGRectMake(0, [self navHeight], ScreenW, kP6(210))];
        _playerView.delegate = self;
        _playerView.type = 1;//播放视频
        [_playerView resetWhenNavigationViewShow];
    }
    return _playerView;
}

@end
