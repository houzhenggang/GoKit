//
//  SendingFSKViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/14.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "SendingFSKViewController.h"
#import <YYTXLark7618/YYTXLark7618.h>
#import "MBProgressHUD.h"
#import "AdjustVolumeTableViewController.h"
#import "NoHintTableViewController.h"
#import "DeviceListViewController.h"
#import "ConfigViaFSKViewController.h"

@interface SendingFSKViewController () <YYTXLark7618Delegate>
@property (nonatomic, retain) NoHintTableViewController *noHintTVC;
@property (nonatomic, retain) AdjustVolumeTableViewController *adjustVolumeTVC;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation SendingFSKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAnimating = YES; // 界面正在切换
    [YYTXLark7618 sharedInstance].delegate = self;
    
    // 进入界面后延时自动发送FSK
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [self sendFSK];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isAnimating = YES; // 界面正在切换
    [self.navigationController setToolbarHidden:YES];
    
    /* 如果是在“无提示”和“音量调整”界面点击“重新发送”返回该界面的则自动发送FSK */
    if (_noHintTVC.needFSKConfig) {
        [self sendFSK];
    } else if (_adjustVolumeTVC.needFSKConfig) {
        [self sendFSK];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isAnimating = NO; // 界面切换结束
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _isAnimating = YES; // 界面正在切换
    [[YYTXLark7618 sharedInstance] stopSending];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _isAnimating = NO; // 界面切换结束
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sendFSK {
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.labelText = NSLocalizedStringFromTable(@"ConfigingWIFIForDevice", @"LocalizedSimpleChinese", nil);
    [_hud show:YES];
    
    // 发送FSK
    [[YYTXLark7618 sharedInstance] sendSSID:_ssid password:_password];
}

- (IBAction)buttonClickRescan:(id)sender {
    
    if (self.isAnimating) {
        return; // 如果当前视图正在切换中，则取消视图跳转
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DeviceListViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (IBAction)buttonClickAdjustVolume:(id)sender {
    
    if (self.isAnimating) {
        return; // 如果当前视图正在切换中，则取消视图跳转
    }
    
    _adjustVolumeTVC = [[AdjustVolumeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if (nil != _adjustVolumeTVC) {
        [self.navigationController pushViewController:_adjustVolumeTVC animated:YES];
    }
}

- (IBAction)buttonClickWrongPassword:(id)sender {
    
    if (self.isAnimating) {
        return; // 如果当前视图正在切换中，则取消视图跳转
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ConfigViaFSKViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (IBAction)buttonClickConfigFailed:(id)sender {
    
    if (self.isAnimating) {
        return; // 如果当前视图正在切换中，则取消视图跳转
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonClickNoHint:(id)sender {
    
    if (self.isAnimating) {
        return; // 如果当前视图正在切换中，则取消视图跳转
    }
    
    _noHintTVC = [[NoHintTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if (nil != _noHintTVC) {
        [self.navigationController pushViewController:_noHintTVC animated:YES];
    }
}


- (void)didFSKSendingComplete {

    // FSK发送完成后，留出一段给设备连接网络的时间，然后再允许用户操作手机界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [_hud hide:YES];
    });
}

@end
