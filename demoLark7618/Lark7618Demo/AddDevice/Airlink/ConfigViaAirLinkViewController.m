/**
 * IoTAirlinkConfigure.m
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

#import "ConfigViaAirLinkViewController.h"
#import "XPGWIFISDKObject.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkMonitor.h"
#import "DeviceListViewController.h"

@interface ConfigViaAirLinkViewController () <XPGWIFISDKObjectDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfieldSSID;
@property (weak, nonatomic) IBOutlet UITextField *textfieldKey;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation ConfigViaAirLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"AirLink模式";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *ssid = [NetworkMonitor currentWifiSSID];
    if (nil != ssid) {
        [_textfieldSSID setText:ssid];
        [_textfieldSSID setEnabled:NO];
    }
    
    [XPGWIFISDKObject shareInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonConfigureClicked:(id)sender {
    [_textfieldSSID resignFirstResponder];
    [_textfieldKey resignFirstResponder];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.labelText = @"正在配置...";
    [_hud show:YES];
    
    [[XPGWIFISDKObject shareInstance] configureAirLinkModeSSID:_textfieldSSID.text andPassword:_textfieldKey.text timeout:60];
}

#pragma mark - XPGWIFISDKObjectDelegate

- (void)didConfigWIFIStatus:(XPGWIFISDKObjectStatus)status {
    
    NSLog(@"%s %@", __func__, (status==XPGWIFISDKObjectStatusSuccessful) ? @"successful":@"failed");

    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"配置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        
        /* 返回到设备列表 */
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[DeviceListViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else if (XPGWIFISDKObjectStatusConfigureTimeout == status) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"配置超时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"配置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

@end
