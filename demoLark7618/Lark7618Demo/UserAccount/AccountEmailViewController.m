//
//  AccountEmailViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/11/3.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "AccountEmailViewController.h"
#import "QXToast.h"
#import "XPGWIFISDKObject.h"
#import "DeviceListViewController.h"
#import "MBProgressHUD.h"

@interface AccountEmailViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UITextField *textfieldEmail;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldVerifyPassword;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) IBOutlet UILabel *labelPassword;
@property (nonatomic, retain) IBOutlet UILabel *labelVerifyPassword;
@property (nonatomic, retain) IBOutlet UIButton *buttonRegister;

@end

@implementation AccountEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isForget) {
        [_textfieldEmail setText:_email];
        [_labelPassword setHidden:YES];
        [_textfieldPassword setHidden:YES];
        [_labelVerifyPassword setHidden:YES];
        [_textfieldVerifyPassword setHidden:YES];
        [_buttonRegister setTitle:@"重置" forState:UIControlStateNormal];
    } else {
        [_labelPassword setHidden:NO];
        [_textfieldPassword setHidden:NO];
        [_labelVerifyPassword setHidden:NO];
        [_textfieldVerifyPassword setHidden:NO];
        [_buttonRegister setTitle:@"注册" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
}

- (IBAction)buttonRegisterClicked:(id)sender {
    if (_textfieldEmail.text.length <= 0) {
        [QXToast showMessage:@"请输入邮箱地址"];
        [_textfieldEmail becomeFirstResponder];
        return;
    }
    
    if (_isForget) {
            _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:_hud];
            _hud.labelText = @"正在重置密码...";
            [_hud show:YES];
            
        [[XPGWIFISDKObject shareInstance] changePasswordWithAccountEmail:_textfieldEmail.text];
    } else {
        if ([_textfieldPassword.text isEqualToString:_textfieldVerifyPassword.text]) {
            _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:_hud];
            _hud.labelText = @"正在注册...";
            [_hud show:YES];
        
            [[XPGWIFISDKObject shareInstance] registerAccountWithEmail:_textfieldEmail.text password:_textfieldPassword.text];
        } else {
            [QXToast showMessage:@"密码不匹配，请重新输入"];
        }
    }
}

#pragma XPGWIFISDKObjectDelegate

- (void)didRegisterAccountStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [XPGWIFISDKObject shareInstance].username = _textfieldEmail.text;
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

- (void)didChangeAccountPasswordStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [QXToast showMessage:@"重置密码成功"];
    } else {
        [QXToast showMessage:@"重置密码失败"];
    }
}

@end
