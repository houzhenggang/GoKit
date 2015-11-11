//
//  QXToast.h
//  QXToastDemo
//
//  Created by TTS on 15/10/19.
//  Copyright © 2015年 yytx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXToast : NSObject

/** 
 在屏幕上方以黑地白字的方式显示一些小贴示给用户
 @param message 需要显示的内容
 */
+ (void)showMessage:(NSString *)message;

@end
