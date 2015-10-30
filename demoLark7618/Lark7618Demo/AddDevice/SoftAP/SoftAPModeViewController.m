//
//  SoftAPModeViewController.m
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "SoftAPModeViewController.h"
#import "SoftApMethodViewController.h"

@interface SoftAPModeViewController ()

@end

@implementation SoftAPModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonConfigWIFIClicked:(id)sender {
    SoftApMethodViewController *softAPMethodVC = [[UIStoryboard storyboardWithName:@"SoftAP" bundle:nil] instantiateViewControllerWithIdentifier:@"SoftApMethodViewController"];
    if (nil != softAPMethodVC) {
        [self.navigationController pushViewController:softAPMethodVC animated:YES];
    }
}

- (IBAction)buttonBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
