//
//  DeviceManagerViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/23.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "UIAlertView+YYTXCustom.h"
#import "DeviceListViewController.h"
#import "XPGWIFISDKObject.h"
#import "QXToast.h"
#import "MBProgressHUD.h"

@interface DeviceManagerViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UILabel *labelDeviceName;
@property (nonatomic, retain) IBOutlet UILabel *labelVolume;
@property (nonatomic, retain) IBOutlet UILabel *labelDate;
@property (nonatomic, retain) IBOutlet UILabel *labelStatusBind;
@property (nonatomic, retain) IBOutlet UIButton *buttonStatusBind;
@property (nonatomic, retain) IBOutlet UILabel *labelMac;
@property (nonatomic, retain) IBOutlet UILabel *labelVersionSoft;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"设备管理"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [XPGWIFISDKObject shareInstance].delegate = self;
    
    [_labelDeviceName setText:[[[XPGWIFISDKObject shareInstance] selectedDevice] productName]];
    if ([[XPGWIFISDKObject shareInstance] deviceIsBind]) {
        [_labelStatusBind setText:@"已绑定"];
        [_buttonStatusBind setSelected:YES];
    } else {
        [_labelStatusBind setText:@"未绑定"];
        [_buttonStatusBind setSelected:NO];
    }
    [_labelMac setText:[[[XPGWIFISDKObject shareInstance] selectedDevice] macAddress]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonStatusBindClicked:(UIButton *)sender {
    
    if ([sender isSelected]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要解除绑定当前设备吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView showAlertViewWithCompleteBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (1 == buttonIndex) {
                
                _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:_hud];
                [_hud setLabelText:@"正在解除绑定..."];
                [_hud show:YES];
                
                [[XPGWIFISDKObject shareInstance] deviceUnbind];
                
            }
        }];
    } else {
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:_hud];
        [_hud setLabelText:@"正在绑定..."];
        [_hud show:YES];
        
        [[XPGWIFISDKObject shareInstance] deviceBind];
    }
}

#pragma XPGWIFISDKObjectDelegate

- (void)didDeviceUnbindStatus:(XPGWIFISDKObjectStatus)status {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_hud hide:YES];
        
        if (XPGWIFISDKObjectStatusSuccessful == status) {
            [QXToast showMessage:@"解绑成功"];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[DeviceListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [QXToast showMessage:@"解绑失败"];
        }
    });
}

- (void)didDeviceBindStatus:(XPGWIFISDKObjectStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud hide:YES];
        if (XPGWIFISDKObjectStatusSuccessful == status) {
            [QXToast showMessage:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [QXToast showMessage:@"绑定失败"];
        }
    });
}

@end
