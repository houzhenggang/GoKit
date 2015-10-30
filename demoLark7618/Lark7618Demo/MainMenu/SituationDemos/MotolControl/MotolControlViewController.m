//
//  MotolControlViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/21.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "MotolControlViewController.h"
#import "XPGWIFISDKObject.h"
#import "IoTDevice.h"

@interface MotolControlViewController () <XPGWIFISDKObjectDelegate>
{
    NSInteger iMotorSpeed;
}
@property (nonatomic, retain) IBOutlet UILabel *labelMotolSpeedValue;
@property (nonatomic, retain) IBOutlet UISlider *sliderMotolSpeed;

@end

@implementation MotolControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"电机控制"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
//    [_sliderMotolSpeed setThumbImage:[UIImage imageNamed:@"Background.png"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice getDeviceStatus]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonMotolSpeedDecClicked:(id)sender {
    NSInteger value = _sliderMotolSpeed.value;
    value--;
    
    if (value < -5) {
        value = -5;
    } else if (value > 5) {
        value = 5;
    }
    
    [_sliderMotolSpeed setValue:value animated:YES];
    [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setMotolSpeed:value]];
}

- (IBAction)buttonMotolSpeedIncClicked:(id)sender {
    NSInteger value = _sliderMotolSpeed.value;
    value++;
    
    if (value < -5) {
        value = -5;
    } else if (value > 5) {
        value = 5;
    }
    
    [_sliderMotolSpeed setValue:value animated:YES];
    [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setMotolSpeed:value]];
}

- (IBAction)sliderMotolSpeedValueChange:(id)sender {
    NSInteger value = _sliderMotolSpeed.value;
    [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setMotolSpeed:value]];
}

#pragma XPGWIFISDKObjectDelegate

- (void)didDeviceReceivedData:(NSDictionary *)data status:(XPGWIFISDKObjectStatus)status {
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @([IoTDevice motolSpeed])]];
            [_sliderMotolSpeed setValue:[IoTDevice motolSpeed]];
        });
    }
}

@end
