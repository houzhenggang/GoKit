//
//  CheckingViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/14.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "CheckingViewController.h"
#import "SendingFSKViewController.h"

@interface CheckingViewController ()

@end

@implementation CheckingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedStringFromTable(@"ConfigNotes", @"LocalizedSimpleChinese", nil)];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"NextStep", @"LocalizedSimpleChinese", nil) style:UIBarButtonItemStylePlain target:self action:@selector(barButtonNextStepClicked)] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)barButtonNextStepClicked {
    SendingFSKViewController *sendingFSKVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendingFSKViewController"];
    sendingFSKVC.ssid = _ssid;
    sendingFSKVC.password = _password;
    if (nil != sendingFSKVC) {
        [self.navigationController pushViewController:sendingFSKVC animated:YES];
    }
}

@end
