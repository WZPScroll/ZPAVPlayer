//
//  ZPVideoPlayerView.h
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import <UIKit/UIKit.h>
@class ZPVideoPlayerView;

NS_ASSUME_NONNULL_BEGIN

@protocol ZPVideoPlayerViewDelegate <NSObject>

- (void)fullScreenWithPlayerView:(ZPVideoPlayerView *)playerView;
- (void)smallScreenWithPlayerView:(ZPVideoPlayerView *)playerView;
- (void)stopAndBackWithPlayerView:(ZPVideoPlayerView *)playerView;
- (void)playFinishedWithPlayerView:(ZPVideoPlayerView *)playerView;

@end

@interface ZPVideoPlayerView : UIView

@property (nonatomic,weak)  id <ZPVideoPlayerViewDelegate> delegate;
@property (nonatomic,copy)   NSString * url;
@property (nonatomic,assign) NSInteger type;//1默认播放视频 2播放m3u8直播
@property (nonatomic,readonly) BOOL full;//是否是全屏

//当播放器位置在NavigationView下时需修改UI
- (void)resetWhenNavigationViewShow;

//获取直播最后一帧
- (UIImage *)getLastImage;

//停止播放
- (void)pause;
- (void)start;//开始播放
- (void)resetPlayerViewWithFull:(BOOL)full;
- (void)showController;
- (void)hiddenFullBtn;//隐藏全屏按钮
- (void)showErrorView;//直播不正常提示
- (void)hiddenErrorView;

@end

NS_ASSUME_NONNULL_END
