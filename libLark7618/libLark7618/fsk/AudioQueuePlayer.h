//
//  MainViewController.h
//  RawAudioDataPlayer
//
//  Created by SamYou on 12-8-18.
//  Copyright (c) 2012年 SamYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioQueuePlayerDelegate <NSObject>

/**
 播放完成回调
 */
- (void)audioQueuePlayFinished;

@end

@interface AudioQueuePlayer : NSObject
@property (nonatomic, retain) NSData *stream; // 需要播放的数据流
@property (nonatomic, retain) id <AudioQueuePlayerDelegate> delegate;

- (instancetype)initWithData:(NSData *)data delegate:(id)delegate;
- (void)play;
- (void)stop;

@end
