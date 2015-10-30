//
//  XPGWIFISDKObject.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/15.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "XPGWIFISDKObject.h"
#import "IoTWifiUtil.h"
#import <UIKit/UIKit.h>

static NSString *const IOT_APPKEY = @"a8c99b3da6b24dfba599bf671ab72669";
static NSString *const IOT_PRODUCT1 = @"6f3074fe43894547a4f1314bd7e3ae0b";
static NSString *const IOT_PRODUCT2 = @"ffaf0cac3d244d07b9da78b5deea8b0b";
static NSString *const AppSecret = @"17ad9b0c76dc4adf9e195be3c215f59b";

static XPGWIFISDKObject *xpgObjectInstance = nil;


@interface XPGWIFISDKObject () <XPGWifiSDKDelegate, XPGWifiDeviceDelegate>

@property (nonatomic, retain) NSString *captchatoken;
@property (nonatomic, retain) NSString *captchaId;
@property (nonatomic, retain) NSString *captchaURL;


@end

@implementation XPGWIFISDKObject

#pragma XPGWIFISDKObject 单实例方法

+ (instancetype)shareInstance {
    
    if(xpgObjectInstance == nil) {
        
        xpgObjectInstance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
#if 0
        // 拷贝配置文件到 /Documents/XPGWifiSDK/Devices 目录
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSLog(@"%s filePath:%@", __func__, filePath);
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"Invalid json file, skip.");
            abort();
        } else {
            NSString *destPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            destPath = [destPath stringByAppendingPathComponent:@"XPGWifiSDK/Devices"];
            
            // 创建目录
            [[NSFileManager defaultManager] createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            destPath = [destPath stringByAppendingFormat:@"/%@.json", IOT_PRODUCT];
            
            // 把文件复制到指定的目录
            if(![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
                if(![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:nil]) {
                    NSLog(@"Can't copy file to /Documents/Devices");
                    abort();
                }
            }
        }
#endif
    }
    
    return xpgObjectInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [XPGWIFISDKObject shareInstance];
}

- (id)copy {
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

#pragma XPGWifiSDK 方法

- (void)start {

    // 初始化 Wifi SDK
    [XPGWifiSDK startWithAppID:IOT_APPKEY];
            
    // 为 Soft AP 模式设置 SSID 名。如果没设置，默认值是 XPG-GAgent, XPG_GAgent
//    [XPGWifiSDK registerSSIDs:@"XPG-GAgent", @"XPG_GAgent", nil];
            
    // 设置日志分级、日志输出文件、是否打印二进制数据
//    [XPGWifiSDK setLogLevel:XPGWifiLogLevelAll logFile:@"logfile.txt" printDataLevel:YES];
            
    // 设置 SDK Delegate
    [XPGWifiSDK sharedInstance].delegate = self;
}

- (void)initAccount {
    
    if(!self.isRegisteredUser) {
        [[XPGWifiSDK sharedInstance] userLoginAnonymous]; // 如果未注册匿名用户，系统会自动注册一个匿名用户
    } else {
        [self userLogin]; // 用户已注册，直接登录
    }
}

- (void)userLoginWithUserName:(NSString *)name password:(NSString *)password {

    [[XPGWifiSDK sharedInstance] userLoginWithUserName:name password:password];
}

- (void)userLogout {
    
    [[XPGWifiSDK sharedInstance] userLogout:self.uid];
}

- (void)getPhoneVerifyCodeWithPhoneNumber:(NSString *)phoneNumber pictureVerifyCode:(NSString *)code {

    [[XPGWifiSDK sharedInstance] requestSendPhoneSMSCode:_captchatoken captchaId:_captchaId captchaCode:code phone:phoneNumber];
}

- (void)requestVerifyPicture {
    
    [[XPGWifiSDK sharedInstance] getCaptchaCode:AppSecret];
}

- (BOOL)isSoftAPMode {
    [XPGWifiSDK sharedInstance].delegate = self;
    
    // 检测到 Soft AP 模式，自动跳转，无需登录
    // 防止页面过快的自动跳转，延迟 0.5s
    if([IoTWifiUtil isSoftAPMode:@"XPG-GAgent"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadBoundDevices {
    
    NSLog(@"%s uid:%@, token:%@", __func__, self.uid, self.token);

    [[XPGWifiSDK sharedInstance] getBoundDevicesWithUid:self.uid token:self.token specialProductKeys:IOT_PRODUCT1, IOT_PRODUCT2, nil];
}

#pragma XPGWifiDevice 方法

- (void)deviceLogin {
    [_selectedDevice login:self.uid token:self.token];
}

- (BOOL)deviceIsBind {
    return [_selectedDevice isBind:self.uid];
}

- (void)deviceBind {
    [[XPGWifiSDK sharedInstance] bindDeviceWithUid:self.uid token:self.token did:_selectedDevice.did passCode:nil remark:nil];
}

- (void)bindDeviceId:(NSString *)did passcode:(NSString *)passcode remark:(NSString *)remark {
    [[XPGWifiSDK sharedInstance] bindDeviceWithUid:self.uid token:self.token did:did passCode:passcode remark:remark];
}

- (void)deviceUnbind {
    [[XPGWifiSDK sharedInstance] unbindDeviceWithUid:self.uid token:self.token did:_selectedDevice.did passCode:nil];
}

#pragma mark - Properties

#define DefaultSetValue(key, value) \
[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];

#define DefaultGetValue(key) \
[[NSUserDefaults standardUserDefaults] valueForKey:key];

- (void)setSelectedDevice:(XPGWifiDevice *)selectedDevice {
    
    _selectedDevice.delegate = nil;

    _selectedDevice = selectedDevice;
    _selectedDevice.delegate = self;
}

- (void)setUsername:(NSString *)username {
    
    DefaultSetValue(@"username", username);
}

- (void)setPassword:(NSString *)password {
    
    DefaultSetValue(@"password", password);
}

- (NSString *)username {
    
    return DefaultGetValue(@"username")
}

- (NSString *)password {
    
    return DefaultGetValue(@"password")
}

- (void)setUid:(NSString *)uid {
    
    DefaultSetValue(@"uid", uid)
}

- (void)setUserType:(XPGWIFISDKObjectUserType)userType {
    
    DefaultSetValue(@"userType", @(userType))
}

- (void)setToken:(NSString *)token {
    
    DefaultSetValue(@"token", token)
}

- (NSString *)uid {
    
    return DefaultGetValue(@"uid")
}

- (NSString *)token {
    
    return DefaultGetValue(@"token")
}

- (XPGWIFISDKObjectUserType)userType {
    NSNumber *nAnymous = DefaultGetValue(@"userType")
    
    if(nil != nAnymous) {
        return (XPGWIFISDKObjectUserType)[nAnymous intValue];
    }
    
    return XPGWIFISDKObjectUserTypeAnonymous;
}

- (BOOL)isRegisteredUser {
    
    return (self.uid.length > 0 && self.token.length > 0);
}

#pragma mark - Other Common Functions

- (void)userLogin {
    
    switch (self.userType) {
        case XPGWIFISDKObjectUserTypeAnonymous:
            [[XPGWifiSDK sharedInstance] userLoginAnonymous];
            break;
        case XPGWIFISDKObjectUserTypeNormal:
            [[XPGWifiSDK sharedInstance] userLoginWithUserName:self.username password:self.password];
            break;
        case XPGWIFISDKObjectUserTypeThird:
            NSLog(@"Error: Third account type is not supported");
            break;
        default:
            NSLog(@"Error: invalid configure.");
            break;
    }
}

#pragma SoftAP模式下配置SSID和密码

/**
 * 获取WIFI在SoftAP模式下搜索到的SSID列表
 */
- (void)loadSSID {
    
    [[XPGWifiSDK sharedInstance] getSSIDList];
}

/**
 * 当WIFI在SoftAP模式下时，配置WLAN的SSID和Password
 */
- (void)configSoftAPModeSSID:(NSString *)ssid andPassword:(NSString *)password {
    
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid key:password mode:XPGWifiSDKSoftAPMode softAPSSIDPrefix:@"XPG-GAgent" timeout:30 wifiGAgentType:nil];
}

#pragma AirLink模式下配置SSID和密码

- (void)configureAirLinkModeSSID:(NSString *)ssid andPassword:(NSString *)password timeout:(int)time {
    
    NSLog(@"%s ssid:%@ password:%@ timeout:%@", __func__, ssid, password, @(time));
    
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid key:password mode:XPGWifiSDKAirLinkMode softAPSSIDPrefix:nil timeout:time wifiGAgentType:@[@(XPGWifiGAgentTypeHF)]];
}

#pragma mark - XPGWifiSDK delegate 回调

/* 用户登录回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogin:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token {
    // 登录成功，自动设置相关信息
    NSLog(@"-----------------------> UserLogin result:%d", [error intValue]);
    
    if ([error intValue] || uid.length == 0 || token.length == 0) {
        
        NSLog(@"-----------------------> UserLogin errorMassage:%@", errorMessage);

        if ([_delegate respondsToSelector:@selector(didUserLoginStatus:)]) {
            if (9020 == [error intValue]) {
                [_delegate didUserLoginStatus:XPGWIFISDKObjectStatusUsernameOrPasswordErr];
            } else {
                [_delegate didUserLoginStatus:XPGWIFISDKObjectStatusFailed];
            }
        }
    } else {
        
        NSLog(@"-----------------------> UserLogin uid:%@ token:%@", uid, token);
        
        self.uid = uid;
        self.token = token;
        
#pragma 登录成功，转到设备列表界面，获取设备列表
        if ([_delegate respondsToSelector:@selector(didUserLoginStatus:)]) {
            [_delegate didUserLoginStatus:XPGWIFISDKObjectStatusSuccessful];
        }
    }
}

/* 用户注销账号回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogout:(NSNumber *)error errorMessage:(NSString *)errorMessage {

    NSLog(@"%s errorCode:%d errorMessage:%@", __func__, error.integerValue, errorMessage);
    
    if ([_delegate respondsToSelector:@selector(didUserLogoutStatus:)]) {
        if (XPGWifiError_NONE == error.integerValue) {
            self.uid = @"";
            self.token = @"";
            [_delegate didUserLogoutStatus:XPGWIFISDKObjectStatusSuccessful];
        } else {
            [_delegate didUserLogoutStatus:XPGWIFISDKObjectStatusFailed];
        }
    }
}

/* 获取图片验证码回调 */
- (void)wifiSDK:(XPGWifiSDK *)wifiSDK didGetCaptchaCode:(NSError *)result token:(NSString*)token captchaId:(NSString *)captchaId captchaURL:(NSString*)captchaURL {
    
    NSLog(@"%s result:%@, token:%@ captchaId:%@ captchaURL:%@", __func__, result, token, captchaId, captchaURL);

    if ([_delegate respondsToSelector:@selector(didRequsetVerifyPictureStatus:captchaURL:)]) {
        if (XPGWifiError_NONE == result.code) {
            _captchatoken = token;
            _captchaId = captchaId;
            
            [_delegate didRequsetVerifyPictureStatus:XPGWIFISDKObjectStatusSuccessful captchaURL:captchaURL];
        } else {
            [_delegate didRequsetVerifyPictureStatus:XPGWIFISDKObjectStatusFailed captchaURL:captchaURL];
        }
    }
}

/* 请求发送短信验证码回调 */
- (void)wifiSDK:(XPGWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError*)result {
    
    NSLog(@"%s result:%@", __func__, result);

    if ([_delegate respondsToSelector:@selector(didGetPhoneVerifyCodeStatus:)]) {
        if (XPGWifiError_NONE == result.code) {
            [_delegate didGetPhoneVerifyCodeStatus:XPGWIFISDKObjectStatusSuccessful];
        } else {
            [_delegate didGetPhoneVerifyCodeStatus:XPGWIFISDKObjectStatusFailed];
        }
    }
}

/* 修改用户密码回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didChangeUserPassword:(NSNumber *)error errorMessage:(NSString *)errorMessage {
    
    NSLog(@"%s error:%@ errorMessage:%@", __func__, error, errorMessage);

    if ([_delegate respondsToSelector:@selector(didChangeAccountPasswordStatus:)]) {
        if (XPGWifiError_NONE == error.integerValue) {
            [_delegate didChangeAccountPasswordStatus:XPGWIFISDKObjectStatusSuccessful];
        } else {
            [_delegate didChangeAccountPasswordStatus:XPGWIFISDKObjectStatusFailed];
        }
    }
}

/* 用户注册回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didRegisterUser:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token {
    
    NSLog(@"%s error:%@ errorMessage:%@ uid:%@ token:%@", __func__, error, errorMessage, uid, token);
    
    if ([_delegate respondsToSelector:@selector(didRegisterAccountStatus:)]) {
     
        if (XPGWifiError_NONE == error.integerValue) {
            
            self.uid = uid;
            self.token = token;
            
            [_delegate didRegisterAccountStatus:XPGWIFISDKObjectStatusSuccessful];
        } else {
            [_delegate didRegisterAccountStatus:XPGWIFISDKObjectStatusFailed];
        }
    }
}

/* 返回获取到的SSID列表，result为0时有效 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didGetSSIDList:(NSArray *)ssidList result:(int)result {
    
    if ([_delegate respondsToSelector:@selector(didLoadSSIDList:status:)]) {
        [_delegate didLoadSSIDList:ssidList status:[self getObjectStatusFromSdkCode:(XPGWifiErrorCode)result]];
    }
}

/* 配置SSID和Password的回调，result为0时表示配置成功 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result {
    
    NSLog(@"%s result:%d", __func__, result);
    
    if ([_delegate respondsToSelector:@selector(didConfigWIFIStatus:)]) {

        [_delegate didConfigWIFIStatus:[self getObjectStatusFromSdkCode:(XPGWifiErrorCode)result]];
    }
}

/* 从云端获取设备列表后回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didDiscovered:(NSArray *)deviceList result:(int)result {
    
    NSLog(@"%s deviceList:%@", __func__, deviceList);
    
    //分类
    NSMutableArray
    *arr1 = [NSMutableArray array], //在线
    *arr2 = [NSMutableArray array], //新设备
    *arr3 = [NSMutableArray array]; //不在线
    
    for(XPGWifiDevice *device in deviceList) {
        if (device.isDisabled) {
            continue;
        }
        
        if(device.isLAN && ![device isBind:self.uid]) {
            [arr2 addObject:device];
            continue;
        }
        
        if(device.isLAN || device.isOnline) {
            [arr1 addObject:device];
            continue;
        }
        
        [arr3 addObject:device];
    }
    
    if ([_delegate respondsToSelector:@selector(didLoadDeviceList:newDevices:offLineDevices:)]) {
        [_delegate didLoadDeviceList:arr1 newDevices:arr2 offLineDevices:arr3];
    }
}

- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUpdateProduct:(NSString *)product result:(int)result {
    
    NSLog(@"%s product:%@ result:%d", __func__, product, result);
    
    if(result == -25) {
        
    }
}

#pragma XPGWifiDeviceDelegate

/* 设备登录回调，result为0表示成功 */
- (void)XPGWifiDevice:(XPGWifiDevice *)device didLogin:(int)result {
    
    NSLog(@"%s device:%@ result:%d", __func__, device, result);
    
    if([_selectedDevice.macAddress isEqualToString:device.macAddress] &&
       [_selectedDevice.did isEqualToString:device.did]) {

        if(result == 0) {
            
            if ([_delegate respondsToSelector:@selector(didDeviceLoginStatus:)]) {
                [_delegate didDeviceLoginStatus:XPGWIFISDKObjectStatusSuccessful];
            }
        } else {
            if(_selectedDevice) {
                if(_selectedDevice.isConnected) {
                    [_selectedDevice disconnect];

                }
            }
            
            if ([_delegate respondsToSelector:@selector(didDeviceLoginStatus:)]) {
                [_delegate didDeviceLoginStatus:XPGWIFISDKObjectStatusFailed];
            }
        }
    }
}

/* 设备绑定的回调接口，返回设备绑定的结果 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage {
    
    NSLog(@"%s did:%@ error:%@ errorMessage:%@", __func__, did, error, errorMessage);
    
    if (![error intValue]) {
        if ([_delegate respondsToSelector:@selector(didDeviceBindStatus:)]) {
            [_delegate didDeviceBindStatus:XPGWIFISDKObjectStatusSuccessful];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(didDeviceBindStatus:)]) {
            [_delegate didDeviceBindStatus:XPGWIFISDKObjectStatusFailed];
        }
    }
}

/* 设备解绑的回调接口，返回设备解绑的结果 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUnbindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage {
    
    if([_selectedDevice.did isEqualToString:did]) {
        //为了防止解除绑定和断开连接的时间冲突，先把 device.delegate 赋空
        _selectedDevice.delegate = nil;
        
        //处理解绑事件
        if ([_delegate respondsToSelector:@selector(didDeviceUnbindStatus:)]) {
            if ([error intValue] == 0) {
                [_delegate didDeviceUnbindStatus:XPGWIFISDKObjectStatusSuccessful];
            } else {
                [_delegate didDeviceUnbindStatus:XPGWIFISDKObjectStatusFailed];
            }
            
        }
    }
}

/* 设备状态变化的回调接口，返回设备上报的数据内容，包括设备控制命令的应答、设备运行状态的上报、设备报警、设备故障信息 */
- (void)XPGWifiDevice:(XPGWifiDevice *)device didReceiveData:(NSDictionary *)data result:(int)result {
    
    NSLog(@"%s result:%d", __func__, result);

    if (XPGWifiError_NONE == result) {
        BOOL ret = [IoTDevice parseReceivedData:data];
        if ([_delegate respondsToSelector:@selector(didDeviceReceivedData:status:)]) {
            if (ret) {
                [_delegate didDeviceReceivedData:data status:XPGWIFISDKObjectStatusSuccessful];
            } else {
            [_delegate didDeviceReceivedData:data status:XPGWIFISDKObjectStatusFailed];
            }
        }
    } else {
        [_delegate didDeviceReceivedData:data status:XPGWIFISDKObjectStatusFailed];
    }
}

- (void)XPGWifiDeviceDidDisconnected:(XPGWifiDevice *)device {
    
    NSLog(@"%s deviceProductName:%@", __func__, device.productName);
    
    [[[UIAlertView alloc] initWithTitle:@"" message:@"设备已端开连接，您可以解绑设备，但不能操控设备" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    
    if ([_delegate respondsToSelector:@selector(didDeviceDisconnected:)]) {
        [_delegate didDeviceDisconnected:device];
    }
}

- (XPGWIFISDKObjectStatus)getObjectStatusFromSdkCode:(XPGWifiErrorCode)code {
    XPGWIFISDKObjectStatus status;

    switch (code) {
        case XPGWifiError_NONE:
            status = XPGWIFISDKObjectStatusSuccessful;
            break;
        case XPGWifiError_GENERAL:
            status = XPGWIFISDKObjectStatusFailed;
            break;
        case XPGWifiError_NOT_IMPLEMENTED:
            status = XPGWIFISDKObjectStatusNotImplemented;
            break;
        case XPGWifiError_PACKET_DATALEN:
            status = XPGWIFISDKObjectStatusPacketDataLen;
            break;
        case XPGWifiError_CONNECTION_ID:
            status = XPGWIFISDKObjectStatusConnectionId;
            break;
        case XPGWifiError_CONNECTION_CLOSED:
            status = XPGWIFISDKObjectStatusConnectionClosed;
            break;
        case XPGWifiError_PACKET_CHECKSUM:
            status = XPGWIFISDKObjectStatusPacketChecksum;
            break;
        case XPGWifiError_LOGIN_VERIFY_FAILED:
            status = XPGWIFISDKObjectStatusLoginVerifyFailed;
            break;
        case XPGWifiError_NOT_LOGINED:
            status = XPGWIFISDKObjectStatusNotLogined;
            break;
        case XPGWifiError_NOT_CONNECTED:
            status = XPGWIFISDKObjectStatusNotConnected;
            break;
        case XPGWifiError_MQTT_FAIL:
            status = XPGWIFISDKObjectStatusMQTTFail;
            break;
        case XPGWifiError_DISCOVERY_MISMATCH:
            status = XPGWIFISDKObjectStatusDiscoveryMismatch;
            break;
        case XPGWifiError_SET_SOCK_OPT:
            status = XPGWIFISDKObjectStatusSetSocketOpt;
            break;
        case XPGWifiError_THREAD_CREATE:
            status = XPGWIFISDKObjectStatusThreadCreate;
            break;
        case XPGWifiError_CONNECTION_POOL_FULLED:
            status = XPGWIFISDKObjectStatusConnectionPoolFulled;
            break;
        case XPGWifiError_NULL_CLIENT_ID:
            status = XPGWIFISDKObjectStatusNullClientId;
            break;
        case XPGWifiError_CONNECTION_ERROR:
            status = XPGWIFISDKObjectStatusConnectionError;
            break;
        case XPGWifiError_INVALID_PARAM:
            status = XPGWIFISDKObjectStatusInvalidParam;
            break;
        case XPGWifiError_CONNECT_TIMEOUT:
            status = XPGWIFISDKObjectStatusConnectTimeout;
            break;
        case XPGWifiError_INVALID_VERSION:
            status = XPGWIFISDKObjectStatusInvalidVersion;
            break;
        case XPGWifiError_INSUFFIENT_MEM:
            status = XPGWIFISDKObjectStatusInsuffientMem;
            break;
        case XPGWifiError_THREAD_BUSY:
            status = XPGWIFISDKObjectStatusThreadBusy;
            break;
        case XPGWifiError_HTTP_FAIL:
            status = XPGWIFISDKObjectStatusHttpFail;
            break;
        case XPGWifiError_GET_PASSCODE_FAIL:
            status = XPGWIFISDKObjectStatusGetPasscodeFail;
            break;
        case XPGWifiError_DNS_FAILED:
            status = XPGWIFISDKObjectStatusDNSFailed;
            break;
        case XPGWifiError_CONFIGURE_SSID_NOT_MATCHED:
            status = XPGWIFISDKObjectStatusConfigureSSIDNotMatched;
            break;
        case XPGWifiError_CONFIGURE_TIMEOUT:
            status = XPGWIFISDKObjectStatusConfigureTimeout;
            break;
        case XPGWifiError_CONFIGURE_SENDFAILED:
            status = XPGWIFISDKObjectStatusConfigureSendFailed;
            break;
        case XPGWifiError_NOT_IN_SOFTAPMODE:
            status = XPGWIFISDKObjectStatusNotInSoftAPMode;
            break;
        case XPGWifiError_UNRECOGNIZED_DATA:
            status = XPGWIFISDKObjectStatusUnrecognizedData;
            break;
        case XPGWifiError_CONNECTION_NO_GATEWAY:
            status = XPGWIFISDKObjectStatusConnectionNoGateway;
            break;
        case XPGWifiError_CONNECTION_REFUSED:
            status = XPGWIFISDKObjectStatusConnectionRefused;
            break;
        case XPGWifiError_IS_RUNNING:
            status = XPGWIFISDKObjectStatusIsRunning;
            break;
        case XPGWifiError_UNSUPPORTED_API:
            status = XPGWIFISDKObjectStatusUnsupported;
            break;
        default:
            status = XPGWIFISDKObjectStatusFailed;
            break;
    }
    
    return status;
}

@end
