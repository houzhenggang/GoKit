//
//  SpeechSynthParamsSetViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/24.
//  Copyright © 2015年 ;. All rights reserved.
//

#import "SpeechSynthParamsSetViewController.h"

@interface SpeechSynthParamsSetViewController ()
@property (nonatomic, retain) IBOutlet UISlider *sliderVolume;
@property (nonatomic, retain) IBOutlet UISlider *sliderSpeed;
@property (nonatomic, retain) IBOutlet UISlider *sliderIntonation;

@end

@implementation SpeechSynthParamsSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"语音合成参数设置"];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
    
//    [_sliderVolume setThumbImage:[UIImage imageNamed:@"Background.png"] forState:UIControlStateNormal];
//    [_sliderSpeed setThumbImage:[UIImage imageNamed:@"Background.png"] forState:UIControlStateNormal];
//    [_sliderIntonation setThumbImage:[UIImage imageNamed:@"Background.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
