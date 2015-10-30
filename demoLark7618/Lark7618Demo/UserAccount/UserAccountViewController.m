//
//  UserAccountViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/23.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "UserAccountViewController.h"
#import "UIAlertView+YYTXCustom.h"
#import "MBProgressHUD.h"
#import "XPGWIFISDKObject.h"
#import "UserLoginViewController.h"
#import "QXToast.h"

@interface UserAccountViewController () <XPGWIFISDKObjectDelegate>
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"我的账户"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[XPGWIFISDKObject shareInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要注销当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView showAlertViewWithCompleteBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (1 == buttonIndex) {
                    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:_hud];
                    _hud.labelText = @"注销中...";
                    [_hud show:YES];
                    
                    [[XPGWIFISDKObject shareInstance] userLogout];
                }
            }];
        }
    }
}

#pragma XPGWIFISDKObjectDelegate

- (void)didUserLogoutStatus:(XPGWIFISDKObjectStatus)status {
    
    [_hud setHidden:YES];
    
    if (XPGWIFISDKObjectStatusSuccessful == status) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[UserLoginViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    } else {
        [QXToast showMessage:@"注销失败"];
    }
}

@end
