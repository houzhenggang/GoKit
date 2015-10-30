//
//  IoTDevice.h
//  Lark7618Demo
//
//  Created by TTS on 15/10/27.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IoT6f3074fe43894547a4f1314bd7e3ae0b : NSObject

+ (NSDictionary *)getDeviceStatus;
+ (NSDictionary *)setLedSwitch:(NSInteger)ledS;
+ (NSDictionary *)setLedRValue:(NSInteger)ledRValue;
+ (NSDictionary *)setLedGValue:(NSInteger)ledGValue;
+ (NSDictionary *)setLedBValue:(NSInteger)ledBValue;
+ (NSDictionary *)setMotolSpeed:(NSInteger)speed;
+ (NSDictionary *)setInfrade:(NSInteger)infrade;
+ (NSInteger)ledSwitch;
+ (NSInteger)ledRed;
+ (NSInteger)ledGreen;
+ (NSInteger)ledBlue;
+ (NSInteger)motolSpeed;
+ (NSInteger)temperature;
+ (NSInteger)humidity;
+ (NSInteger)infrade;
+ (BOOL)parseReceivedData:(NSDictionary *)data;

@end
