//
//  AccountEmailViewController.h
//  Lark7618Demo
//
//  Created by TTS on 15/11/3.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountEmailViewController : UIViewController
//忘记密码模式，默认是注册模式
@property (nonatomic, assign) BOOL isForget;
@property (nonatomic, retain) NSString *email;

@end
