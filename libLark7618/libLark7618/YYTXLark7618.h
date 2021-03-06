//
//  lark7618.h
//  lark7618
//
//  Created by TTS on 15/10/9.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYTXLark7618Delegate <NSObject>

@optional

/**
 * 功能：FSK发送完成后会调用改函数
 */
- (void)didFSKSendingComplete;

@end


@interface YYTXLark7618 : NSObject
@property (nonatomic, retain, nonnull) id<YYTXLark7618Delegate> delegate;

/** 获取单例 */
+ (nullable instancetype)sharedInstance;

/**
 将SSID和密码以声波的方式发送出去
 @param ssid WI-FI网络名
 @param password Wi-Fi网络的密码
 @note ssid长度不可为0，password的长度可以为0
 */
- (void)sendSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password;

/**
 停止发送FSK声波
 */
- (void)stopSending;

@end

//! Project version number for lark7618.
FOUNDATION_EXPORT double lark7618VersionNumber;

//! Project version string for lark7618.
FOUNDATION_EXPORT const unsigned char lark7618VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <lark7618/PublicHeader.h>


