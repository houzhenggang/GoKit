//
//  AccountGeneralViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/11/3.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "AccountGeneralViewController.h"
#import "QXToast.h"
#import "XPGWIFISDKObject.h"
#import "DeviceListViewController.h"
#import "MBProgressHUD.h"

@interface AccountGeneralViewController ()<XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UITextField *textfieldUserName;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldVerifyPassword;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation AccountGeneralViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
}

- (IBAction)buttonRegisterClicked:(id)sender {
    if (_textfieldUserName.text.length <= 0) {
        [QXToast showMessage:@"请输入用户名"];
        [_textfieldUserName becomeFirstResponder];
        return;
    }
    
    if ([_textfieldPassword.text isEqualToString:_textfieldVerifyPassword.text]) {
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_hud];
        _hud.labelText = @"正在注册...";
        [_hud show:YES];
        
        [[XPGWIFISDKObject shareInstance] registerAccountWithUserName:_textfieldUserName.text password:_textfieldPassword.text];
    } else {
        [QXToast showMessage:@"密码不匹配，请重新输入"];
    }
}

#pragma XPGWIFISDKObjectDelegate

- (void)didRegisterAccountStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [XPGWIFISDKObject shareInstance].username = _textfieldUserName.text;
        [XPGWIFISDKObject shareInstance].password = _textfieldPassword.text;
        [XPGWIFISDKObject shareInstance].userType = XPGWIFISDKObjectUserTypeNormal;
        
        [QXToast showMessage:@"注册成功"];
        
        //返回到设备列表页面
        for(UIViewController *view in self.navigationController.viewControllers) {
            if([view isKindOfClass:[DeviceListViewController class]]) {
                [self.navigationController popToViewController:view animated:YES];
            }
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

@end
