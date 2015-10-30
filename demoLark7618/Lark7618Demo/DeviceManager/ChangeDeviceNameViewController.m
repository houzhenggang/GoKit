//
//  ChangeDeviceNameViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/23.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "ChangeDeviceNameViewController.h"

@interface ChangeDeviceNameViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textfieldDeviceName;

@end

@implementation ChangeDeviceNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonOkClicked:(id)sender {
    
}

- (IBAction)buttonCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
