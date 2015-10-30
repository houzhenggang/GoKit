//
//  FSKWav.m
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "FSKWav.h"
#import "FSKWavGenAPI.h"

@implementation FSKWav

+ (NSData *)generateWithSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password {
    
    if (ssid.length <= 0 || nil == password) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@%@", ssid, password];
    NSData *gbkData = [content dataUsingEncoding:NSUTF8StringEncoding];
    char *wavBytes;
    int wavBytesLength;
    
    wavBytes = WavGen((char *)gbkData.bytes, gbkData.length, ssid.length, FSK_ASR, &wavBytesLength);
    
    NSData *fsk = [NSData dataWithBytes:wavBytes length:wavBytesLength];
    
    return fsk;
}

@end
