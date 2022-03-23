//
//  ZPVideoPlayerView.m
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import "ZPVideoPlayerView.h"
#import <AVKit/AVKit.h>
#import "ZPVideoController.h"
#import "ZPVideoController2.h"
#import "ZPVideoErrorView.h"
#import "ZPImageBtn.h"

@interface ZPVideoPlayerView ()

@property (nonatomic,strong) AVPlayerItem * videoItem;
@property (nonatomic,strong) AVPlayer * player;//
@property(nonatomic,strong)AVPlayerLayer * playerLayer;//
@property (nonatomic,strong) UIImageView * contentView;
@property (nonatomic,strong) ZPVideoController * controller;
@property (nonatomic,strong) ZPVideoController2 * controller2;
@property (nonatomic,assign) BOOL full;//是否是全屏
@property (nonatomic,assign) NSInteger totalTime;
@property (nonatomic,assign) float progress;//播放进度
@property (nonatomic,strong) AVPlayerItemVideoOutput * outPut;
@property (nonatomic,strong) ZPVideoErrorView * errorView;
@property (nonatomic,assign) BOOL showNav;


@end

#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define ScreenH ([[UIScreen mainScreen] bounds].size.height)// 屏幕高度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6
#define ImageName(string) [UIImage imageNamed:string]//设置图片
#define DefaultFontName @"PingFang-SC-Regular"
#define ZPColorACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0 alpha:(a)]

@implementation ZPVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.contentView];
        [self addSubview:self.errorView];
        _full = NO;
    }
    return self;
}
//当播放器位置在NavigationView下时需修改UI
- (void)resetWhenNavigationViewShow{
    self.showNav = YES;
    _controller.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}
//获取直播最后一帧
- (UIImage *)getLastImage{
    CMTime currentTime = self.videoItem.currentTime;
    CVPixelBufferRef pixelBuffer = [self.outPut copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage
                                                   fromRect:CGRectMake(0, 0,
                                                                       CVPixelBufferGetWidth(pixelBuffer),
                                                                       CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *frameImg = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    //不释放会造成内存泄漏
    CVBufferRelease(pixelBuffer);
    return frameImg;
}
//直播不正常
- (void)showErrorView{
    self.errorView.hidden = NO;
}
- (void)hiddenErrorView{
    self.errorView.hidden = YES;
}
- (void)resetPlayerViewWithFull:(BOOL)full{
    [self hiddenController];
    if (full) {
        CGFloat width = ScreenW/375*667;
        CGFloat left = ScreenH/2 - width/2;
        self.contentView.frame = CGRectMake(left, 0, width, ScreenW);
        self.errorView.frame = CGRectMake(left, 0, width, ScreenW);
        if (_type == 1) {
            self.controller.frame = CGRectMake(left, 0, width, ScreenW);
        }else if (_type == 2) {
            self.controller2.frame = CGRectMake(left, 0, width, ScreenW);
        }
    }else{
        CGFloat height = self.frame.size.height;
        if ([self isFullScreen] &&
            height == ScreenH) {
            height = self.frame.size.height - [self statusBarHeight] - [self touchHeight];
        }else{
            height = self.frame.size.height - [self statusBarHeight];
        }
        CGFloat top = [self statusBarHeight];
        if (self.showNav) {
            height = kP6(210);
            top = 0;
        }
        CGRect smallFrame = CGRectMake(0, top, self.frame.size.width, height);
        self.contentView.frame = smallFrame;
        self.errorView.frame = smallFrame;
        if (_type == 1) {
            self.controller.frame = smallFrame;
        }else if (_type == 2) {
            self.controller2.frame = smallFrame;
        }
    }
    if (self.playerLayer) {
        self.playerLayer.frame = self.contentView.bounds;
    }
}
- (void)back{
    if (_full) {//全屏状态下变为缩小
        self.controller.fullBtn.imageV.image = [self imageWithName:@"full_icon"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(smallScreenWithPlayerView:)]) {
            [self.delegate smallScreenWithPlayerView:self];
        }
        _full = NO;
    }else{//非全屏返回
        self.controller.playBtn.imageV.image = [self imageWithName:@"play_icon"];
        [self.player pause];
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopAndBackWithPlayerView:)]) {
            [self.delegate stopAndBackWithPlayerView:self];
        }
    }
}
- (void)fullScreen{
    if (!_full) {
        self.controller.fullBtn.imageV.image = [self imageWithName:@"small_icon"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenWithPlayerView:)]) {
            [self.delegate fullScreenWithPlayerView:self];
        }
    }else{
        self.controller.fullBtn.imageV.image = [self imageWithName:@"full_icon"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(smallScreenWithPlayerView:)]) {
            [self.delegate smallScreenWithPlayerView:self];
        }
    }
    _full = !_full;
}
//点击播放或暂停
- (void)playVideo{
    if (self.totalTime == 0) {
        return;
    }
    BOOL selected = self.controller.playBtn.selected;
    if (!selected) {
        self.controller.playBtn.imageV.image = [self imageWithName:@"stop_icon"];
        [self.player play];
    }else{
        self.controller.playBtn.imageV.image = [self imageWithName:@"play_icon"];
        [self.player pause];
    }
    self.controller.playBtn.selected = !selected;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.controller hiddenControlerWithAnimate:YES];
    });
}
//拖动进度
- (void)sliderValueChange:(UISlider *)slider{
    float value = slider.value;
    
    [self pause];
    NSInteger currentSecond = self.totalTime * value;
    
    self.controller.currentTime = currentSecond;
    AVPlayerItem * item = self.player.currentItem;
    
    NSInteger a = currentSecond * 60;//按每秒60帧算，播放第几帧
    [item seekToTime:CMTimeMake(a, 60) toleranceBefore:CMTimeMake(1, 60) toleranceAfter:CMTimeMake(1, 60) completionHandler:^(BOOL finished) {
        
    }];
}



- (void)showController{
    if (_type == 1) {
        [self.controller showControlerWithAnimate:NO];
    }else if (_type == 2) {
        [self.controller2 showControlerWithAnimate:NO];
    }
}
- (void)hiddenController{
    if (_type == 1) {
        [self.controller hiddenControlerWithAnimate:NO];
    }else if (_type == 2) {
        [self.controller2 hiddenControlerWithAnimate:NO];
    }
}
//隐藏全屏按钮
- (void)hiddenFullBtn{
    if (_type == 1) {
        self.controller.fullBtn.hidden = YES;
    }else if (_type == 2) {
        self.controller2.fullBtn.hidden = YES;
    }
}

//停止播放
- (void)pause{
    self.controller.playBtn.imageV.image = [self imageWithName:@"play_icon"];
    self.controller.playBtn.selected = NO;
    [self.player pause];
}
//开始播放
- (void)start{
    if (self.totalTime == 0) {
        return;
    }
    self.controller.playBtn.imageV.image = [self imageWithName:@"stop_icon"];
    self.controller.playBtn.selected = YES;
    [self.player play];
}
- (void)setType:(NSInteger)type{
    _type = type;
    if (_type == 1) {
        [self addSubview:self.controller];
    }else if (_type == 2) {
        [self addSubview:self.controller2];
    }
}
- (void)setUrl:(NSString *)url{
    _url = url;
//    self.contentView.image = [self getImageWithVideoUrl:_url];
    NSString * newUrl = url;
    if ([self hasChineseChar:newUrl]) {//对中文进行处理
        NSCharacterSet *encode_set= [NSCharacterSet URLQueryAllowedCharacterSet];
        newUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:encode_set];
    }
    self.videoItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:newUrl]];
    self.outPut = [[AVPlayerItemVideoOutput alloc] init];
    [self.videoItem addOutput:self.outPut];
    _player = [AVPlayer playerWithPlayerItem:self.videoItem];
    
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = self.contentView.bounds;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        [self.contentView.layer addSublayer:_playerLayer];
    }else{
        _playerLayer.player = _player;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    if (_type == 1) {//回看
        //获取视频的时长
        NSInteger duration = CMTimeGetSeconds(self.player.currentItem.asset.duration);
        NSLog(@"%ld",duration);
        self.controller.totalTime = duration;
        self.totalTime = duration;
        if (self.totalTime == 0) {
            [self showErrorView];
        }else{
            [self hiddenErrorView];
        }
        //添加播放进度监听
        __weak typeof(self) weakSelf=self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            NSInteger currentSecond = time.value/time.timescale;
            weakSelf.controller.currentTime = currentSecond;
            NSLog(@"%ld",currentSecond);
        }];
    }else if (_type == 2) {//直播
        [self.player play];
    }
    
}
//播放完成的回调
- (void)playbackFinished:(NSNotification *)noti{
    AVPlayerItem * p = [noti object];
    //关键代码
    [p seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        self.controller.playBtn.imageV.image = [self imageWithName:@"play_icon"];
        self.controller.playBtn.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playFinishedWithPlayerView:)]) {
            [self.delegate playFinishedWithPlayerView:self];
        }
    }];
}

#pragma mark - 懒加载
- (UIImageView *)contentView{
    if (!_contentView) {
        CGFloat top = [self statusBarHeight];
        CGFloat height = self.frame.size.height;
        if ([self isFullScreen] &&
            height == ScreenH) {
            height = self.frame.size.height - top - [self touchHeight];
        }else{
            height = self.frame.size.height - top;
        }
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
    }
    return _contentView;
}
- (ZPVideoController *)controller{
    if (!_controller) {
        CGFloat top = [self statusBarHeight];
        CGFloat height = self.frame.size.height;
        if ([self isFullScreen] &&
            height == ScreenH) {
            height = self.frame.size.height - top - [self touchHeight];
        }else{
            height = self.frame.size.height - top;
        }
        _controller = [[ZPVideoController alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
        [_controller.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [_controller.fullBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        [_controller.returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_controller.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _controller;
}
- (ZPVideoController2 *)controller2{
    if (!_controller2) {
        CGFloat top = [self statusBarHeight];
        CGFloat height = self.frame.size.height;
        if ([self isFullScreen] &&
            height == ScreenH) {
            height = self.frame.size.height - top - [self touchHeight];
        }else{
            height = self.frame.size.height - top;
        }
        _controller2 = [[ZPVideoController2 alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
        [_controller2.fullBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        [_controller2.returnBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controller2;
}
- (ZPVideoErrorView *)errorView{
    if (!_errorView) {
        CGFloat top = [self statusBarHeight];
        CGFloat height = self.frame.size.height;
        if ([self isFullScreen] &&
            height == ScreenH) {
            height = self.frame.size.height - top - [self touchHeight];
        }else{
            height = self.frame.size.height - top;
        }
        _errorView = [[ZPVideoErrorView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, height)];
        _errorView.hidden = YES;
    }
    return _errorView;
}
- (CGFloat)statusBarHeight{
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    }
    else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}
- (CGFloat)touchHeight{
    if ([self statusBarHeight] > 20) {
        return 34;
    }
    return 0;
}
- (BOOL)isFullScreen{
    if ([self statusBarHeight] > 20) {
        return YES;
    }
    return NO;
}
- (BOOL)hasChineseChar:(NSString *)str{
    BOOL bool_value = NO;
    
    for (int i=0; i<str.length; i++) {
        
        NSRange range =NSMakeRange(i, 1);
        
        NSString * strFromSubStr=[str substringWithRange:range];
        
        const char * cStringFromstr=[strFromSubStr UTF8String];
        
        if (strlen(cStringFromstr)==3) {
            //有汉字
            bool_value = YES;
        }
    }
    return bool_value;
}
- (UIImage *)imageWithName:(NSString *)imgName{
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString * imageName = [NSString stringWithFormat:@"%@@%zdx.png",imgName,scale];
    NSString * path = [bundle pathForResource:imageName ofType:nil inDirectory:@"ZPAVPlayer.bundle"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}
//这个方法默认已对连接中的汉字进行处理
- (UIImage *)getImageWithVideoUrl:(NSString *)url{
    NSString * newUrl = url;
    AVAsset * asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:newUrl] options:nil];
    AVAssetImageGenerator * gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0, 60);
    NSError * error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
- (void)dealloc{
    [self.player pause];
    NSLog(@"释放%@",[self class]);
}
@end
