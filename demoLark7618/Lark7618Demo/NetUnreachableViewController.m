//
//  NetUnreachableViewController.m
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "NetUnreachableViewController.h"

@interface NetUnreachableViewController ()

@end

@implementation NetUnreachableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonRetryClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
