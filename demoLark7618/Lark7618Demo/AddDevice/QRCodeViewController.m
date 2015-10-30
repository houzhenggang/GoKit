//
//  QRCodeViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/27.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XPGWIFISDKObject.h"
#import "DeviceListViewController.h"
#import "QXToast.h"

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, XPGWIFISDKObjectDelegate>
{
    int num;
    BOOL upOrDown;
    NSTimer *timer;
}
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) UIImageView *line;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.title = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-240)/2, 256, 240, 40)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.font = [UIFont systemFontOfSize:15];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.numberOfLines=1;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码放到框内即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-180)/2, 43, 180, 183)];
    imageView.image = [UIImage imageNamed:@"Pick_bg.png"];
    [self.view addSubview:imageView];
    
    upOrDown = NO;
    num =0;
    
    /**
     此块代码为扫描先上下滑动的效果，此处需求不要
     :returns: return value description
     */
    self.line = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-180)/2, 43, 180, 4)];
    self.line.image = [UIImage imageNamed:@"Line.png"];
    [self.view addSubview:self.line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法访问通讯录" message:@"请到“设置->隐私->相机”中将toon设置为允许访问相机！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        [self setupCamera];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)animation1 {
    if (upOrDown == NO) {
        num ++;
        self.line.frame = CGRectMake((SCREENWIDTH-180)/2, 43+2*num, 180, 2);
        if (2*num >= 180) {
            upOrDown = YES;
        }
    } else {
        num --;
        self.line.frame = CGRectMake((SCREENWIDTH-180)/2, 43+2*num, 180, 2);
        if (num == 0) {
            upOrDown = NO;
        }
    }
}

- (void)setupCamera {
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(_device == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未检测到相机" message:@"请检查相机设备是否正常" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //限制扫描区域（上左下右）
    [ _output setRectOfInterest : CGRectMake ( 43 / SCREENHEIGHT ,(( SCREENWIDTH - 150 )/ 2 )/ SCREENWIDTH , 213 /SCREENHEIGHT , 210 / SCREENWIDTH)];

    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT-44);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        //输出扫描字符串
        NSLog(@"%s %@", __func__, metadataObject.stringValue);
        
        [_session stopRunning];
        
//        NSString *productKey = [self parseWebAddress:metadataObject.stringValue getValue:@"product_key"];
        NSString *did = [self parseWebAddress:metadataObject.stringValue getValue:@"did"];
        NSString *passcode = [self parseWebAddress:metadataObject.stringValue getValue:@"passcode"];
        
        [[XPGWIFISDKObject shareInstance] bindDeviceId:did passcode:passcode remark:@"虚拟设备"];
    }
}

- (NSString *)parseWebAddress:(NSString *)address getValue:(NSString *)title {
    NSError *error;
    NSString *regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", title];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];

    NSArray *matches = [regex matchesInString:address options:0 range:NSMakeRange(0, [address length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [address substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串

        return tagValue;
    }
    
    return @"";
}

- (void)didDeviceBindStatus:(XPGWIFISDKObjectStatus)status {
    
    NSLog(@"%s status:%@", __func__, @(status));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [_hud hide:YES];
        
        if (XPGWIFISDKObjectStatusSuccessful == status) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[DeviceListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [QXToast showMessage:@"绑定失败"];
        }
    });
}

@end
