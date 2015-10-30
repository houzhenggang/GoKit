//
//  UpdatingArticleViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/26.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "UpdatingArticleViewController.h"

@interface UpdatingArticleViewController ()

@end

@implementation UpdatingArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"词条更新"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
