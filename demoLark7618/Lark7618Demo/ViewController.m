//
//  ViewController.m
//  lark7618Sample
//
//  Created by TTS on 15/10/9.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "ViewController.h"
#import "XPGWIFISDKObject.h"
#import "NetUnreachableViewController.h"
#import "SoftAPModeViewController.h"
#import "NetworkMonitor.h"
#import "UserLoginViewController.h"

#define SYSTEMVERSIONLESSTHAN(ver)      \
({  \
    NSString *sysVer = [[UIDevice currentDevice] systemVersion];    \
    (NSOrderedAscending == [sysVer compare:ver]) ? 1:0; \
})

@interface ViewController () <XPGWIFISDKObjectDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Background.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    [[XPGWIFISDKObject shareInstance] setDelegate:self];
    
    [[XPGWIFISDKObject shareInstance] start];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    /* 检查手机是否打开WIFI */
    if (![NetworkMonitor isEnableWIFI]) {
        NetUnreachableViewController *netUnreachableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NetUnreachableViewController"];
        if (nil != netUnreachableVC) {
            [self.navigationController pushViewController:netUnreachableVC animated:YES];
        }
    }
    
    /* 判断设备设备是否处于SoftAP模式 */
    if ([[XPGWIFISDKObject shareInstance] isSoftAPMode]) {
        /* 如果设备处于SoftAP模式，且手机已连接到设备的SSID，则进入网络配置模式 */
        SoftAPModeViewController *softAPModeVC = [[UIStoryboard storyboardWithName:@"SoftAP" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftAPModeViewController"];
        if (nil != softAPModeVC) {
            [self.navigationController pushViewController:softAPModeVC animated:YES];
        }
    } else {
        /* 否则进入正常工作模式－－用户登陆界面 */
        UserLoginViewController *userLoginVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
        if (nil != userLoginVC) {
            [self.navigationController pushViewController:userLoginVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
