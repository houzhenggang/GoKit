//
//  ChangeDeviceVolumeViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/23.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "ChangeDeviceVolumeViewController.h"

@interface ChangeDeviceVolumeViewController ()
@property (nonatomic, retain) IBOutlet UILabel *labelVolume;
@property (nonatomic, retain) IBOutlet UISlider *sliderVolume;

@end

@implementation ChangeDeviceVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonVolumeDecClicked:(id)sender {

}

- (IBAction)buttonVolumeIncClicked:(id)sender {

}

- (IBAction)sliderVolumeChanged:(id)sender {

}

- (IBAction)buttonOkClicked:(id)sender {
    
}

- (IBAction)buttonCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
