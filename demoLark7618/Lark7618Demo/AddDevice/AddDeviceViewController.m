//
//  DeviceConfigWIFIViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/20.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "ConfigViaFSKViewController.h"
#import "ConfigViaAirLinkViewController.h"
#import "ConfigViaSoftAPViewController.h"
#import "QRCodeViewController.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"添加新设备"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 添加设备－－FSK方式 */
- (IBAction)buttonConfigViaFSKClicked:(id)sender {
    ConfigViaFSKViewController *configViaFSKVC = [[UIStoryboard storyboardWithName:@"FSK" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfigViaFSKViewController"];
    if (nil != configViaFSKVC) {
        [self.navigationController pushViewController:configViaFSKVC animated:YES];
    }
}

/** 添加设备－－AirLink方式 */
- (IBAction)buttonConfigViaAirLinkClicked:(id)sender {
    ConfigViaAirLinkViewController *configViaAirLinkVC = [[UIStoryboard storyboardWithName:@"AirLink" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfigViaAirLinkViewController"];
    if (nil != configViaAirLinkVC) {
        [self.navigationController pushViewController:configViaAirLinkVC animated:YES];
    }
}

/** 
 添加设备－－SoftAP方式 
 @note 通过点击按钮的方式暂时不可用。要使用SoftAP，须先将设备置为SoftAP模式，手机连接到设备的广播出来的SSID，然后重新打开该APP，就可以根据APP提示使用SoftAP来配置网络。
 */
- (IBAction)buttonConfigViaSoftAPClicked:(id)sender {
    ConfigViaSoftAPViewController *configViaSoftAPVC = [[ConfigViaSoftAPViewController alloc] init];
    if (nil != configViaSoftAPVC) {
        [self.navigationController pushViewController:configViaSoftAPVC animated:YES];
    }
}

/** 
 添加设备－－WebConfig方式 
 @note 通过点击按钮的方式暂时不可用。要使用SoftAP，须先将设备置为SoftAP模式，手机连接到设备的广播出来的SSID，然后重新打开该APP，就可以根据APP提示使用SoftAP来配置网络。
 */
- (IBAction)buttonConfigViaWebClicked:(id)sender {

}

/** 添加设备－－扫描二维码方式 */
- (IBAction)buttonQRCodeClicked:(id)sender {
    QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc] init];
    if (nil != QRCodeVC) {
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }
}

@end
