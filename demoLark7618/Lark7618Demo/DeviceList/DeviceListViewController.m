//
//  DeviceListViewController.m
//  lark7618
//
//  Created by TTS on 15/10/13.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "DeviceListViewController.h"
#import "XPGWIFISDKObject.h"
#import "MBProgressHud.h"
#import "AddDeviceViewController.h"
#import "MainMenuViewController.h"
#import "UserAccountViewController.h"
#import "QXToast.h"

@interface DeviceListViewController () <XPGWIFISDKObjectDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) NSMutableArray *arrayOnLineDevices;
@property (nonatomic, retain) NSMutableArray *arrayNewDevices;
@property (nonatomic, retain) NSMutableArray *arrayOffLineDevices;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) XPGWIFISDKObject *XpgObject;
//@property (nonatomic, retain) NSMutableArray *arrayBoundProKeys;
@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:NSLocalizedStringFromTable(@"DevicesList", @"LocalizedSimpleChinese", nil)];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getDevicesList)]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"我的账户" style:UIBarButtonItemStylePlain target:self action:@selector(gotoUserAccountVC)]];
    
    UIBarButtonItem *addDevice = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"AddDevice", @"LocalizedSimpleChinese", nil) style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAddDeviceClicked)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[flexibleSpace, addDevice, flexibleSpace];
    
    _XpgObject = [XPGWIFISDKObject shareInstance];
//    _arrayBoundProKeys = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_XpgObject setDelegate:self];
    
    if (nil != _XpgObject.selectedDevice) {
        [_XpgObject.selectedDevice disconnect];
    }
    
    [self getDevicesList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _XpgObject.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoUserAccountVC {
    UserAccountViewController *userAccountVC = [[UIStoryboard storyboardWithName:@"UserAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
    if (nil != userAccountVC) {
        [self.navigationController pushViewController:userAccountVC animated:YES];
    }
}

- (void)getDevicesList {

    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.labelText = NSLocalizedStringFromTable(@"gettingDeviceList", @"LocalizedSimpleChinese", nil);
    [_hud show:YES];
    
    [_XpgObject loadBoundDevices];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if (0 == section) {
        count = _arrayOnLineDevices.count;
    } else if (1 == section) {
        count = _arrayOffLineDevices.count;
    } else if (2 == section) {
        count = _arrayNewDevices.count;
    }
    
    NSLog(@"%s section:%d count:%d", __func__, section, count);
    
    if (count <= 0) {
        count = 1;
    }
    
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (0 == section) {
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"BondedDevices(%@)", @"LocalizedSimpleChinese", nil), @(_arrayOnLineDevices.count)];
    } else if (1 == section) {
        return [NSString stringWithFormat: NSLocalizedStringFromTable(@"OfflineDevices(%@)", @"LocalizedSimpleChinese", nil), @(_arrayOffLineDevices.count)];
    } else if (2 == section) {
        return [NSString stringWithFormat: NSLocalizedStringFromTable(@"UnboundDevices(%@)", @"LocalizedSimpleChinese", nil), @(_arrayNewDevices.count)];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        if (_arrayOnLineDevices.count <= 0) {
            return 44;
        } else {
            return 80;
        }
    } else if (1 == indexPath.section) {
        if (_arrayOffLineDevices.count <= 0) {
            return 44;
        } else {
            return 80;
        }
    } else if (2 == indexPath.section) {
        if (_arrayNewDevices.count <= 0) {
            return 44;
        } else {
            return 80;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    XPGWifiDevice *device = nil;
    NSString *noDevice = NSLocalizedStringFromTable(@"UnfoundDevice", @"LocalizedSimpleChinese", nil);
    
    if (0 == indexPath.section) {
        if (_arrayOnLineDevices.count > 0) {
            device = _arrayOnLineDevices[indexPath.row];
        }
    } else if (1 == indexPath.section) {
        if (_arrayOffLineDevices.count > 0) {
            device = _arrayOffLineDevices[indexPath.row];
        }
    } else if (2 == indexPath.section) {
        if (_arrayNewDevices.count > 0) {
            device = _arrayNewDevices[indexPath.row];
        }
    }
    
    if (nil == device) {
        UILabel *label = [[UILabel alloc] init];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setText:noDevice];
        [label setTextColor:[UIColor lightGrayColor]];
        [cell setUserInteractionEnabled:NO];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [cell.contentView addSubview:label];

        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[label]-(>=15)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [cell setUserInteractionEnabled:NO];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"MonitorHumidity.png"]];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UILabel *labelName = [[UILabel alloc] init];
        [labelName setFont:[UIFont systemFontOfSize:18]];
        [labelName setText:device.productName];
        [labelName setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UILabel *labelStatus = [[UILabel alloc] init];
        if(device.isLAN) {
            if(![device isBind:_XpgObject.uid]) {
                labelStatus.text = @"未绑定";
            } else {
                labelStatus.text = @"局域网已连接";
//                [_arrayBoundProKeys addObject:device.productKey];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            if(!device.isOnline) {
                labelStatus.textColor = [UIColor grayColor];
                labelStatus.text = @"离线";
            } else {
                labelStatus.text = @"远程已连接";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
//            [_arrayBoundProKeys addObject:device.productKey];
        }
        [labelStatus setFont:[UIFont systemFontOfSize:14]];
        [labelStatus setTextColor:[UIColor lightGrayColor]];
        [labelStatus setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:labelName];
        [cell.contentView addSubview:labelStatus];
        
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imageView(==60)]-10-[labelName]-(>=15)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, labelName)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[imageView(==60)]-10-[labelStatus]-(>=15)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, labelStatus)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[labelName]-10-[labelStatus]-(>=10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(labelName, labelStatus)]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        if (_arrayOnLineDevices.count > 0) {
            _XpgObject.selectedDevice = _arrayOnLineDevices[indexPath.row];
        }
    } else if (1 == indexPath.section) {
        if (_arrayOffLineDevices.count > 0) {
            _XpgObject.selectedDevice = _arrayOffLineDevices[indexPath.row];
        }
    } else if (2 == indexPath.section) {
        if (_arrayNewDevices.count > 0) {
            _XpgObject.selectedDevice = _arrayNewDevices[indexPath.row];
        }
    }
    
    if (nil == _XpgObject.selectedDevice) {
        return;
    }
    
    if ([_XpgObject.selectedDevice.passcode length]) {
        _hud.labelText = [NSString stringWithFormat:@"正在登录%@...", _XpgObject.selectedDevice.macAddress];
        [_hud show:YES];
        [_XpgObject deviceLogin];
    } else {
        if(_XpgObject.selectedDevice.did.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备尚未与云端注册，无法绑定。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        } else {
            _hud.labelText = [NSString stringWithFormat:@"正在绑定%@...", _XpgObject.selectedDevice.macAddress];
            [_hud show:YES];
            [_XpgObject deviceBind];
        }
    }
}

- (void)barButtonAddDeviceClicked {
    AddDeviceViewController *addDeviceVC = [[UIStoryboard storyboardWithName:@"AddDevice" bundle:nil] instantiateViewControllerWithIdentifier:@"AddDeviceViewController"];
    if (nil != addDeviceVC) {
        [self.navigationController pushViewController:addDeviceVC animated:YES];
    }
}

#pragma YYTXLark7618Delegate

- (void)didLoadDeviceList:(NSMutableArray *)onLineDevices newDevices:(NSMutableArray *)newDevices offLineDevices:(NSMutableArray *)offLineDevices {

    NSLog(@"%s", __func__);
    
    _arrayOnLineDevices = onLineDevices;
    _arrayNewDevices = newDevices;
    _arrayOffLineDevices = offLineDevices;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
        [_hud hide:YES];
    });
}

- (void)didDeviceLoginStatus:(XPGWIFISDKObjectStatus)status {

    NSLog(@"%s status:%@", __func__, @(status));
    
    [_hud hide:YES];

    if (XPGWIFISDKObjectStatusSuccessful == status) {
        MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc] init];
        if (nil != mainMenuVC) {
            [self.navigationController pushViewController:mainMenuVC animated:YES];
        }
    } else {
        [QXToast showMessage:@"设备登录失败"];
    }
}

- (void)didDeviceBindStatus:(XPGWIFISDKObjectStatus)status {

    NSLog(@"%s status:%@", __func__, @(status));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_hud hide:YES];
    
        if (XPGWIFISDKObjectStatusSuccessful == status) {
            NSMutableArray *arr = [NSMutableArray array];
            for (XPGWifiDevice *device in _arrayOnLineDevices) {
                [arr addObject:device.productKey];
            }
            for (XPGWifiDevice *device in _arrayOffLineDevices) {
                [arr addObject:device.productKey];
            }
            [self getDevicesList];
        } else {
            [QXToast showMessage:@"绑定失败"];
        }
    });
}

@end
