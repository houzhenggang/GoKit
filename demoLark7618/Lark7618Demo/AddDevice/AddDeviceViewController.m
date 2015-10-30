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

- (IBAction)buttonConfigViaFSKClicked:(id)sender {
    ConfigViaFSKViewController *configViaFSKVC = [[UIStoryboard storyboardWithName:@"FSK" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfigViaFSKViewController"];
    if (nil != configViaFSKVC) {
        [self.navigationController pushViewController:configViaFSKVC animated:YES];
    }
}

- (IBAction)buttonConfigViaAirLinkClicked:(id)sender {
    ConfigViaAirLinkViewController *configViaAirLinkVC = [[UIStoryboard storyboardWithName:@"AirLink" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfigViaAirLinkViewController"];
    if (nil != configViaAirLinkVC) {
        [self.navigationController pushViewController:configViaAirLinkVC animated:YES];
    }
}

- (IBAction)buttonConfigViaSoftAPClicked:(id)sender {
    ConfigViaSoftAPViewController *configViaSoftAPVC = [[ConfigViaSoftAPViewController alloc] init];
    if (nil != configViaSoftAPVC) {
        [self.navigationController pushViewController:configViaSoftAPVC animated:YES];
    }
}

- (IBAction)buttonConfigViaWebClicked:(id)sender {

}

- (IBAction)buttonQRCodeClicked:(id)sender {
    QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc] init];
    if (nil != QRCodeVC) {
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }
}

@end
