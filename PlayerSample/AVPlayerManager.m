//
//  AVPlayerManager.m
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import "AVPlayerManager.h"
#import <MJExtension.h>
#import "MusicModel.h"

@interface AVPlayerManager ()
/** 当前播放曲目 */
@property (strong,nonatomic) MusicModel * currentTrack;
@end

@implementation AVPlayerManager
- (instancetype)init{
    self = [super init];
    if (self) {
        [self backPlay];
    }
    return self;
}
+(AVPlayerManager *)manager{
    
    static AVPlayerManager * manager = nil;
    static dispatch_once_t predicte;
    dispatch_once (&predicte,^{
        manager = [[AVPlayerManager alloc]init];
    });
    return manager;
}

- (void)backPlay
{
    // 获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 设置会话类别为后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 激活会话
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)resetAudio{
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.isPlaying = NO;
    self.player = nil;
}

- (void)playAudio{
    if (!self.tracksArray.count) {
        return;
    }
    
    if ([AVAudioSession sharedInstance].category != AVAudioSessionCategoryPlayback) {
        [self backPlay];
    }
    
    self.currentTrack = self.tracksArray[self.currentIndex];
    NSString * url = [[NSBundle mainBundle] pathForResource:self.currentTrack.Filename ofType:nil];
    NSURL * musicUrl = [NSURL fileURLWithPath:url];
    self.currentMusicItem = [AVPlayerItem playerItemWithURL:musicUrl];
    [self.player replaceCurrentItemWithPlayerItem:self.currentMusicItem];
    [self.player play];
}
- (void)play{
    if ([AVAudioSession sharedInstance].category != AVAudioSessionCategoryPlayback) {
        [self backPlay];
    }
    
    if (!self.isPlaying) {
        [self.player play];
    }
    
    self.isPlaying = YES;
}

- (void)pause{
    if (self.isPlaying) {
        [self.player pause];
    }
    
    self.isPlaying = NO;
}

- (void)previous{
    self.currentIndex = [self.tracksArray indexOfObject:self.currentTrack];
    self.currentIndex --;
}

- (void)next{
    self.currentIndex = [self.tracksArray indexOfObject:self.currentTrack];
    self.currentIndex ++;
}

- (void)seekToTimeInterval:(NSTimeInterval)currentTime{
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark getter method
-(AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

-(NSMutableArray *)tracksArray{
    if (!_tracksArray) {
        _tracksArray = [[NSMutableArray alloc]init];
        _tracksArray = [MusicModel mj_objectArrayWithFilename:@"Music.plist"];
    }
    return _tracksArray;
}

-(NSMutableArray *)orderedTracksArray{
    if (!_orderedTracksArray) {
        _orderedTracksArray = [[NSMutableArray alloc]init];
        _orderedTracksArray = [MusicModel mj_objectArrayWithFilename:@"Music.plist"];
    }
    return _orderedTracksArray;
}

#pragma mark ------------------------------------ setter method -------------------------------------

- (void)setCurrentTrack:(id)currentTrack{
    _currentTrack = currentTrack;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < 0) {
        currentIndex = self.tracksArray.count - 1;
    }
    
    if (currentIndex > self.tracksArray.count - 1) {
        currentIndex = 0;
    }
    
    _currentIndex = currentIndex;
}

/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param currentMusicItem playerItem
 */
-(void)setCurrentMusicItem:(AVPlayerItem *)currentMusicItem{
    if (_currentMusicItem == currentMusicItem) {
        return;
    }
    if (_currentMusicItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentMusicItem];
        [_currentMusicItem removeObserver:self forKeyPath:@"status"];
    }
    _currentMusicItem = currentMusicItem;
    if (currentMusicItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:currentMusicItem];
        [currentMusicItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)trackPlayDidEnd:(NSNotification *)notification{
    if ([self.playEndDelegate respondsToSelector:@selector(trackPlayDidEnd:)]) {
        NSLog(@"发送代理");
        [self.playEndDelegate trackPlayDidEnd:notification];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"开始播放");
                self.isPlaying = YES;
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
            }
                break;
            default:
                break;
        }
    }
}

@end
