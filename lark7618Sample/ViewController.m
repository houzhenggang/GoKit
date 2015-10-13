//
//  ViewController.m
//  lark7618Sample
//
//  Created by TTS on 15/10/9.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "ViewController.h"
#import <lark7618/lark7618.h>
#import "NetUnreachableViewController.h"
#import "SoftAPModeViewController.h"
#import "DeviceListViewController.h"

#define SYSTEMVERSIONLESSTHAN(ver)      \
({  \
    NSString *sysVer = [[UIDevice currentDevice] systemVersion];    \
    (NSOrderedAscending == [sysVer compare:ver]) ? 1:0; \
})

@interface ViewController () <lark7618Delegate>

@property (nonatomic, retain) lark7618 *lark7618;
@property (nonatomic, retain) IBOutlet UILabel *labelState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lark7618 = [[lark7618 alloc] initWithDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _lark7618.delegate = self;
    
    [_labelState setText:@"正在检查网络是否可用"];
    
    sleep(1);

    if (![_lark7618 networkIsReachable]) {
        NetUnreachableViewController *netUnreachableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NetUnreachableViewController"];
        if (nil != netUnreachableVC) {
            [self.navigationController pushViewController:netUnreachableVC animated:YES];
        }
    }
    
    [_labelState setText:@"正在检查设备是否处于SoftAP模式"];
    
    sleep(1);
    
    if ([_lark7618 isSoftAPMode]) {
        SoftAPModeViewController *softAPModeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SoftAPModeViewController"];
        if (nil != softAPModeVC) {
            [self.navigationController pushViewController:softAPModeVC animated:YES];
        }
    }
    
    [_labelState setText:@"正在登录"];
    
    sleep(1);
    
    [_lark7618 initAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma YYTXLark7618Delegate 

- (void)didUserLogin:(YYTXLark7618StatusCode)status {

    NSLog(@"%s %@", __func__, (status==YYTXLark7618LoginSuccessful) ? @"successful":@"failed");
    
    if (YYTXLark7618LoginSuccessful == status) {
        DeviceListViewController *deviceListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceListViewController"];
        deviceListVC.lark7618 = _lark7618;
        if (nil != deviceListVC) {
            [self.navigationController pushViewController:deviceListVC animated:YES];
        }
    }
}

@end
