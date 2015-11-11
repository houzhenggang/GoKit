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
@property (nonatomic, retain) NSMutableArray *arrayUpdateRows;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation MotolControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"电机控制"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _arrayUpdateRows = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice getDeviceStatus]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRemainTimer) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
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
    
    [self addRemainElement:0];
    
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
    
    [self addRemainElement:0];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setMotolSpeed:value]];
}

- (IBAction)sliderMotolSpeedValueChange:(id)sender {
    NSInteger value = _sliderMotolSpeed.value;
    [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @(value)]];
    
    [self addRemainElement:0];
    
    [[[XPGWIFISDKObject shareInstance] selectedDevice] write:[IoTDevice setMotolSpeed:value]];
}

#pragma XPGWIFISDKObjectDelegate

- (void)didDeviceReceivedData:(NSDictionary *)data status:(XPGWIFISDKObjectStatus)status {
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self isElementRemaining:0]) {
                [_labelMotolSpeedValue setText:[NSString stringWithFormat:@"%@", @([IoTDevice motolSpeed])]];
                [_sliderMotolSpeed setValue:[IoTDevice motolSpeed]];
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
