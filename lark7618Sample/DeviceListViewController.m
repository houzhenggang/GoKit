//
//  DeviceListViewController.m
//  lark7618
//
//  Created by TTS on 15/10/13.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "DeviceListViewController.h"

@interface DeviceListViewController () <lark7618Delegate>
@property (nonatomic, retain) NSMutableArray *arrayOnLineDevices;
@property (nonatomic, retain) NSMutableArray *arrayNewDevices;
@property (nonatomic, retain) NSMutableArray *arrayOffLineDevices;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _lark7618.delegate = self;
    
    [_lark7618 loadDeviceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        count = _arrayNewDevices.count;
    } else if (2 == section) {
        count = _arrayOffLineDevices.count;
    }
    
    NSLog(@"%s section:%d count:%d", __func__, section, count);
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *label = [[UILabel alloc] init];
//    XPGWifiDevice *device;
    
    if (0 == indexPath.section) {
        
    } else if (1 == indexPath.section) {
    
    } else if (2 == indexPath.section) {
    
    }
    
    return cell;
}

#pragma YYTXLark7618Delegate

- (void)didLoadDeviceList:(NSMutableArray *)onLineDevices newDevices:(NSMutableArray *)newDevices offLineDevices:(NSMutableArray *)offLineDevices {

    NSLog(@"%s", __func__);
    
    _arrayOnLineDevices = onLineDevices;
    _arrayNewDevices = newDevices;
    _arrayOffLineDevices = offLineDevices;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

@end
