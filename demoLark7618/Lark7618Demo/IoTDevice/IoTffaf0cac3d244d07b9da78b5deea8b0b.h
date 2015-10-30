//
//  IoTffaf0cac3d244d07b9da78b5deea8b0b.h
//  Lark7618Demo
//
//  Created by TTS on 15/10/29.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IoTffaf0cac3d244d07b9da78b5deea8b0b : NSObject

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
