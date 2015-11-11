/**
 * IoTLogin.m
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

#import "UserLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "XPGWIFISDKObject.h"
#import "DeviceListViewController.h"
#import "AccountGeneralViewController.h"
#import "AccountPhoneViewController.h"
#import "AccountEmailViewController.h"
#import "QXToast.h"

@interface UserLoginViewController () <UITextFieldDelegate, XPGWIFISDKObjectDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"用户登录"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonRegisterClicked:)];
    
    [_textUser setText:[[XPGWIFISDKObject shareInstance] username]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![XPGWIFISDKObject shareInstance].isRegisteredUser) {
        self.navigationItem.hidesBackButton = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = self;
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [XPGWIFISDKObject shareInstance].delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action
- (IBAction)buttonLoginClicked:(id)sender {
    if ([_textUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0) {
        [_textUser becomeFirstResponder];
        return;
    }
        
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.labelText = @"登录中...";
    [_hud show:YES];
        
    [[XPGWIFISDKObject shareInstance] userLoginWithUserName:self.textUser.text password:self.textPass.text];
}

- (IBAction)buttonForgetPasswordClicked:(id)sender {
    if ([UserLoginViewController validateMobile:_textUser.text]) {
        AccountPhoneViewController *accountPhoneVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountPhoneViewController"];
        accountPhoneVC.isForget = YES;
        accountPhoneVC.phone = _textUser.text;
        if (nil != accountPhoneVC) {
            [self.navigationController pushViewController:accountPhoneVC animated:YES];
        }
            
        return;
    } else if ([UserLoginViewController validateEmail:_textUser.text]) {
        AccountEmailViewController *accountEmailVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountEmailViewController"];
        accountEmailVC.isForget = YES;
        accountEmailVC.email = _textUser.text;
        if (nil != accountEmailVC) {
            [self.navigationController pushViewController:accountEmailVC animated:YES];
        }
        
        return;
    }
    
    [QXToast showMessage:@"请输入有效的且已注册的手机号或邮箱"];
    [_textUser becomeFirstResponder];
}

- (void)loginBtnClickHandler:(id)sender {

}

- (void)barButtonRegisterClicked:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用户名账户", @"手机号账户", @"邮箱账户", nil];
    [sheet showFromBarButtonItem:sender animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.textUser) {
        [self.textPass becomeFirstResponder];
    } else {
        [self buttonLoginClicked:nil];
    }
    
    return YES;
}

/** 邮箱验证 */
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 手机号码验证 */
+ (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark - XPGWIFISDKObjectDelegate

- (void)didUserLoginStatus:(XPGWIFISDKObjectStatus)status {
    [_hud setHidden:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        [XPGWIFISDKObject shareInstance].userType = XPGWIFISDKObjectUserTypeNormal;
        [XPGWIFISDKObject shareInstance].username = _textUser.text;
        [XPGWIFISDKObject shareInstance].password = _textPass.text;

        DeviceListViewController *deviceListVC = [[DeviceListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        if (nil != deviceListVC) {
            [self.navigationController pushViewController:deviceListVC animated:YES];
        }

    } else {
        if (XPGWIFISDKObjectStatusUsernameOrPasswordErr == status) {
            [[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    }
}

#pragma UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"%s, buttonIndex:%@", __func__, @(buttonIndex));
    
    if (0 == buttonIndex) { // 用户名
        AccountGeneralViewController *accountGeneralVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountGeneralViewController"];
        if (nil != accountGeneralVC) {
            [self.navigationController pushViewController:accountGeneralVC animated:YES];
        }
    } else if (1 == buttonIndex) { // 手机号
        AccountPhoneViewController *accountPhoneVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountPhoneViewController"];
        if (nil != accountPhoneVC) {
            [self.navigationController pushViewController:accountPhoneVC animated:YES];
        }
    } else if (2 == buttonIndex) { // 邮箱
        AccountEmailViewController *accountEmailVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountEmailViewController"];
        if (nil != accountEmailVC) {
            [self.navigationController pushViewController:accountEmailVC animated:YES];
        }
    }
}

@end
