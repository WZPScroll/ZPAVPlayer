//
//  ZPVideoErrorView.m
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import "ZPVideoErrorView.h"
#import "Masonry.h"


@interface ZPVideoErrorView ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * messageLab;

@end

#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6
#define ImageName(string) [UIImage imageNamed:string]//设置图片
#define DefaultFontName @"PingFang-SC-Regular"

@implementation ZPVideoErrorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.imageView];
        [self addSubview:self.messageLab];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kP6(55));
            make.height.mas_equalTo(kP6(45));
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kP6(20));
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(kP6(11));
            make.centerX.mas_equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [self imageWithName:@"videoErrorIcon"];
    }
    return _imageView;
}
- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [UILabel new];
        _messageLab.font = [UIFont fontWithName:DefaultFontName size:kP6(14)];
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.textAlignment = 1;
        _messageLab.text = @"请检查网络或视频地址";
    }
    return _messageLab;
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
