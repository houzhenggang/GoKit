//
//  XPGWIFISDKObject.h
//  Lark7618Demo
//
//  Created by TTS on 15/10/15.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IoTDevice.h"
#import <XPGWifiSDK/XPGWifiSDK.h>


typedef NS_ENUM(NSInteger, XPGWIFISDKObjectStatus) {
    /** 无错误 */
    XPGWIFISDKObjectStatusSuccessful = XPGWifiError_NONE,
    /** 一般错误 */
    XPGWIFISDKObjectStatusFailed = XPGWifiError_GENERAL,
    /** 写入数据的操作未执行 */
    XPGWIFISDKObjectStatusNotImplemented = XPGWifiError_NOT_IMPLEMENTED,
    /** 读取或写入数据时，数据长度不在 0-65535 的范围 */
    XPGWIFISDKObjectStatusPacketDataLen = XPGWifiError_PACKET_DATALEN,
    
    /** 错误的连接 ID */
    XPGWIFISDKObjectStatusConnectionId = XPGWifiError_CONNECTION_ID,
    
    /** 连接已关闭 */
    XPGWIFISDKObjectStatusConnectionClosed = XPGWifiError_CONNECTION_CLOSED,
    
    /** 数据包的校验和不正确 */
    XPGWIFISDKObjectStatusPacketChecksum = XPGWifiError_PACKET_CHECKSUM,
    
    /** 登录验证失败 */
    XPGWIFISDKObjectStatusLoginVerifyFailed = XPGWifiError_LOGIN_VERIFY_FAILED,
    
    /** 控制设备时，发现该设备没有登录过 */
    XPGWIFISDKObjectStatusNotLogined = XPGWifiError_NOT_LOGINED,
    
    /** 设备未连接 */
    XPGWIFISDKObjectStatusNotConnected = XPGWifiError_NOT_CONNECTED,
    
    /** 执行 MQTT 相关操作时出错 */
    XPGWIFISDKObjectStatusMQTTFail = XPGWifiError_MQTT_FAIL,
    
    /** 发现小循环设备或者配置 AirLink 时，收到的数据包不能正确解析相关的内容 */
    XPGWIFISDKObjectStatusDiscoveryMismatch = XPGWifiError_DISCOVERY_MISMATCH,
    
    /** 调用 setsockopt() 失败 */
    XPGWIFISDKObjectStatusSetSocketOpt = XPGWifiError_SET_SOCK_OPT,
    
    /** 线程创建失败 */
    XPGWIFISDKObjectStatusThreadCreate = XPGWifiError_THREAD_CREATE,
    
    /** 建立太多的连接，导致连接池满了。最大允许建立 255 个 TCP 连接 */
    XPGWIFISDKObjectStatusConnectionPoolFulled = XPGWifiError_CONNECTION_POOL_FULLED,
    
    /** 大循环操作时，使用了空的 Client ID */
    XPGWIFISDKObjectStatusNullClientId = XPGWifiError_NULL_CLIENT_ID,
    
    /** 连接出现错误 */
    XPGWIFISDKObjectStatusConnectionError = XPGWifiError_CONNECTION_ERROR,
    
    /** 传入了错误的参数 */
    XPGWIFISDKObjectStatusInvalidParam = XPGWifiError_INVALID_PARAM,
    
    /**
     连接超时。默认超时 1 分钟
     */
    XPGWIFISDKObjectStatusConnectTimeout = XPGWifiError_CONNECT_TIMEOUT ,
    
    /** 数据包版本号错误 */
    XPGWIFISDKObjectStatusInvalidVersion = XPGWifiError_INVALID_VERSION ,
    
    /** 不能分配内存 */
    XPGWIFISDKObjectStatusInsuffientMem = XPGWifiError_INSUFFIENT_MEM,
    
    /** 当前线程在使用中 */
    XPGWIFISDKObjectStatusThreadBusy = XPGWifiError_THREAD_BUSY,
    
    /** HTTP 操作失败 */
    XPGWIFISDKObjectStatusHttpFail = XPGWifiError_HTTP_FAIL,
    
    /** 获取 Passcode 失败 */
    XPGWIFISDKObjectStatusGetPasscodeFail = XPGWifiError_GET_PASSCODE_FAIL,
    
    /** 获取 DNS 失败 */
    XPGWIFISDKObjectStatusDNSFailed = XPGWifiError_DNS_FAILED,
    
    /** 配置 on-boarding 时，手机连接的 SSID 与配置设备的 SSID 不一致 */
    XPGWIFISDKObjectStatusConfigureSSIDNotMatched = XPGWifiError_CONFIGURE_SSID_NOT_MATCHED,
    
    /** 配置 on-boarding 超时 */
    XPGWIFISDKObjectStatusConfigureTimeout = XPGWifiError_CONFIGURE_TIMEOUT,
    
    /** 配置 on-boarding 时，发送失败 */
    XPGWIFISDKObjectStatusConfigureSendFailed = XPGWifiError_CONFIGURE_SENDFAILED,
    
    /** 配置错误，执行 Soft-AP 方法但不在 Soft-AP 模式 */
    XPGWIFISDKObjectStatusNotInSoftAPMode = XPGWifiError_NOT_IN_SOFTAPMODE,
    
    /** 接收到了不可识别的数据 */
    XPGWIFISDKObjectStatusUnrecognizedData = XPGWifiError_UNRECOGNIZED_DATA,
    
    /** 不能连接，无法获取到网关 */
    XPGWIFISDKObjectStatusConnectionNoGateway = XPGWifiError_CONNECTION_NO_GATEWAY,
    
    /** 连接被拒绝 */
    XPGWIFISDKObjectStatusConnectionRefused = XPGWifiError_CONNECTION_REFUSED,
    
    /** 当前事件正在处理 */
    XPGWIFISDKObjectStatusIsRunning = XPGWifiError_IS_RUNNING,
    
    /** 不支持的 API */
    XPGWIFISDKObjectStatusUnsupported = XPGWifiError_UNSUPPORTED_API,
    
    XPGWIFISDKObjectStatusUsernameOrPasswordErr = 9020,
};

typedef NS_ENUM(NSInteger, XPGWIFISDKObjectUserType) {
    XPGWIFISDKObjectUserTypeAnonymous,       //匿名用户
    XPGWIFISDKObjectUserTypeNormal,          //普通用户
    XPGWIFISDKObjectUserTypeThird,           //第三方用户
};

@protocol XPGWIFISDKObjectDelegate <NSObject>

@optional
/**
 * 返回用户注册后的状态
 */
- (void)didUserLoginStatus:(XPGWIFISDKObjectStatus)status;

- (void)didUserLogoutStatus:(XPGWIFISDKObjectStatus)status;

/**
 * 返回从云端获取的设备列表：在线设备，新设备和离线设备
 */
- (void)didLoadDeviceList:(nonnull NSMutableArray *)onLineDevices newDevices:(nonnull NSMutableArray *)newDevices offLineDevices:(nonnull NSMutableArray *)offLineDevices;

- (void)didDeviceBindStatus:(XPGWIFISDKObjectStatus)status;

- (void)didDeviceLoginStatus:(XPGWIFISDKObjectStatus)status;

- (void)didDeviceUnbindStatus:(XPGWIFISDKObjectStatus)status;

- (void)didDeviceReceivedData:(nullable NSDictionary *)data status:(XPGWIFISDKObjectStatus)status;

- (void)didDeviceDisconnected:(nullable XPGWifiDevice *)device;

- (void)didRequsetVerifyPictureStatus:(XPGWIFISDKObjectStatus)status captchaURL:(nullable NSString*)captchaURL;

- (void)didGetPhoneVerifyCodeStatus:(XPGWIFISDKObjectStatus)status;

- (void)didChangeAccountPasswordStatus:(XPGWIFISDKObjectStatus)status;

- (void)didRegisterAccountStatus:(XPGWIFISDKObjectStatus)status;

- (void)didConfigWIFIStatus:(XPGWIFISDKObjectStatus)status;

- (void)didLoadSSIDList:(nonnull NSArray *)SSIDList status:(XPGWIFISDKObjectStatus)status;

@end

@interface XPGWIFISDKObject : NSObject
@property (nonatomic, retain, nullable) id<XPGWIFISDKObjectDelegate> delegate;
@property (nonatomic, retain, nullable) XPGWifiDevice *selectedDevice;

// 基本的用户数据
@property (strong, nonatomic, nonnull) NSString *username;   //用户名
@property (strong, nonatomic, nonnull) NSString *password;   //密码

// 用户 SESSION
@property (strong, nonatomic, nonnull) NSString *uid;        //uid
@property (strong, nonatomic, nonnull) NSString *token;      //token
@property (assign, nonatomic) XPGWIFISDKObjectUserType userType; //用户类型，第三方用户 Demo App 不支持

@property (readonly, nonatomic) BOOL isRegisteredUser;  //匿名用户是否已注册

+ (nullable instancetype)shareInstance;

- (void)start;

- (void)initAccount;

- (void)userLoginWithUserName:(nonnull NSString *)name password:(nonnull NSString *)password;

- (void)userLogout;

- (void)requestVerifyPicture;

- (void)getPhoneVerifyCodeWithPhoneNumber:(nonnull NSString *)phoneNumber pictureVerifyCode:(nonnull NSString *)code;

- (BOOL)isSoftAPMode;

/**
 * 自动登录：普通用户优先，没有普通用户才自动登录匿名用户
 */
- (void)userLogin;

/**
 * 当WIFI在SoftAP模式下时，配置WLAN的SSID和Password
 */
- (void)configSoftAPModeSSID:(nonnull NSString *)ssid andPassword:(nonnull NSString *)password;

- (void)configureAirLinkModeSSID:(nonnull NSString *)ssid andPassword:(nonnull NSString *)password timeout:(int)time;

- (void)loadSSID;

/**
 * 从云端获取设备列表
 */
- (void)loadBoundDevices;

/**
 * 登录设备
 */
- (void)deviceLogin;

- (BOOL)deviceIsBind;

/**
 * 绑定设备
 */
- (void)deviceBind;

- (void)bindDeviceId:(nonnull NSString *)did passcode:(nonnull NSString *)passcode remark:(nonnull NSString *)remark;

- (void)deviceUnbind;

@end
