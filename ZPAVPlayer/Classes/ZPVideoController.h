//
//  ZPVideoController.h
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import <UIKit/UIKit.h>
@class ZPImageBtn;

NS_ASSUME_NONNULL_BEGIN

@interface ZPVideoController : UIView

@property (nonatomic,strong) ZPImageBtn * returnBtn;
@property (nonatomic,strong) ZPImageBtn * playBtn;
@property (nonatomic,strong) UILabel * startTimeLab;
@property (nonatomic,strong) UILabel * endTimeLab;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) ZPImageBtn * fullBtn;
@property (nonatomic,strong) UISlider * slider;


@property (nonatomic,assign) NSInteger currentTime;//当前播放秒数
@property (nonatomic,assign) NSInteger totalTime;//视频总秒数

- (void)hiddenControlerWithAnimate:(BOOL)animate;
- (void)showControlerWithAnimate:(BOOL)animate;


@end

NS_ASSUME_NONNULL_END
