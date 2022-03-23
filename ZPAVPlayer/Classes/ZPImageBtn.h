//
//  ZPImageBtn.h
//  Pods-ZPAVPlayer_Example
//
//  Created by yy on 2022/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPImageBtn : UIControl

/**
 只显示一个图片的按钮，可以设置图片在按钮中的位置
 */
@property(nonatomic,strong)UIImageView * imageV;

- (instancetype)initWithImage:(nonnull UIImage *)image;

/**
 设置图片大小和位置

 @param size 图片大小
 @param left 图片的left
 @param top  图片的top
 */
- (void)setImageSize:(CGSize )size left:(CGFloat )left top:(CGFloat )top;


@end

NS_ASSUME_NONNULL_END
