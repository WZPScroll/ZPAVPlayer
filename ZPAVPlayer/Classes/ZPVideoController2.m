//
//  ZPVideoController2.m
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import "ZPVideoController2.h"
#import "ZPImageBtn.h"
#import "Masonry.h"

@interface ZPVideoController2 ()

@property (nonatomic,assign) BOOL hidden;//按钮状态

@end
#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6
#define ImageName(string) [UIImage imageNamed:string]//设置图片


@implementation ZPVideoController2

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.returnBtn];
        [self addSubview:self.fullBtn];
        [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(kP6(5));
            make.width.height.mas_equalTo(kP6(35));
        }];
        [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kP6(5));
            make.width.height.mas_equalTo(kP6(33));
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
- (void)showControlerWithAnimate:(BOOL)animate{
    self.returnBtn.hidden = NO;
    self.fullBtn.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.returnBtn.alpha = 1;
            self.fullBtn.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else{
        self.returnBtn.alpha = 1;
        self.fullBtn.alpha = 1;
    }
    _hidden = NO;
}
- (void)hiddenControlerWithAnimate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.returnBtn.alpha = 0;
            self.fullBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.returnBtn.hidden = YES;
            self.fullBtn.hidden = YES;
        }];
    }else{
        self.returnBtn.alpha = 0;
        self.fullBtn.alpha = 0;
        self.returnBtn.hidden = YES;
        self.fullBtn.hidden = YES;
    }
    _hidden = YES;
}

#pragma mark - 懒加载
- (ZPImageBtn *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [[ZPImageBtn alloc] initWithImage:[self imageWithName:@"movie_return"]];
        [_returnBtn setImageSize:CGSizeMake(kP6(19), kP6(19)) left:kP6(8) top:kP6(8)];
    }
    return _returnBtn;
}
- (ZPImageBtn *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [[ZPImageBtn alloc] initWithImage:[self imageWithName:@"full_icon"]];
        [_fullBtn setImageSize:CGSizeMake(kP6(17), kP6(17)) left:kP6(8) top:kP6(8)];
        _fullBtn.selected = NO;
    }
    return _fullBtn;
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
