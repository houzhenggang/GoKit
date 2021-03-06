/**
 * IoTRegister.m
 *
 * Copyright (c) 2014~2015 Xtreme Programming Group, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "AccountPhoneViewController.h"
#import "DeviceListViewController.h"
#import "XPGWIFISDKObject.h"
#import "UIButton+WebCache.h"
#import "QXToast.h"
#import "MBProgressHUD.h"

@interface AccountPhoneViewController () <XPGWIFISDKObjectDelegate>
{
    NSInteger verifyCodeCounter;
    NSTimer *verifyTimer;
}
@property (nonatomic, retain) IBOutlet UILabel *labelPassword;
@property (nonatomic, retain) IBOutlet UILabel *labelVerifyPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPhoneNumber;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPictureVerifyCode;
@property (nonatomic, retain) IBOutlet UIButton *buttonVertifyPicture;
@property (nonatomic, retain) IBOutlet UITextField *textFieldMessageVerifyCode;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPassword;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPasswordConfirm;
@property (weak, nonatomic) IBOutlet UIButton *buttonRegister;
@property (weak, nonatomic) IBOutlet UIButton *buttonVerifyCode;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation AccountPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:NO];

    if(self.isForget) {
        self.navigationItem.title = @"重置密码";
        [_textfieldPhoneNumber setText:_phone];
        [_labelPassword setText:@"新密码"];
        [_labelVerifyPassword setText:@"确认新密码"];
        [self.buttonRegister setTitle:@"重置" forState:UIControlStateNormal];
    } else {
        self.navigationItem.title = @"注册新用户";
        [_labelPassword setText:@"密码"];
        [_labelVerifyPassword setText:@"确认密码"];
        [self.buttonRegister setTitle:@"注册" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = self;
    
    [self buttonPictureVerifyClick:_buttonVertifyPicture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = nil;
    [verifyTimer invalidate];
    verifyTimer = nil;
    verifyCodeCounter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action

/** 获取图片验证码 */
- (IBAction)buttonPictureVerifyClick:(UIButton *)sender {

    [[XPGWIFISDKObject shareInstance] requestVerifyPicture];
}

/** 获取手机验证码 */
- (IBAction)onQueryVerifyCode:(id)sender {
    
    if(_textfieldPhoneNumber.text.length != 11) {
        [QXToast showMessage:@"请输入正确的手机号"];
        [_textfieldPhoneNumber becomeFirstResponder];
        
        return;
    }
    
    if(_textfieldPictureVerifyCode.text.length <= 0) {
        [QXToast showMessage:@"请输入图片验证码"];
        [_textfieldPictureVerifyCode becomeFirstResponder];
        
        return;
    }
    
    // 用图片验证码获取手机验证码
    [[XPGWIFISDKObject shareInstance] getPhoneVerifyCodeWithPhoneNumber:_textfieldPhoneNumber.text pictureVerifyCode:_textfieldPictureVerifyCode.text];
    
    verifyCodeCounter = 60;
    [self updateVerifyButton];
    verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerifyButton) userInfo:nil repeats:YES];
}

/** 注册 */
- (IBAction)onRegister:(id)sender {
    
    if([_textfieldPassword.text isEqualToString:_textfieldPasswordConfirm.text]) {
        if(self.isForget) {
            _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:_hud];
            _hud.labelText = @"正在重置密码...";
            [_hud show:YES];
            
            [[XPGWIFISDKObject shareInstance] changePasswordWithAccountPhone:_textfieldPhoneNumber.text newPassword:_textfieldPassword.text messageCode:_textFieldMessageVerifyCode.text];
        } else {
            _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:_hud];
            _hud.labelText = @"正在注册...";
            [_hud show:YES];
            
            [[XPGWIFISDKObject shareInstance] registerAccountWithPhoneNumber:_textfieldPhoneNumber.text password:_textfieldPassword.text messageCode:_textFieldMessageVerifyCode.text];
        }
    } else {
        [QXToast showMessage:@"密码不匹配，请重新输入"];
        _textfieldPassword.text = @"";
        _textfieldPasswordConfirm.text = @"";
    }
}

#pragma mark - Others
/** 验证码重复获取等待 */
- (void)updateVerifyButton {
    
    if(verifyCodeCounter == 0) {
        [verifyTimer invalidate];
        self.buttonVerifyCode.enabled = true;
        [self.buttonVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"等待%i秒", (int)verifyCodeCounter];
    self.buttonVerifyCode.enabled = true;
    [self.buttonVerifyCode setTitle:title forState:UIControlStateNormal];
    self.buttonVerifyCode.enabled = false;
    
    verifyCodeCounter--;
}

#pragma XPGWifiSDKObjectDelegate

- (void)didRequsetVerifyPictureStatus:(XPGWIFISDKObjectStatus)status captchaURL:(NSString *)captchaURL {
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_buttonVertifyPicture sd_setImageWithURL:[NSURL URLWithString:captchaURL] forState:UIControlStateNormal placeholderImage:nil];
        });
    }
}

- (void)didGetPhoneVerifyCodeStatus:(XPGWIFISDKObjectStatus)status {
    if (XPGWIFISDKObjectStatusSuccessful != status) {
        [QXToast showMessage:@"获取手机验证码失败"];
    }
}

- (void)didChangeAccountPasswordStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [QXToast showMessage:@"更改密码成功"];
    } else {
        [QXToast showMessage:@"更改密码失败"];
    }
}

- (void)didRegisterAccountStatus:(XPGWIFISDKObjectStatus)status {
    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        
        [XPGWIFISDKObject shareInstance].username = _textfieldPhoneNumber.text;
        [XPGWIFISDKObject shareInstance].password = _textfieldPassword.text;
        [XPGWIFISDKObject shareInstance].userType = XPGWIFISDKObjectUserTypeNormal;
        
        [QXToast showMessage:@"注册成功"];
        
        /** 返回到设备列表页面 */
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
