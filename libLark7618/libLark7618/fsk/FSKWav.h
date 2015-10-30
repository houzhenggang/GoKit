//
//  FSKWav.h
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSKWav : NSObject

+ (nullable NSData *)generateWithSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password;

@end
