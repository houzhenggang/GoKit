//
//  lark7618.h
//  lark7618
//
//  Created by TTS on 15/10/9.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YYTXLark7618StatusCode) {
    YYTXLark7618LoginFailed = -1,
    YYTXLark7618LoginSuccessful,
};

@protocol lark7618Delegate <NSObject>

@optional

/**
 * 功能：FSK发送完成后会调用改函数
 */
- (void)didFSKSendingComplete;

/**
 * 返回用户注册后的状态
 */
- (void)didUserLogin:(YYTXLark7618StatusCode)status;

/**
 * 返回从云端获取的设备列表：在线设备，新设备和离线设备
 */
- (void)didLoadDeviceList:(nonnull NSMutableArray *)onLineDevices newDevices:(nonnull NSMutableArray *)newDevices offLineDevices:(nonnull NSMutableArray *)offLineDevices;

@end


@interface lark7618 : NSObject
@property (nonatomic, retain, nonnull) id<lark7618Delegate> delegate;

/**
 * 功能：初始化YYTXFSK
 * 参数：delegate不能为空
 */
- (nullable instancetype)initWithDelegate:(nonnull id)delegate;

/**
 * 功能：将SSID和密码以声波的方式发送出去
 * 参数：ssid长度不可以为0，password长度可以为0
 */
- (void)sendSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password;

/**
 * 功能：停止发送
 */
- (void)stopSending;

/**
 * 检测网络是否可用
 */
- (BOOL)networkIsReachable;

- (BOOL)isSoftAPMode;

- (void)initAccount;

/**
 * 自动登录：普通用户优先，没有普通用户才自动登录匿名用户
 */
- (void)userLogin;

/**
 * 从云端获取设备列表
 */
- (void)loadDeviceList;

@end

//! Project version number for lark7618.
FOUNDATION_EXPORT double lark7618VersionNumber;

//! Project version string for lark7618.
FOUNDATION_EXPORT const unsigned char lark7618VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <lark7618/PublicHeader.h>


