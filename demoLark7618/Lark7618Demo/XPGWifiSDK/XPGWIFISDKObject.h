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

/** 用户注册操作的回调 */
- (void)didUserLoginStatus:(XPGWIFISDKObjectStatus)status;

/** 用户退出操作的回调 */
- (void)didUserLogoutStatus:(XPGWIFISDKObjectStatus)status;

/** 
 返回从云端获取的设备列表：在线设备，新设备和离线设备 
 @param onLineDevices 在线设备列表
 @param newDevices 新设备列表
 @param offLineDevices 离线设备列表
 */
- (void)didLoadDeviceList:(nonnull NSMutableArray *)onLineDevices newDevices:(nonnull NSMutableArray *)newDevices offLineDevices:(nonnull NSMutableArray *)offLineDevices;

/** 设备绑定操作的回调 */
- (void)didDeviceBindStatus:(XPGWIFISDKObjectStatus)status;

/** 设备登录操作的回调 */
- (void)didDeviceLoginStatus:(XPGWIFISDKObjectStatus)status;

/** 设备解绑操作的回调 */
- (void)didDeviceUnbindStatus:(XPGWIFISDKObjectStatus)status;

/** 接收到设备端发出的数据的回调 */
- (void)didDeviceReceivedData:(nullable NSDictionary *)data status:(XPGWIFISDKObjectStatus)status;

/** 设备断开连接的回调 */
- (void)didDeviceDisconnected:(nullable XPGWifiDevice *)device;

/** 
 接收到服务器返回的图片验证码回调
 @param captchaURL 图片的url
 */
- (void)didRequsetVerifyPictureStatus:(XPGWIFISDKObjectStatus)status captchaURL:(nullable NSString*)captchaURL;

/** 获取手机验证码操作的回调 */
- (void)didGetPhoneVerifyCodeStatus:(XPGWIFISDKObjectStatus)status;

/** 更改帐号密码操作的回调 */
- (void)didChangeAccountPasswordStatus:(XPGWIFISDKObjectStatus)status;

/** 注册帐号的回调 */
- (void)didRegisterAccountStatus:(XPGWIFISDKObjectStatus)status;

/** 配置WIFI参数回调 */
- (void)didConfigWIFIStatus:(XPGWIFISDKObjectStatus)status;

/** 获取设备端扫描到SSID列表操纵的回调 */
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

/** 获取该类的单例 */
+ (nullable instancetype)shareInstance;

/** 启动XPGWifiSDK */
- (void)start;

/** 
 使用电话号码注册帐号
 @param phone 手机号码
 @param password 设置的帐号密码
 @param code 手机收到的短信验证码
 */
- (void)registerAccountWithPhoneNumber:(nonnull NSString *)phone password:(nonnull NSString *)password messageCode:(nonnull NSString *)code;

/** 
 使用用户名注册帐号
 @param name 用户名
 @param password 设置的帐号密码
 */
- (void)registerAccountWithUserName:(nonnull NSString *)name password:(nonnull NSString *)password;

/** 
 使用邮箱注册帐号 
 @param email 邮箱地址
 @param password 设置的帐号密码
 */
- (void)registerAccountWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password;

/** 
 更改手机号账户的密码
 @param phone 手机号
 @param password 新密码
 @param code 手机受到的验证码
 */
- (void)changePasswordWithAccountPhone:(nonnull NSString *)phone newPassword:(nonnull NSString *)password messageCode:(nonnull NSString *)code;

/** 
 更改邮箱账户的密码
 @param email 邮箱地址
 */
- (void)changePasswordWithAccountEmail:(nonnull NSString *)email;

/** 
 更改账户密码
 @param oldPassword 旧密码
 @param newPassword 新密码
 */
- (void)changeUserPassword:(nonnull NSString *)oldPassword newPassword:(nonnull NSString *)newPasswoard;

/** 
 账户登录
 @param name 账户名
 @param password 密码
 */
- (void)userLoginWithUserName:(nonnull NSString *)name password:(nonnull NSString *)password;

/** 帐号退出 */
- (void)userLogout;

/** 请求图片验证码 */
- (void)requestVerifyPicture;

/**
 用图片验证码获取手机验证码
 @param phoneNumber 手机号码
 @param code 图片验证码
 */
- (void)getPhoneVerifyCodeWithPhoneNumber:(nonnull NSString *)phoneNumber pictureVerifyCode:(nonnull NSString *)code;

/** 判断手机WIFI当前是否已连接到工作在SoftAP模式的设备上 */
- (BOOL)isSoftAPMode;

/** 
 使用SoftAP配置设备的SSID和Password
 @param ssid WI-FI的SSID
 @param password WIFI的密码
 */
- (void)configSoftAPModeSSID:(nonnull NSString *)ssid andPassword:(nonnull NSString *)password;

/** 
 使用AirLink配置设备的SSID和password
 @param ssid WI-FI的SSID
 @param password WIFI的password
 @param time 配置超时时间
 */
- (void)configureAirLinkModeSSID:(nonnull NSString *)ssid andPassword:(nonnull NSString *)password timeout:(int)time;

/** 获取设备端扫描的SSID列表 */
- (void)loadSSID;

/** 从云端获取设备列表 */
- (void)loadBoundDevices;

/** 登录设备selectedDevice */
- (void)deviceLogin;

/** selectedDevice是否已与当前的帐号绑定 */
- (BOOL)deviceIsBind;

/** 将selectedDevice绑定到当前帐号 */
- (void)deviceBind;

/** 
 将设备绑定到当前帐号，当前仅用于二维码扫描到设备后的绑定
 @param did 设备的id
 @param passcode
 @param remark
 */
- (void)bindDeviceId:(nonnull NSString *)did passcode:(nonnull NSString *)passcode remark:(nonnull NSString *)remark;

/** 将selectedDevice与当前帐号解绑 */
- (void)deviceUnbind;

@end
