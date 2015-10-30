//
//  ChangeDeviceDateViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/23.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "ChangeDeviceTimeViewController.h"

@interface ChangeDeviceTimeViewController ()
@property (nonatomic, retain) IBOutlet UILabel *labelServerTimeTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelServerTime;
@property (nonatomic, retain) IBOutlet UISwitch *switchCustomTime;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@end

@implementation ChangeDeviceTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.tableView.frame), 0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        if ([_switchCustomTime isOn]) {
            return 3;
        } else {
            return 2;
        }
    } else if (1 == section) {
        return 1;
    }
    
    return 0;
}

- (IBAction)switchCustomTimeValueChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
        [_labelServerTimeTitle setTextColor:[UIColor grayColor]];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView setBackgroundColor:[UIColor whiteColor]];
        [_labelServerTimeTitle setTextColor:[UIColor blackColor]];
    }
    
}

- (IBAction)buttonOkClicked:(id)sender {
    
}

- (IBAction)buttonCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
