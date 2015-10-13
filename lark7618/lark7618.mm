//
//  lark7618.m
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "lark7618.h"
#import "FSKWav.h"
#import "AudioQueuePlayer.h"
#import <XPGWifiSDK/XPGWifiSDK.h>
#import <iToast.h>
#import "AFNetworkReachabilityManager.h"
#import "IoTWifiUtil.h"

static NSString * const IOT_APPKEY = @"7ac10dec7dba436785ac23949536a6eb";
static NSString * const IOT_PRODUCT = @"6f3074fe43894547a4f1314bd7e3ae0b";//@"be606a7b34d441b59d7eba2c080ff805";

typedef enum _IoTUserType
{
    IoTUserTypeAnonymous,       //匿名用户
    IoTUserTypeNormal,          //普通用户
    IoTUserTypeThird,           //第三方用户
}IoTUserType;

@interface lark7618 () <AudioQueuePlayerDelegate, XPGWifiSDKDelegate>

// 基本的用户数据
@property (strong, nonatomic) NSString *username;   //用户名
@property (strong, nonatomic) NSString *password;   //密码

// 用户 SESSION
@property (strong, nonatomic) NSString *uid;        //uid
@property (strong, nonatomic) NSString *token;      //token
@property (assign, nonatomic) IoTUserType userType; //用户类型，第三方用户 Demo App 不支持

@property (readonly, nonatomic) BOOL isRegisteredUser;  //匿名用户是否已注册

@property (nonatomic, retain) AudioQueuePlayer *player;

@end

@implementation lark7618

#pragma GoKit初始化，检测网络，登录

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (nil != self) {
        
        _delegate = delegate;
#if 0
        // 拷贝配置文件到 /Documents/XPGWifiSDK/Devices 目录
//        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"lark7618.framework/data.json" owner:nil options:nil];
//        NSLog(@"%s arr:%@", __func__, [arr componentsJoinedByString:@"."]);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lark7618" ofType:@"framework"];
        NSLog(@"%s filePath:%@", __func__, filePath);
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"Invalid json file, skip.");
 //           abort();
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
        // 网络状态跟踪
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        // 初始化 Wifi SDK
        [XPGWifiSDK startWithAppID:IOT_APPKEY];
        
        // 为 Soft AP 模式设置 SSID 名。如果没设置，默认值是 XPG-GAgent, XPG_GAgent
        [XPGWifiSDK registerSSIDs:@"XPG-GAgent", @"XPG_GAgent", nil];
        
        // 设置日志分级、日志输出文件、是否打印二进制数据
        [XPGWifiSDK setLogLevel:XPGWifiLogLevelAll logFile:@"logfile.txt" printDataLevel:YES];
        
        // 设置 SDK Delegate
        [XPGWifiSDK sharedInstance].delegate = self;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            [self networkIsReachable];
        }];
    }
    
    return self;
}

- (void)initAccount {
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
//        [self networkIsReachable];
//    }];
    
    // 检测Wifi/移动数据(WWAN)/关闭状态(Not Reachable)
    //    if (![self networkIsReachable]) {
    //#warning 网络不可用
    //        return;
    //    }
    
//    sleep(1);
    
//    if(![XPGWifiSDK sharedInstance]) {
//#warning SDK不可用
//        return;
//    }
    
//    if ([self isSoftAPMode]) {
//#warning softAP模式
//        return;
//    }
    
    if(!self.isRegisteredUser) {
        [[XPGWifiSDK sharedInstance] userLoginAnonymous]; // 如果未注册匿名用户，系统会自动注册一个匿名用户
    } else {
        [self userLogin]; // 用户已注册，直接登录
    }
}

- (BOOL)networkIsReachable {
    BOOL status = YES;
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (netStatus) {
        case AFNetworkReachabilityStatusNotReachable:
        {
            if(netStatus == AFNetworkReachabilityStatusNotReachable) {
                
                status = NO;
            }
            break;
        }
        default:
            break;
    }
    
    return status;
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

#pragma device control

- (void)loadDeviceList {
//    iToastSettings *theSettings = [iToastSettings getSharedSettings];
//    theSettings.duration = 3000;
    
    //    if(nil != selectedDevices)
    //        [selectedDevices disconnect];
    
    [[AFNetworkReachabilityManager sharedManager] addObserver:self forKeyPath:@"networkReachabilityStatus" options:NSKeyValueObservingOptionNew context:nil];
    //    [self checkNetwokStatus];
    
    //    [XPGWifiSDK sharedInstance].delegate = self;
    
    /*
     进入列表的时候下载一次
     */
    //    [self downloadBindListFormCloud];
    
    NSLog(@"%s uid:%@, token:%@", __func__, self.uid, self.token);
    
    [[XPGWifiSDK sharedInstance] getBoundDevicesWithUid:self.uid token:self.token specialProductKeys:IOT_PRODUCT, nil];
}


#pragma mark - Properties
#define DefaultSetValue(key, value) \
[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];

#define DefaultGetValue(key) \
[[NSUserDefaults standardUserDefaults] valueForKey:key];

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

- (void)setUserType:(IoTUserType)userType {
    
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

- (IoTUserType)userType {
    NSNumber *nAnymous = DefaultGetValue(@"userType")
    
    if(nil != nAnymous) {
        return (IoTUserType)[nAnymous intValue];
    }
    
    return IoTUserTypeAnonymous;
}

- (BOOL)isRegisteredUser {
    
    return (self.uid.length > 0 && self.token.length > 0);
}

#pragma mark - Other Common Functions

- (void)userLogin {
    
    switch (self.userType) {
        case IoTUserTypeAnonymous:
            [[XPGWifiSDK sharedInstance] userLoginAnonymous];
            break;
        case IoTUserTypeNormal:
            [[XPGWifiSDK sharedInstance] userLoginWithUserName:self.username password:self.password];
            break;
        case IoTUserTypeThird:
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
    
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid key:password mode:XPGWifiSDKSoftAPMode timeout:60];
}

#pragma AirLink模式下配置SSID和密码

- (void)configureAirLinkModeSSID:(NSString *)ssid andPassword:(NSString *)password {
    
    [[XPGWifiSDK sharedInstance] setDeviceWifi:ssid key:password mode:XPGWifiSDKAirLinkMode timeout:60];
}

#pragma mark - XPGWifiSDK delegate 回调

/* 用户登录回调 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUserLogin:(NSNumber *)error errorMessage:(NSString *)errorMessage uid:(NSString *)uid token:(NSString *)token {
    
    // 登录成功，自动设置相关信息
    NSLog(@"-----------------------> UserLogin result:%d", [error intValue]);
    
    if ([error intValue] || uid.length == 0 || token.length == 0) {
        
        NSLog(@"-----------------------> UserLogin errorMassage:%@", errorMessage);
        
        if ([_delegate respondsToSelector:@selector(didUserLogin:)]) {
            [_delegate didUserLogin:YYTXLark7618LoginFailed];
        }
    } else {
        
        NSLog(@"-----------------------> UserLogin uid:%@ token:%@", uid, token);
        
        self.uid = uid;
        self.token = token;
        
#pragma 登录成功，转到设备列表界面，获取设备列表
        if ([_delegate respondsToSelector:@selector(didUserLogin:)]) {
            [_delegate didUserLogin:YYTXLark7618LoginSuccessful];
        }
    }
}

/* 返回获取到的SSID列表，result为0时有效 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didGetSSIDList:(NSArray *)ssidList result:(int)result {
    
    if(0 == result) {
        
    }
}

/* 配置SSID和Password的回调，result为0时表示配置成功 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result {
    if (!result) {
        
    } else {
        
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
    
    NSLog(@"%s count1:%d count2:%d count3:%d", __func__, arr1.count, arr2.count, arr3.count);
    
    if ([_delegate respondsToSelector:@selector(didLoadDeviceList:newDevices:offLineDevices:)]) {
        [_delegate didLoadDeviceList:arr1 newDevices:arr2 offLineDevices:arr3];
    }
}

- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUpdateProduct:(NSString *)product result:(int)result {
    
    NSLog(@"%s product:%@ result:%d", __func__, product, result);
    
    if(result == -25) {

    }
}

/* 设备登录回调，result为0表示成功 */
- (void)XPGWifiDevice:(XPGWifiDevice *)device didLogin:(int)result {
    
    NSLog(@"%s device:%@ result:%d", __func__, device, result);
    
#warning 设备登录回调，登录成功后即可对设备进行操作
}

- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didBindDevice:(NSString *)did error:(NSNumber *)error errorMessage:(NSString *)errorMessage {
    
    NSLog(@"%s did:%@ error:%@ errorMessage:%@", __func__, did, error, errorMessage);
    
#warning 绑定设备回调，然后重新从云端获取设备列表
}

- (void)XPGWifiDeviceDidDisconnected:(XPGWifiDevice *)device {
#if 0
    if([selectedDevices.macAddress isEqualToString:device.macAddress] &&
       [selectedDevices.did isEqualToString:device.did])
    {
        if(_goKit.hud.alpha == 1 && [_goKit.hud.labelText isEqualToString:@"登录中..."])
        {
            [_alertView dismissWithClickedButtonIndex:0 animated:NO];
            _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [_alertView show];
        }
        else if (_goKit.hud.alpha == 1 && [_goKit.hud.labelText isEqualToString:@"连接中..."])
        {
            [_alertView dismissWithClickedButtonIndex:0 animated:NO];
            _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [_alertView show];
        }
        
        [_goKit.hud hide:YES];
        //       NSLog(@"Disconnected device:%@, %@, %@, %@", device.macAddress, device.did, device.passcode, device.productKey);
        selectedDevices.delegate = nil;
        selectedDevices = nil;
    }
#endif
}
#if 0
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didUpdateProduct:(NSString *)product result:(int)result {
    
    if(result == -25) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if(self.isToasted == YES)
                return;
            self.isToasted = YES;
            iToast *toast = [iToast makeText:@"下载配置出错，请检查网络后再试。"];
            [toast performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            sleep(3);
            self.isToasted = NO;
        });
    }
}
#endif

#pragma FSK



- (void)sendSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password {
    NSData *fskData = [FSKWav generateWithSSID:ssid password:password];
    if (nil == fskData) {
        return;
    }
    
    if (nil == _player) {
        _player = [[AudioQueuePlayer alloc] init];
    }
    
    [_player setStream:fskData];
    [_player setDelegate:self];
    [_player play];
}

- (void)stopSending {
    
    [_player stop];
}

- (void)audioQueuePlayFinished {
    
    if ([_delegate respondsToSelector:@selector(didFSKSendingComplete)]) {
        [_delegate didFSKSendingComplete];
    }
}

#pragma

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%s keyPath:%@", __func__, keyPath);
    
    if([keyPath isEqualToString:@"networkReachabilityStatus"]) {
        [self networkIsReachable];
    }
}

@end
