//
//  SpeechDemosViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/24.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "SpeechDemonsViewController.h"
#import "IQTextView.h"

@interface SpeechDemonsViewController ()
@property (nonatomic, retain) IBOutlet IQTextView *textViewContent;
@property (nonatomic, retain) IBOutlet UIButton *buttonSynthesis;
@property (nonatomic, retain) IBOutlet UIButton *buttonStopSynth;
@property (nonatomic, retain) IBOutlet UIButton *buttonImportText;

@end

@implementation SpeechDemonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"语音系统演示"];
    
    [_textViewContent setPlaceholder:@"请在此文本框中输入您要合成的文字"];
    
    _textViewContent.layer.borderWidth = 0.5;
    _textViewContent.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1.0].CGColor;
    _textViewContent.layer.cornerRadius = 5;
    
    _buttonSynthesis.layer.cornerRadius = 5;
    _buttonStopSynth.layer.cornerRadius = 5;
    _buttonImportText.layer.cornerRadius = 5;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
