/**
 * IoTDeviceAP.m
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

#import "ConfigViaSoftAPViewController.h"
#import "XPGWIFISDKObject.h"
#import "UIAlertView+YYTXCustom.h"
#import "MBProgressHUD.h"
#import "QXToast.h"

@interface ConfigViaSoftAPViewController () <XPGWIFISDKObjectDelegate>
{
    BOOL isTextAnimated;
    NSTimer *timer;
}

@property (strong) NSArray *arraylist;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation ConfigViaSoftAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SoftAP模式";
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = self;
    
    /* 每隔5秒从设备端获取一次SSID列表 */
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadSSID:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [XPGWifiSDK sharedInstance].delegate = nil;
    
    /* Disable timer */
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 从设备端获取设备当前扫描到的SSID列表 */
- (void)loadSSID:(NSTimer *)timer {
    
    [[XPGWIFISDKObject shareInstance] loadSSID];
}

#pragma mark - 回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arraylist.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if(indexPath.row == self.arraylist.count) {
        
        cell.textLabel.text = @"其他";
    } else {
        XPGWifiSSID *ssid = self.arraylist[indexPath.row];
        cell.textLabel.text = ssid.name;
        
        int rssiLevel = 0;
        if(ssid.rssi > 75)
            rssiLevel = 4;
        else if(ssid.rssi > 50)
            rssiLevel = 3;
        else if(ssid.rssi > 25)
            rssiLevel = 2;
        else
            rssiLevel = 1;
        
        NSString *file = [NSString stringWithFormat:@"rssi_%i@2x", rssiLevel];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"png"]];
        cell.accessoryView = [[UIImageView alloc] initWithImage:image];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == self.arraylist.count) {
        /* 需要用户手动输入的SSID */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"配置网络" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *textfieldSSID = [alertView textFieldAtIndex:0];
        [textfieldSSID setPlaceholder:@"WIFI网络的名称"];
        
        UITextField *textfieldPass = [alertView textFieldAtIndex:1];
        [textfieldPass setPlaceholder:@"WIFI网络的密码"];
        
        [alertView showAlertViewWithCompleteBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (1 == buttonIndex) {
                if (textfieldSSID.text.length <= 0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SSID不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
                
                _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:_hud];
                _hud.labelText = @"正在配置网络...";
                [_hud show:YES];
                
                [timer setFireDate:[NSDate distantFuture]];
                
                // 通过SoftAP的方式给设备配置网络
                [[XPGWIFISDKObject shareInstance] configSoftAPModeSSID:textfieldSSID.text andPassword:textfieldPass.text];
            }
            
        }];
    } else {
        /* 配置的网络是当前设备已扫描到的SSID */
        XPGWifiSSID *ssid = self.arraylist[indexPath.row];
        
        //配置AP
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"配置网络" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *textfieldSSID = [alertView textFieldAtIndex:0];
        textfieldSSID.text = ssid.name;
        textfieldSSID.enabled = NO;
        
        UITextField *textfieldPass = [alertView textFieldAtIndex:1];
        textfieldPass.text = @"";
        
        [alertView showAlertViewWithCompleteBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (1 == buttonIndex) {
                if (textfieldSSID.text.length <= 0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SSID不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
                
                _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:_hud];
                _hud.labelText = @"正在配置网络...";
                [_hud show:YES];
                
                [timer setFireDate:[NSDate distantFuture]];
                
                // 通过SoftAP的方式给设备配置网络
                [[XPGWIFISDKObject shareInstance] configSoftAPModeSSID:textfieldSSID.text andPassword:textfieldPass.text];
            }
        }];
    }
}

- (void)didLoadSSIDList:(NSArray *)SSIDList status:(XPGWIFISDKObjectStatus)status {
    
    NSLog(@"%s status:%d list:%@", __func__, status, [SSIDList componentsJoinedByString:@","]);

    if (XPGWIFISDKObjectStatusSuccessful == status) {
        _arraylist = SSIDList;
        [self.tableView reloadData];
    }
}

- (void)didConfigWIFIStatus:(XPGWIFISDKObjectStatus)status {
    
    NSLog(@"%s status:%d", __func__, status);

    [_hud hide:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        
        [QXToast showMessage:@"配置WIFI成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        [timer setFireDate:[NSDate date]];
        
        [QXToast showMessage:@"配置WIFI失败"];
    }
}

@end
