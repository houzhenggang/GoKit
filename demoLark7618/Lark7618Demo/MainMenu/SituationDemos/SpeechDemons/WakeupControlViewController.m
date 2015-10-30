//
//  WakeupControlViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/26.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "WakeupControlViewController.h"

@interface WakeupControlViewController ()

@end

@implementation WakeupControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"唤醒控制"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
