//
//  ZPViewController.m
//  ZPAVPlayer
//
//  Created by WZPScroll on 03/23/2022.
//  Copyright (c) 2022 WZPScroll. All rights reserved.
//

#import "ZPViewController.h"
#import <Masonry.h>
#import "ZPTestViewController.h"

@interface ZPViewController ()

@end

#define ScreenW  ([[UIScreen mainScreen] bounds].size.width) // 屏幕宽度
#define ScreenH ([[UIScreen mainScreen] bounds].size.height)// 屏幕高度
#define PROPORTION6 ScreenW/375.00//不同版本比例系数
#define kP6(x) x*PROPORTION6


@implementation ZPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(150, 200, 100, 50)];
    [button setTitle:@"去看视频" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
- (void)nextVC{
    ZPTestViewController * testVC =  [ZPTestViewController new];
    [self.navigationController pushViewController:testVC animated:YES];
}




@end
