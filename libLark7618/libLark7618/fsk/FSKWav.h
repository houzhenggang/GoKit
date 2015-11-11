//
//  FSKWav.h
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSKWav : NSObject

/**
 将ssid和密码生成声波数据
 @param ssid Wi-Fi网络名
 @param password Wi-Fi网络的密码
 @return 返回生成的声波数据
 @note ssid长度不可为0，password长度可为0。ssid长度为0时返回为nil
 */
+ (nullable NSData *)generateWithSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password;

@end
