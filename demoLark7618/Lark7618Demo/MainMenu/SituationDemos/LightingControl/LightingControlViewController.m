//
//  LightingControlViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/21.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "LightingControlViewController.h"
#import "XPGWIFISDKObject.h"
//#import "IoTDevice.h"

@interface LightingControlViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) IBOutlet UIButton *buttonSwitch;
@property (nonatomic, retain) IBOutlet UILabel *labelLightingRedValue;
@property (nonatomic, retain) IBOutlet UISlider *sliderLightingRed;
@property (nonatomic, retain) IBOutlet UILabel *labelLightingGreenValue;
@property (nonatomic, retain) IBOutlet UISlider *sliderLightingGreen;
@property (nonatomic, retain) IBOutlet UILabel *labelLightingBlueValue;
@property (nonatomic, retain) IBOutlet UISlider *sliderLightingBlue;
@property (nonatomic, retain) NSMutableArray *arrayUpdateRows;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation LightingControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"灯光控制"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _arrayUpdateRows = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice getDeviceStatus]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRemainTimer) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonSwitchClicked:(UIButton *)sender {
    [self addRemainElement:0];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedSwitch:![sender isSelected]]];
}

- (IBAction)buttonLightingRedDecClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingRed.value;
    value--;
    
    if (value <= _sliderLightingRed.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingRed.maximumValue) {
        value = 255;
    }
    
    _sliderLightingRed.value = value;
    [_labelLightingRedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:1];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedRValue:value]];
}

- (IBAction)buttonLightingRedIncClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingRed.value;
    value++;
    
    if (value < _sliderLightingRed.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingRed.maximumValue) {
        value = 255;
    }
    
    _sliderLightingRed.value = value;
    [_labelLightingRedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:1];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedRValue:value]];
}

- (IBAction)sliderLightingRedValueChange:(UISlider *)sender {
    NSInteger value = sender.value;
    [_labelLightingRedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:1];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedRValue:value]];
}

- (IBAction)buttonLightingGreenDecClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingGreen.value;
    value--;
    
    if (value <= _sliderLightingGreen.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingGreen.maximumValue) {
        value = 255;
    }
    
    _sliderLightingGreen.value = value;
    [_labelLightingGreenValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:2];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedGValue:value]];
}

- (IBAction)buttonLightingGreenIncClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingGreen.value;
    value++;
    
    if (value < _sliderLightingGreen.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingGreen.maximumValue) {
        value = 255;
    }
    
    _sliderLightingGreen.value = value;
    [_labelLightingGreenValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:2];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedGValue:value]];
}

- (IBAction)sliderLightingGreenValueChange:(UISlider *)sender {
    NSInteger value = sender.value;
    [_labelLightingGreenValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:2];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedGValue:value]];
}

- (IBAction)buttonLightingBlueDecClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingBlue.value;
    value--;
    
    if (value <= _sliderLightingBlue.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingBlue.maximumValue) {
        value = 255;
    }
    
    _sliderLightingBlue.value = value;
    [_labelLightingBlueValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:3];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedBValue:value]];
}

- (IBAction)buttonLightingBlueIncClicked:(UIButton *)sender {
    NSInteger value = _sliderLightingBlue.value;
    value++;
    
    if (value <= _sliderLightingBlue.minimumValue) {
        value = 0;
    } else if (value > _sliderLightingBlue.maximumValue) {
        value = 255;
    }
    
    _sliderLightingBlue.value = value;
    [_labelLightingBlueValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:3];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedBValue:value]];
}

- (IBAction)sliderLightingBlueValueChange:(UISlider *)sender {
    NSInteger value = sender.value;
    [_labelLightingBlueValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:3];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setLedBValue:value]];
}

#pragma XPGWIFISDKObjectDelegate

- (void)didDeviceReceivedData:(NSDictionary *)data status:(XPGWIFISDKObjectStatus)status {
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![self isElementRemaining:0]) {
                if ([IoTDevice ledSwitch]) {
                    [_buttonSwitch setSelected:YES];
                } else {
                    [_buttonSwitch setSelected:NO];
                }
            }
            
            if (![self isElementRemaining:1]) {
                [_labelLightingRedValue setText:[NSString stringWithFormat:@"%@", @([IoTDevice ledRed])]];
                [_sliderLightingRed setValue:[IoTDevice ledRed] animated:YES];
            }
           
            if (![self isElementRemaining:2]) {
                [_labelLightingGreenValue setText:[NSString stringWithFormat:@"%@", @([IoTDevice ledGreen])]];
                [_sliderLightingGreen setValue:[IoTDevice ledGreen] animated:YES];
            }
            
            if (![self isElementRemaining:3]) {
                [_labelLightingBlueValue setText:[NSString stringWithFormat:@"%@", @([IoTDevice ledBlue])]];
                [_sliderLightingBlue setValue:[IoTDevice ledBlue] animated:YES];
            }
        });
    }
}

#pragma mark - 发控制指令后一段时间内禁止推送
- (void)addRemainElement:(NSInteger)row {
    BOOL isEqual = NO;
    NSNumber *timeout = @3;    // 发控制指令后，等待3s后才可接收指定控件的变更
    
    for(NSMutableDictionary *dict in _arrayUpdateRows) {
        NSNumber *object = [dict valueForKey:@"object"];
        if([object intValue] == row) {
            [dict setValue:timeout forKey:@"remaining"];
            isEqual = YES;
            break;
        }
    }
    
    if(!isEqual) {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:@{@"object": @(row), @"remaining": timeout}];
        [_arrayUpdateRows addObject:mdict];
    }
}

- (void)onRemainTimer {
    //根据系统的 Timer 去更新控件可以变更的剩余时间
    NSMutableArray *removeCtrl = [NSMutableArray array];
    for(NSMutableDictionary *dict in _arrayUpdateRows) {
        int remainTime = [[dict valueForKey:@"remaining"] intValue]-1;
        if(remainTime != 0) {
            [dict setValue:@(remainTime) forKey:@"remaining"];
        } else {
            [removeCtrl addObject:dict];
        }
    }
    [_arrayUpdateRows removeObjectsInArray:removeCtrl];
}

- (BOOL)isElementRemaining:(NSInteger)row {
    //判断某个控件是否能更新内容
    for(NSMutableDictionary *dict in _arrayUpdateRows) {
        NSNumber *object = [dict valueForKey:@"object"];
        if([object intValue] == row) {
            return YES;
        }
    }
    return NO;
}


@end
