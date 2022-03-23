//
//  ZPVideoController2.h
//  ZPAVPlayer
//
//  Created by yy on 2022/3/23.
//

#import <UIKit/UIKit.h>
@class ZPImageBtn;

NS_ASSUME_NONNULL_BEGIN

//播放直播的控制器
@interface ZPVideoController2 : UIView

@property (nonatomic,strong) ZPImageBtn * returnBtn;
@property (nonatomic,strong) ZPImageBtn * fullBtn;


- (void)hiddenControlerWithAnimate:(BOOL)animate;
- (void)showControlerWithAnimate:(BOOL)animate;


@end

NS_ASSUME_NONNULL_END
