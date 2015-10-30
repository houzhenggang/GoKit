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

- (IBAction)buttonAppConfigClicked:(id)sender {

    ConfigViaSoftAPViewController *configViaSoftAPVC = [[ConfigViaSoftAPViewController alloc] init];
    if (nil != configViaSoftAPVC) {
        [self.navigationController pushViewController:configViaSoftAPVC animated:YES];
    }
}

- (IBAction)buttonBrowserConfigClicked:(UIButton *)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sender titleForState:UIControlStateNormal]]];
}

@end
