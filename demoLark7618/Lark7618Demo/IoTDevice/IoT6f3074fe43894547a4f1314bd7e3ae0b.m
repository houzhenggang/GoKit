//
//  IoTDevice.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/27.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "IoT6f3074fe43894547a4f1314bd7e3ae0b.h"
#import "QXToast.h"

static NSInteger iLedS = 0;
static NSInteger iLedR = 0;
static NSInteger iLedG = 0;
static NSInteger iLedB = 0;
static NSInteger iMotorSpeed = 0;
static NSInteger iTemperature = 0;
static NSInteger iHumidity = 0;
static NSInteger iIr = 0;

typedef NS_ENUM(NSInteger, IoTDeviceCommand) {
    IoTDeviceCommandWrite = 1,      //写
    IoTDeviceCommandRead = 2,       //读
    IoTDeviceCommandResponse = 3,   //读响应
    IoTDeviceCommandNotify = 4,     //通知
};

#define DATA_CMD                        @"cmd"      //命令
#define DATA_ENTITY                     @"entity0"  //实体
#define DATA_ATTR_LED_R_ONOFF           @"LED_OnOff"    //属性：LED R开关
#define DATA_ATTR_LED_COLOR             @"LED_Color"    //属性：LED 组合颜色
#define DATA_ATTR_LED_R                 @"LED_R"    //属性：LED R值
#define DATA_ATTR_LED_G                 @"LED_G"    //属性：LED G值
#define DATA_ATTR_LED_B                 @"LED_B"    //属性：LED B值
#define DATA_ATTR_MOTORSPEED            @"Motor_Speed"    //属性：电机转速
#define DATA_ATTR_IR                    @"Infrared"    //属性：红外探测
#define DATA_ATTR_TEMPERATURE           @"Temperature"    //属性：温度
#define DATA_ATTR_HUMIDITY              @"Humidity"    //属性：湿度
#define DATA_ALERTS                     @"alerts" // 设备报警
#define DATA_FAULTS                     @"faults" // 设备错误
#define DATA_DATA                       @"data"

@implementation IoT6f3074fe43894547a4f1314bd7e3ae0b

/** 获取设备端状态 */
+ (NSDictionary *)getDeviceStatus {
    return @{DATA_CMD: @(IoTDeviceCommandRead)};
}

/** 设置LED灯开关 */
+ (NSDictionary *)setLedSwitch:(NSInteger)ledS {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_LED_R_ONOFF:@(ledS)}};
}

/** 设置红灯亮度 */
+ (NSDictionary *)setLedRValue:(NSInteger)ledRValue {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_LED_R:@(ledRValue)}};
}

/** 设置绿灯亮度 */
+ (NSDictionary *)setLedGValue:(NSInteger)ledGValue {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_LED_G:@(ledGValue)}};
}

/** 设置蓝灯亮度 */
+ (NSDictionary *)setLedBValue:(NSInteger)ledBValue {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_LED_B:@(ledBValue)}};
}

/** 设置点击转速 */
+ (NSDictionary *)setMotolSpeed:(NSInteger)speed {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_MOTORSPEED:@(speed)}};
}

/** 
 设置红外
 @note 无效，设备端硬件尚未支持
 */
+ (NSDictionary *)setInfrade:(NSInteger)infrade {
    return @{DATA_CMD: @(IoTDeviceCommandWrite), DATA_ENTITY: @{DATA_ATTR_IR: @(infrade)}};
}

/** 解析从设备端收到的数据 */
+ (BOOL)parseReceivedData:(NSDictionary *)data {
    NSString *str = @"";
    BOOL needToDisplay = NO;
    
    /** 设备端报警 */
    NSArray *alerts = [data valueForKey:DATA_ALERTS];
    if(alerts.count > 0) {
        str = @"设备报警：";
        for(NSDictionary *dict in alerts) {
            for(NSString *name in dict.allKeys) {
                NSNumber *value = [dict valueForKey:name];
                if (value.integerValue) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%@ 错误码：%@", name, value]];
                    needToDisplay = YES;
                }
            }
        }
        
        if (needToDisplay) {
            [QXToast showMessage:str];
        }

    }
    
    /** 设备端错误 */
    NSArray *faults = [data valueForKey:DATA_FAULTS];
    if(faults.count > 0) {
        NSString *title = @"设备异常";
        NSString *message = @"";
        needToDisplay = NO;

        for(NSDictionary *dict in faults) {
            for(NSString *name in dict.allKeys) {
                NSNumber *value = [dict valueForKey:name];
                if (value.integerValue) {
                    message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@ 错误码：%@", name, value]];
                    needToDisplay = YES;
                }
            }
        }
        
        if (needToDisplay) {
            [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        }
    }
    
    
    /** NSDictionary */
    NSDictionary *dataDic = [data valueForKey:DATA_DATA];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error: could not read data, error data format.");
        return NO;
    }
    
    NSNumber *nCommand = [dataDic valueForKey:DATA_CMD];
    if(![nCommand isKindOfClass:[NSNumber class]]) {
        NSLog(@"Error: could not read cmd, error cmd format.");
        return NO;
    }
    
    int nCmd = [nCommand intValue];
    if(nCmd != IoTDeviceCommandResponse && nCmd != IoTDeviceCommandNotify) {
        NSLog(@"Error: command is invalid, skip.");
        return NO;
    }
    
    NSDictionary *attributes = [dataDic valueForKey:DATA_ENTITY];
    if(![attributes isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error: could not read attributes, error attributes format.");
        return NO;
    }
    
    /** 解析各外设的状态 */
    NSString *ledRonOff = [attributes valueForKey:DATA_ATTR_LED_R_ONOFF];
    NSString *ledR = [attributes valueForKey:DATA_ATTR_LED_R];
    NSString *ledG = [attributes valueForKey:DATA_ATTR_LED_G];
    NSString *ledB = [attributes valueForKey:DATA_ATTR_LED_B];
    NSString *motorSpeed = [attributes valueForKey:DATA_ATTR_MOTORSPEED];
    NSString *temperature = [attributes valueForKey:DATA_ATTR_TEMPERATURE];
    NSString *humidity = [attributes valueForKey:DATA_ATTR_HUMIDITY];
    NSString *ir = [attributes valueForKey:DATA_ATTR_IR];

    iLedS = [ledRonOff integerValue];
    iLedR = [ledR integerValue];
    iLedG = [ledG integerValue];
    iLedB = [ledB integerValue];
    iMotorSpeed = [motorSpeed integerValue];
    iTemperature = [temperature integerValue];
    iTemperature += 13;
    iHumidity = [humidity integerValue];
    iIr = [ir integerValue];
    
    return YES;
}

/** 获取LED灯的开关状态 */
+ (NSInteger)ledSwitch {
    return iLedS;
}

/** 获取红色LED的亮度值 */
+ (NSInteger)ledRed {
    return iLedR;
}

/** 获取绿色LED的亮度值 */
+ (NSInteger)ledGreen {
    return iLedG;
}

/** 获取蓝色LED的亮度值 */
+ (NSInteger)ledBlue {
    return iLedB;
}

/** 获取电机的转速 */
+ (NSInteger)motolSpeed {
    return iMotorSpeed;
}

/** 获取温度值 */
+ (NSInteger)temperature {
    return iTemperature;
}

/** 获取湿度值 */
+ (NSInteger)humidity {
    return iHumidity;
}

/** 获取红外值 */
+ (NSInteger)infrade {
    return iIr;
}

@end
