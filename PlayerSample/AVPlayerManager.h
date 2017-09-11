//
//  AVPlayerManager.h
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  播放模式枚举
 */
typedef NS_ENUM(NSUInteger, AVPlayerMode) {
    /**
     *  单曲循环
     */
    AVPlayerModeTrackLoop,
    /**
     *  列表循环
     */
    AVPlayerModeListLoop,
    /**
     *  随机播放
     */
    AVPlayerModeRandom,
};

@protocol trackPlayEndDelegate <NSObject>
/**
 *  曲目播放完成通知
 *
 *  @param notification 传递的notification
 */
- (void)trackPlayDidEnd:(NSNotification *)notification;

@end

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerManager : NSObject

/** 当前索引*/
@property (assign,nonatomic) NSInteger currentIndex;
/** 是否当前属于播放状态 */
@property (assign,nonatomic) BOOL isPlaying;
/** 自定义avplayer的播放器 */
@property (strong,nonatomic) AVPlayer * player;
/** 当前播放的avItem */
@property (strong,nonatomic) AVPlayerItem * currentMusicItem;
/** 维护播放队列的数组 */
@property (strong,nonatomic) NSMutableArray  * tracksArray;
/** 固定的有序播放队列 */
@property (strong,nonatomic) NSMutableArray  * orderedTracksArray;
/** 当前的播放模式 */
@property (assign,nonatomic) NSInteger trackPlayMode;
/** 判断是否为收藏夹曲目 */
@property (assign,nonatomic) BOOL isFavorite;
/** 播放结束通知 */
@property (weak,nonatomic) id<trackPlayEndDelegate> playEndDelegate;

/**
 *  初始化音乐播放器的单例
 *
 *  @return 单例manager
 */
+(AVPlayerManager *) manager;
/**
 *  重置音乐manager
 */
- (void)resetAudio;
/**
 *  初始化音乐播放manager
 */
- (void)playAudio;
/**
 *  播放当前音乐
 */
- (void)play;
/**
 *  暂停当前音乐
 */
- (void)pause;
/**
 *  上一首
 */
- (void)previous;
/**
 *  下一首
 */
- (void)next;
/**
 *  跳转到指定播放时间
 */
- (void)seekToTimeInterval:(NSTimeInterval)currentTime;

@end

