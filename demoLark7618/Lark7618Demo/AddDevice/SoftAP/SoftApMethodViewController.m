//
//  SoftApMethodViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/20.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "SoftApMethodViewController.h"
#import "ConfigViaSoftAPViewController.h"

@interface SoftApMethodViewController ()

@end

@implementation SoftApMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 使用APP的方式配置网络 */
- (IBAction)buttonAppConfigClicked:(id)sender {

    ConfigViaSoftAPViewController *configViaSoftAPVC = [[ConfigViaSoftAPViewController alloc] init];
    if (nil != configViaSoftAPVC) {
        [self.navigationController pushViewController:configViaSoftAPVC animated:YES];
    }
}

/** 使用WebConfig的方式配置网络 */
- (IBAction)buttonBrowserConfigClicked:(UIButton *)sender {

    // 打开浏览器
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sender titleForState:UIControlStateNormal]]];
}

@end
