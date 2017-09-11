//
//  AppDelegate.h
//  PlayerSample
//
//  Created by lingqineng on 2017/9/6.
//  Copyright © 2017年 lingqineng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"

@protocol PlayVCDelegate <NSObject>
/**
 *  代理播放下一曲
 */
-(void)playNextMusic;
/**
 *  代理播放上一曲
 */
-(void)playPreviousMusic;
/**
 *  代理点击播放按钮
 */
-(void)clickPlayBtn;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PlayViewController * playVC;
@property (weak, nonatomic) id<PlayVCDelegate> playVCDelegate;

@end

