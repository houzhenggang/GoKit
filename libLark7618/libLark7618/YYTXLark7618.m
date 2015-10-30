//
//  lark7618.m
//  lark7618
//
//  Created by TTS on 15/10/12.
//  Copyright © 2015年 TTS. All rights reserved.
//

#import "YYTXLark7618.h"
#import "FSKWav.h"
#import "AudioQueuePlayer.h"


static YYTXLark7618 *lark7618instance = nil;

@interface YYTXLark7618 () <AudioQueuePlayerDelegate>
@property (nonatomic, retain) AudioQueuePlayer *player;

@end

@implementation YYTXLark7618

+ (instancetype)shareInstance {
    
    if(lark7618instance == nil) {
        
        lark7618instance = [[super allocWithZone:nil] init];  //super 调用allocWithZone
    }
    
    return lark7618instance;
}


+ (id)allocWithZone:(NSZone *)zone {
    
    return [YYTXLark7618 shareInstance];
}


- (id)copy {
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (void)sendSSID:(nonnull NSString *)ssid password:(nonnull NSString *)password {
    NSData *fskData = [FSKWav generateWithSSID:ssid password:password];
    if (nil == fskData) {
        return;
    }
    
    if (nil == _player) {
        _player = [[AudioQueuePlayer alloc] init];
    }
    
    [_player setStream:fskData];
    [_player setDelegate:self];
    [_player play];
}

- (void)stopSending {
    
    [_player stop];
}

- (void)audioQueuePlayFinished {
    
    if ([_delegate respondsToSelector:@selector(didFSKSendingComplete)]) {
        [_delegate didFSKSendingComplete];
    }
}

@end
