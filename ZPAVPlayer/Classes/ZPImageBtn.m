//
//  ZPImageBtn.m
//  Pods-ZPAVPlayer_Example
//
//  Created by yy on 2022/3/23.
//

#import "ZPImageBtn.h"
#import "Masonry.h"

@implementation ZPImageBtn

- (instancetype)initWithImage:(nonnull UIImage *)image{
    self=[super init];
    if (self) {
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        if (image) {
            self.imageV.image=image;
        }
        self.clipsToBounds=YES;
    }
    return self;
}

- (void)setImageSize:(CGSize )size left:(CGFloat )left top:(CGFloat )top{
    _imageV.frame=CGRectMake(left, top, size.width, size.height);
    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.top.mas_equalTo(top);
        make.size.mas_equalTo(size);
    }];
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [UIImageView new];
    }
    return _imageV;
}
@end
