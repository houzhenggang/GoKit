//
//  PasswordChangeViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/11/4.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "PasswordChangeViewController.h"
#import "XPGWIFISDKObject.h"
#import "QXToast.h"
#import "MBProgressHUD.h"

@interface PasswordChangeViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UITextField *textfieldUser;
@property (nonatomic, retain) IBOutlet UITextField *textfieldOldPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldNewPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldNewPasswordVerify;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation PasswordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"修改密码"];
    
    [_textfieldUser setText:[[XPGWIFISDKObject shareInstance] username]];
    [_textfieldUser setEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonChangePasswordClicked:(id)sender {
    if (_textfieldOldPassword.text.length <= 0) {
        [QXToast showMessage:@"请输入旧密码"];
        [_textfieldOldPassword becomeFirstResponder];
        return;
    }
    
    if (![_textfieldNewPassword.text isEqualToString:_textfieldNewPasswordVerify.text]) {
        [QXToast showMessage:@"输入的新密码不一致，请重新输入"];
        return;
    }
    
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.labelText = @"正在修改密码...";
    [_hud show:YES];
    
    [[XPGWIFISDKObject shareInstance] changeUserPassword:_textfieldOldPassword.text newPassword:_textfieldNewPassword.text];
}

#pragma XPGWIFISDKObjectDelegate

- (void)didChangeAccountPasswordStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [QXToast showMessage:@"修改密码成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [QXToast showMessage:@"修改密码失败"];
    }
}

@end
