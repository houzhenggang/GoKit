//
//  ConfigWIFIViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/14.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "ConfigViaFSKViewController.h"
#import "CheckingViewController.h"
#import "NetworkMonitor.h"

@interface ConfigViaFSKViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textfieldSSID;
@property (nonatomic, retain) IBOutlet UITextField *textfieldPassword;

@end

@implementation ConfigViaFSKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationItem setTitle:NSLocalizedStringFromTable(@"ModeFSK", @"LocalizedSimpleChinese", nil)];
    
    NSString *ssid = [NetworkMonitor currentWifiSSID];
    if (nil != ssid) {
        [_textfieldSSID setText:ssid];
        [_textfieldSSID setEnabled:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)barbuttonItemNextStepClicked:(id)sender {
    
    if (_textfieldSSID.text.length <= 0) {
        return;
    }
    
    CheckingViewController *checkingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckingViewController"];
    checkingVC.ssid = _textfieldSSID.text;
    checkingVC.password = _textfieldPassword.text;
    if (nil != checkingVC) {
        [self.navigationController pushViewController:checkingVC animated:YES];
    }
}

@end
