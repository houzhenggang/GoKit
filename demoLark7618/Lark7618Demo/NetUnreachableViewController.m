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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonRetryClick:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
