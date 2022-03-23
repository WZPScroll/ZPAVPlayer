//
//  ZPVideoController.m
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import "ZPVideoController.h"
#import "ZPImageBtn.h"
#import "Masonry.h"

@interface ZPVideoController ()

@property (nonatomic,assign) BOOL hidden;//按钮状态
@property (nonatomic,strong) UIView * tapView;


@end
#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6
#define ImageName(string) [UIImage imageNamed:string]//设置图片
#define DefaultFontName @"PingFang-SC-Regular"
#define ZPColorACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0 alpha:(a)]


@implementation ZPVideoController

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.returnBtn];
        [self addSubview:self.playBtn];
        [self addSubview:self.startTimeLab];
        [self addSubview:self.fullBtn];
        [self addSubview:self.endTimeLab];
        [self addSubview:self.progressView];
        [self addSubview:self.slider];
        [self addSubview:self.tapView];
        [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(kP6(5));
            make.width.height.mas_equalTo(kP6(35));
        }];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kP6(9));
            make.width.height.mas_equalTo(kP6(31));
            make.bottom.mas_equalTo(0);
        }];
        [self.startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playBtn.mas_right);
            make.height.mas_equalTo(kP6(20));
            make.width.mas_equalTo(kP6(60));
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
        }];
        [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kP6(5));
            make.width.height.mas_equalTo(kP6(33));
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
        }];
        [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.fullBtn.mas_left);
            make.height.mas_equalTo(kP6(20));
            make.width.mas_equalTo(kP6(60));
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
        }];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.startTimeLab.mas_right).offset(kP6(4));
            make.height.mas_equalTo(2);
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            make.right.mas_equalTo(self.endTimeLab.mas_left).offset(-kP6(4));
        }];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.startTimeLab.mas_right).offset(kP6(4));
            make.height.mas_equalTo(kP6(20));
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            make.right.mas_equalTo(self.endTimeLab.mas_left).offset(-kP6(4));
        }];
        [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.returnBtn.mas_bottom);
            make.bottom.mas_equalTo(self.playBtn.mas_top);
        }];
        _hidden = NO;
        //添加点击事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenController)];
        [self.tapView addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark - 操作
- (void)showOrHiddenController{
    if (_hidden == YES) {
        [self showControlerWithAnimate:YES];
    }else{
        [self hiddenControlerWithAnimate:YES];
    }
}
- (void)showControlerWithAnimate:(BOOL)animate{
    self.returnBtn.hidden = NO;
    self.playBtn.hidden = NO;
    self.fullBtn.hidden = NO;
    self.progressView.hidden = NO;
    self.slider.hidden = NO;
    self.startTimeLab.hidden = NO;
    self.endTimeLab.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.returnBtn.alpha = 1;
            self.playBtn.alpha = 1;
            self.fullBtn.alpha = 1;
            self.progressView.alpha = 1;
            self.slider.alpha = 1;
            self.startTimeLab.alpha = 1;
            self.endTimeLab.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else{
        self.returnBtn.alpha = 1;
        self.playBtn.alpha = 1;
        self.fullBtn.alpha = 1;
        self.progressView.alpha = 1;
        self.slider.alpha = 1;
        self.startTimeLab.alpha = 1;
        self.endTimeLab.alpha = 1;
    }
    _hidden = NO;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenController) object:nil];
//    [self performSelector:@selector(hiddenController) withObject:nil afterDelay:3.0];//先取消自动隐藏
}
- (void)hiddenController{
    [self hiddenControlerWithAnimate:YES];
}
- (void)hiddenControlerWithAnimate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.returnBtn.alpha = 0;
            self.playBtn.alpha = 0;
            self.fullBtn.alpha = 0;
            self.progressView.alpha = 0;
            self.slider.alpha = 0;
            self.startTimeLab.alpha = 0;
            self.endTimeLab.alpha = 0;
        } completion:^(BOOL finished) {
            self.returnBtn.hidden = YES;
            self.playBtn.hidden = YES;
            self.fullBtn.hidden = YES;
            self.progressView.hidden = YES;
            self.slider.hidden = YES;
            self.startTimeLab.hidden = YES;
            self.endTimeLab.hidden = YES;
        }];
    }else{
        self.returnBtn.alpha = 0;
        self.playBtn.alpha = 0;
        self.fullBtn.alpha = 0;
        self.progressView.alpha = 0;
        self.slider.alpha = 0;
        self.startTimeLab.alpha = 0;
        self.endTimeLab.alpha = 0;
        self.returnBtn.hidden = YES;
        self.playBtn.hidden = YES;
        self.fullBtn.hidden = YES;
        self.progressView.hidden = YES;
        self.slider.hidden = YES;
        self.startTimeLab.hidden = YES;
        self.endTimeLab.hidden = YES;
    }
    _hidden = YES;
}
- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
    self.startTimeLab.text = [self getTimeStrWithTime:currentTime];
    float progress = (float)_currentTime/(float)_totalTime;
    self.progressView.progress = progress;
    self.slider.value = progress;
}
- (void)setTotalTime:(NSInteger)totalTime{
    _totalTime = totalTime;
    self.endTimeLab.text = [self getTimeStrWithTime:totalTime];

    
}

//根据秒数转换成固定格式的时间字符串
- (NSString *)getTimeStrWithTime:(NSInteger)time{
    NSInteger hour = time/3600;//小时
    NSInteger minutes = (time - hour * 3600)/60;//分
    NSInteger second = time - hour * 3600 - minutes * 60;//秒
    NSString * hourStr = @"";
    NSString * minutesStr = @"";
    NSString * secondStr = @"";
    if (hour > 0) {
        hourStr = [NSString stringWithFormat:@"%ld",hour];
    }
    minutesStr = [NSString stringWithFormat:@"%ld",minutes];
    if (minutes < 10) {
        minutesStr = [NSString stringWithFormat:@"0%ld",minutes];
    }
    secondStr = [NSString stringWithFormat:@"%ld",second];
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }
    NSString * timeStr = @"";
    if (hourStr.length > 0) {
        timeStr = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minutesStr,secondStr];
    }else{
        timeStr = [NSString stringWithFormat:@"%@:%@",minutesStr,secondStr];
    }
    return timeStr;
}

#pragma mark - 懒加载
- (ZPImageBtn *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [[ZPImageBtn alloc] initWithImage:[self imageWithName:@"movie_return"]];
        [_returnBtn setImageSize:CGSizeMake(kP6(19), kP6(19)) left:kP6(8) top:kP6(8)];
    }
    return _returnBtn;
}
- (ZPImageBtn *)playBtn{
    if (!_playBtn) {
        _playBtn = [[ZPImageBtn alloc] initWithImage:[self imageWithName:@"play_icon"]];
        [_playBtn setImageSize:CGSizeMake(kP6(15), kP6(15)) left:kP6(8) top:kP6(8)];
        _playBtn.selected = NO;
    }
    return _playBtn;
}
- (UILabel *)startTimeLab{
    if (!_startTimeLab) {
        _startTimeLab = [UILabel new];
        _startTimeLab.font = [UIFont fontWithName:DefaultFontName size:kP6(14)];
        _startTimeLab.textColor = [UIColor whiteColor];
        _startTimeLab.text = @"00:00:00";
        _startTimeLab.textAlignment = 1;
    }
    return _startTimeLab;
}
- (UILabel *)endTimeLab{
    if (!_endTimeLab) {
        _endTimeLab = [UILabel new];
        _endTimeLab.font = [UIFont fontWithName:DefaultFontName size:kP6(14)];
        _endTimeLab.textColor = [UIColor whiteColor];
        _endTimeLab.text = @"00:00:00";
        _endTimeLab.textAlignment = 1;
    }
    return _endTimeLab;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = ZPColorACOLOR(255, 255, 255, 0.5);//默认颜色
        _progressView.progressTintColor=[UIColor whiteColor];//进度颜色
    }
    return _progressView;
}
- (ZPImageBtn *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [[ZPImageBtn alloc] initWithImage:[self imageWithName:@"full_icon"]];
        [_fullBtn setImageSize:CGSizeMake(kP6(17), kP6(17)) left:kP6(8) top:kP6(8)];
        _fullBtn.selected = NO;
    }
    return _fullBtn;
}
- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [UIView new];
        _tapView.backgroundColor = [UIColor clearColor];
    }
    return _tapView;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = [UISlider new];
        _slider.value = 0;
        _slider.continuous = YES;
        UIImage * thumbImage = [self imageWithName:@"slider"];
        UIImage *tempImage1 = [self image:thumbImage scaleToSize:CGSizeMake(15, 15)];
        [_slider setThumbImage:tempImage1 forState:UIControlStateNormal];
        [_slider setThumbImage:tempImage1 forState:UIControlStateHighlighted];
        _slider.minimumTrackTintColor = [UIColor clearColor];//左侧颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];//右侧颜色
        _slider.continuous = YES;//设置可连续变化
    }
    return _slider;
}
- (UIImage*)image:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return scaledImage;
}
- (UIImage *)imageWithName:(NSString *)imgName{
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString * imageName = [NSString stringWithFormat:@"%@@%zdx.png",imgName,scale];
    NSString * path = [bundle pathForResource:imageName ofType:nil inDirectory:@"ZPAVPlayer.bundle"];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}
@end
