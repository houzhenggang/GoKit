//
//  SituationDemoViewController.m
//  Lark7618Demo
//
//  Created by TTS on 15/10/21.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import "SituationDemoViewController.h"
#import "LightingControlViewController.h"
#import "MotolControlViewController.h"
#import "EnvironmentMonitorViewController.h"

@interface SituationDemoViewController ()
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation SituationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"情景演示"];
    
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
    
    [_scrollView addSubview:view00];
    [_scrollView addSubview:view01];
    [_scrollView addSubview:view10];
    
    UIButton *buttonLightingControl = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonLightingControl setImage:[UIImage imageNamed:@"LightingControl.png"] forState:UIControlStateNormal];
    [buttonLightingControl addTarget:self action:@selector(gotoLightingControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMotolControl = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonMotolControl setImage:[UIImage imageNamed:@"MotolControl.png"] forState:UIControlStateNormal];
    [buttonMotolControl addTarget:self action:@selector(gotoMotolControl) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonEnvironmentMonitor = [[UIButton alloc] initWithFrame:buttonRect];
    [buttonEnvironmentMonitor setImage:[UIImage imageNamed:@"EnvironmentMonitor.png"] forState:UIControlStateNormal];
    [buttonEnvironmentMonitor addTarget:self action:@selector(gotoEnvironmentControl) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:buttonLightingControl];
    [_scrollView addSubview:buttonMotolControl];
    [_scrollView addSubview:buttonEnvironmentMonitor];
    
    buttonLightingControl.center = view00.center;
    buttonMotolControl.center = view01.center;
    buttonEnvironmentMonitor.center = view10.center;
    
    [_scrollView setContentSize:(CGSize){CGRectGetMaxX(view10.frame), CGRectGetMaxY(view10.frame)}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect frame = self.view.frame;
    frame.origin = (CGPoint){0, 0};
    [_scrollView setFrame:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)gotoLightingControl {
    LightingControlViewController *lightingControlVC = [[UIStoryboard storyboardWithName:@"LightingControl" bundle:nil] instantiateViewControllerWithIdentifier:@"LightingControlViewController"];
    if (nil != lightingControlVC) {
        [self.navigationController pushViewController:lightingControlVC animated:YES];
    }
}

- (void)gotoMotolControl {
    MotolControlViewController *motolControlVC = [[UIStoryboard storyboardWithName:@"MotolControl" bundle:nil] instantiateViewControllerWithIdentifier:@"MotolControlViewController"];
    if (nil != motolControlVC) {
        [self.navigationController pushViewController:motolControlVC animated:YES];
    }
}

- (void)gotoEnvironmentControl {
    EnvironmentMonitorViewController *environmentMonitorVC = [[UIStoryboard storyboardWithName:@"EnvironmentMonitor" bundle:nil] instantiateViewControllerWithIdentifier:@"EnvironmentMonitorViewController"];
    if (nil != environmentMonitorVC) {
        [self.navigationController pushViewController:environmentMonitorVC animated:YES];
    }
}

@end
