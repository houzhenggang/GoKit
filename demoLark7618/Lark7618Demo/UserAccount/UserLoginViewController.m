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
#import "UserRegisterViewController.h"
#import "DeviceListViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface UserLoginViewController () <UITextFieldDelegate, XPGWIFISDKObjectDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPass;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"用户登录"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegister)];
    
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
- (IBAction)login:(id)sender {

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

- (IBAction)forgetPassword:(id)sender {
    UserRegisterViewController *userRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserRegisterViewController"];
    userRegisterVC.isForget = YES;
    if (nil != userRegisterVC) {
        [self.navigationController pushViewController:userRegisterVC animated:YES];
    }
}

- (void)loginBtnClickHandler:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        
    }];
}

- (void)onRegister {
    UserRegisterViewController *userRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserRegisterViewController"];
    
    userRegisterVC.isForget = NO;
    if (nil != userRegisterVC) {
        [self.navigationController pushViewController:userRegisterVC animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.textUser) {
        [self.textPass becomeFirstResponder];
    } else {
        [self login:nil];
    }
    
    return YES;
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

@end
