//
//  IoTffaf0cac3d244d07b9da78b5deea8b0b.h
//  Lark7618Demo
//
//  Created by TTS on 15/10/29.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IoTffaf0cac3d244d07b9da78b5deea8b0b : NSObject

/** 获取设备端状态 */
+ (NSDictionary *)getDeviceStatus;

/** 设置LED灯开关 */
+ (NSDictionary *)setLedSwitch:(NSInteger)ledS;

/** 设置红灯亮度 */
+ (NSDictionary *)setLedRValue:(NSInteger)ledRValue;

/** 设置绿灯亮度 */
+ (NSDictionary *)setLedGValue:(NSInteger)ledGValue;

/** 设置蓝灯亮度 */
+ (NSDictionary *)setLedBValue:(NSInteger)ledBValue;

/** 设置点击转速 */
+ (NSDictionary *)setMotolSpeed:(NSInteger)speed;

/**
 设置红外
 @note 无效，设备端硬件尚未支持
 */
+ (NSDictionary *)setInfrade:(NSInteger)infrade;

/** 获取LED灯的开关状态 */
+ (NSInteger)ledSwitch;

/** 获取红色LED的亮度值 */
+ (NSInteger)ledRed;

/** 获取绿色LED的亮度值 */
+ (NSInteger)ledGreen;

/** 获取蓝色LED的亮度值 */
+ (NSInteger)ledBlue;

/** 获取电机的转速 */
+ (NSInteger)motolSpeed;

/** 获取温度值 */
+ (NSInteger)temperature;

/** 获取湿度值 */
+ (NSInteger)humidity;

/** 获取红外值 */
+ (NSInteger)infrade;

/**
 解析从设备端收到的数据
 @return YES 表示收到设备端返回的有效数据，NO表示收到的数据无效
 */
+ (BOOL)parseReceivedData:(NSDictionary *)data;


@end
