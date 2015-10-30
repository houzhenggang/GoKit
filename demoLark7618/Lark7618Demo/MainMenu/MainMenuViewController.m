//
//  MainMenuViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/21.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SituationDemoViewController.h"
#import "DeviceListViewController.h"
#import "DeviceManagerViewController.h"
#import "SpeechDemonsViewController.h"

@interface MainMenuViewController ()
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"主菜单"];
    [self.navigationItem setHidesBackButton:YES];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
    
    CGFloat borderWidth = 1/[[UIScreen mainScreen] scale];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame)/2;
    CGFloat viewHeight = 137.5;
    CGRect buttonRect = (CGRect){0, 0, 90, 90};
    
    UIView *view00 = [[UIView alloc] initWithFrame:(CGRect){0, 0, viewWidth, viewHeight}];
    view00.layer.borderWidth = borderWidth;
    view00.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    UIView *view01 = [[UIView alloc] initWithFrame:(CGRect){CGRectGetMaxX(view00.frame)-borderWidth, 0, viewWidth+borderWidth, viewHeight}];
    view01.layer.borderWidth = borderWidth;
    view01.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    UIView *view10 = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(view00.frame)-borderWidth, viewWidth, viewHeight+borderWidth}];
    view10.layer.borderWidth = borderWidth;
    view10.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    UIView *view11 = [[UIView alloc] initWithFrame:(CGRect){CGRectGetMaxX(view10.frame)-borderWidth, CGRectGetMaxY(view01.frame)-borderWidth, viewWidth+borderWidth, viewHeight+borderWidth}];
    view11.layer.borderWidth = borderWidth;
    view11.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    UIView *view20 = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(view10.frame)-borderWidth, viewWidth, viewHeight+borderWidth}];
    view20.layer.borderWidth = borderWidth;
    view20.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    UIView *view21 = [[UIView alloc] initWithFrame:(CGRect){CGRectGetMaxX(view20.frame)-borderWidth, CGRectGetMaxY(view11.frame)-borderWidth, viewWidth+borderWidth, viewHeight+borderWidth}];
    view21.layer.borderWidth = borderWidth;
    view21.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;
    
    [_scrollView addSubview:view00];
    [_scrollView addSubview:view01];
    [_scrollView addSubview:view10];
    [_scrollView addSubview:view11];
    [_scrollView addSubview:view20];
    [_scrollView addSubview:view21];
    
    UIButton *buttonSituationalDemonstration = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonSituationalDemonstration setImage:[UIImage imageNamed:@"SituationDemons.png"] forState:UIControlStateNormal];
    [buttonSituationalDemonstration addTarget:self action:@selector(gotoSituationalDemonstration) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSpeechDemonstration = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonSpeechDemonstration setImage:[UIImage imageNamed:@"SpeechDemons.png"] forState:UIControlStateNormal];
    [buttonSpeechDemonstration addTarget:self action:@selector(gotoSpeechDemonstration) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonLocalMusic = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonLocalMusic setImage:[UIImage imageNamed:@"LocalMusic.png"] forState:UIControlStateNormal];
    [buttonLocalMusic addTarget:self action:@selector(gotoLocalMusic) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMyAlarms = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonMyAlarms setImage:[UIImage imageNamed:@"MyAlarms.png"] forState:UIControlStateNormal];
    [buttonMyAlarms addTarget:self action:@selector(gotoMyAlarms) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonDeviceManager = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonDeviceManager setImage:[UIImage imageNamed:@"DeviceManager.png"] forState:UIControlStateNormal];
    [buttonDeviceManager addTarget:self action:@selector(gotoDeviceManager) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonDeviceList = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonDeviceList setImage:[UIImage imageNamed:@"DeviceList.png"] forState:UIControlStateNormal];
    [buttonDeviceList addTarget:self action:@selector(gotoDeviceList) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:buttonSituationalDemonstration];
    [_scrollView addSubview:buttonSpeechDemonstration];
    [_scrollView addSubview:buttonLocalMusic];
    [_scrollView addSubview:buttonMyAlarms];
    [_scrollView addSubview:buttonDeviceManager];
    [_scrollView addSubview:buttonDeviceList];
    
    buttonSituationalDemonstration.center = view00.center;
    buttonSpeechDemonstration.center = view01.center;
    buttonLocalMusic.center = view10.center;
    buttonMyAlarms.center = view11.center;
    buttonDeviceManager.center = view20.center;
    buttonDeviceList.center = view21.center;
    
    [_scrollView setContentSize:(CGSize){CGRectGetMaxX(view21.frame), CGRectGetMaxY(view21.frame)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect frame = self.view.frame;
    frame.origin = (CGPoint){0, 0};
    [_scrollView setFrame:frame];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gotoSituationalDemonstration {
    SituationDemoViewController *situationDemoVC = [[SituationDemoViewController alloc] init];
    if (nil != situationDemoVC) {
        [self.navigationController pushViewController:situationDemoVC animated:YES];
    }
}

- (void)gotoSpeechDemonstration {
    SpeechDemonsViewController *speechDemonsVC = [[UIStoryboard storyboardWithName:@"SpeechDemons" bundle:nil] instantiateViewControllerWithIdentifier:@"SpeechDemonsViewController"];
    if (nil != speechDemonsVC) {
        [self.navigationController pushViewController:speechDemonsVC animated:YES];
    }
}

- (void)gotoLocalMusic {

}

- (void)gotoMyAlarms {

}

- (void)gotoDeviceManager {
    DeviceManagerViewController *deviceManagerVC = [[UIStoryboard storyboardWithName:@"DeviceManager" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceManagerViewController"];
    if (nil != deviceManagerVC) {
        [self.navigationController pushViewController:deviceManagerVC animated:YES];
    }
}

- (void)gotoDeviceList {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
