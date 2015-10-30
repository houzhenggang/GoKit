//
//  EnvironmentMonitorViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/21.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "EnvironmentMonitorViewController.h"
#import "XPGWIFISDKObject.h"
#import "IoTDevice.h"

@interface EnvironmentMonitorViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UILabel *labelTemperature;
@property (nonatomic, retain) IBOutlet UILabel *labelHumidity;
@property (nonatomic, retain) IBOutlet UISwitch *switchInfrade;

@end

@implementation EnvironmentMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"环境控制"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice getDeviceStatus]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)switchInfradeValueChanged:(UISwitch *)sender {
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setInfrade:sender.isOn]];
}

#pragma XPGWIFISDKObjectDelegate

- (void)didDeviceReceivedData:(NSDictionary *)data status:(XPGWIFISDKObjectStatus)status {
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_labelTemperature setText:[NSString stringWithFormat:@"%@℃", @([IoTDevice temperature])]];
            [_labelHumidity setText:[NSString stringWithFormat:@"%@%%", @([IoTDevice humidity])]];
            [_switchInfrade setOn:[IoTDevice infrade] animated:YES];
        });
    }
}

@end
